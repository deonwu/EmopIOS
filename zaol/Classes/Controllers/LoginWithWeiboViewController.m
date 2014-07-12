//
//  LoginWithWeiboViewController.m
//  zaol
//
//  Created by hark2046 on 13-3-6.
//
//

#import "LoginWithWeiboViewController.h"
#import "Config.h"
#import "UserInfoHelper.h"
#import "SinaWeiboRequest.h"
#import "SinaWeiboConstants.h"

#import "MBProgressHUD.h"

@interface LoginWithWeiboViewController ()
@property (strong, nonatomic) UIActivityIndicatorView * loadingView;
@property (strong, nonatomic) UIWebView * mainView;
@property (strong, nonatomic) NSDictionary * authParams;

@property (strong, nonatomic) SinaWeibo * sinaweibo;

@end

@implementation LoginWithWeiboViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SSONotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary * info = [note userInfo];
        [self.sinaweibo handleOpenURL:[info objectForKey:@"url"]];
    }];
    
	// Do any additional setup after loading the view.
    [self.navigationItem setTitle:[self.query objectForKey:@"title"]];
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    
    [webView setDelegate:self];
    
    [self.view addSubview:webView];
    
    self.mainView = webView;
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [_loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [_loadingView setHidesWhenStopped:YES];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:_loadingView];
    [_loadingView startAnimating];
    
    self.navigationItem.rightBarButtonItem = item;
    
    self.sinaweibo = [[SinaWeibo alloc] initWithAppKey:WeiboAppKey appSecret:WeiboSecret appRedirectURI:WeiboRedirectURI andDelegate:self];
    
    [_sinaweibo setSsoCallbackScheme:SSOCallback];
    
    self.authParams = [_sinaweibo logInWithCustom];
    
    if(self.authParams){
        [self load];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////
- (void)load
{
    NSString *authPagePath = [SinaWeiboRequest serializeURL:kSinaWeiboWebAuthURL
                                                     params:_authParams httpMethod:@"GET"];
    [_mainView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authPagePath]]];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSLog(@"url = %@", url);
    
    NSString *siteRedirectURI = [NSString stringWithFormat:@"%@%@", kSinaWeiboSDKOAuth2APIDomain, [_authParams objectForKey:@"redirect_uri"]];
    
    if ([url hasPrefix:[_authParams objectForKey:@"redirect_uri"]] || [url hasPrefix:siteRedirectURI])
    {
        NSString *error_code = [SinaWeiboRequest getParamValueFromUrl:url paramName:@"error_code"];
        
        if (error_code)
        {
            NSString *error = [SinaWeiboRequest getParamValueFromUrl:url paramName:@"error"];
            NSString *error_uri = [SinaWeiboRequest getParamValueFromUrl:url paramName:@"error_uri"];
            NSString *error_description = [SinaWeiboRequest getParamValueFromUrl:url paramName:@"error_description"];
            
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       error, @"error",
                                       error_uri, @"error_uri",
                                       error_code, @"error_code",
                                       error_description, @"error_description", nil];
            
//            [delegate authorizeView:self didFailWithErrorInfo:errorInfo];
            
            [self.sinaweibo authorizeView:nil didFailWithErrorInfo:errorInfo];
        }
        else
        {
            NSString *code = [SinaWeiboRequest getParamValueFromUrl:url paramName:@"code"];
            if (code)
            {
//                [self hide];
//                [delegate authorizeView:self didRecieveAuthorizationCode:code];
                [self.sinaweibo authorizeView:nil didRecieveAuthorizationCode:code];
            }
        }
        
        return NO;
    }
    
    return YES;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma SinaWeiboDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
    
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSString * userName = [result objectForKey:@"screen_name"];
    
    if (![UserInfoHelper storeSinaWeiboAuthData:_sinaweibo withUserName:userName]) {
        NSLog(@"保存微博登陆信息出错");
        [self sinaweibo:_sinaweibo logInDidFailWithError:nil];
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SINA_WEIBO_LOGIN_SUCCESS object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    };
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [self sinaweibo:_sinaweibo logInDidFailWithError:nil];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"登录失败，请重试"];
    [hud hide:YES afterDelay:2.0f];
    
    [self.mainView reload];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"登录失败，请重试"];
    [hud hide:YES afterDelay:2.0f];
    
    [self.mainView reload];
}


//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma webview delegate

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.loadingView startAnimating];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingView stopAnimating];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.loadingView stopAnimating];
}

@end
