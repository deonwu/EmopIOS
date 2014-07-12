//
//  LoginWithQQViewController.m
//  zaol
//
//  Created by hark2046 on 13-3-7.
//
//

#import "LoginWithQQViewController.h"
#import "Config.h"
#import "UserInfoHelper.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuthObject.h>

#import "MyTencentOAuth.h"

#import "MBProgressHUD.h"

@interface LoginWithQQViewController ()

@property (strong, nonatomic) UIActivityIndicatorView * loadingView;
@property (strong, nonatomic) UIWebView * mainView;

@property (strong, nonatomic) NSArray * permissions;

//@property (strong, nonatomic) TencentOAuth * tencentOAuth;
@property (strong, nonatomic) MyTencentOAuth * tencentOAuth;

@end

@implementation LoginWithQQViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserverForName:SSONotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary * info = [note userInfo];
        [self.tencentOAuth handleOpenURL:[info objectForKey:@"url"]];
    }];
    
    
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
    
    //////////////////////////////////////////////
    //////////////////////////////////////////////
//    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppID andDelegate:self];
    self.tencentOAuth = [[MyTencentOAuth alloc] initWithAppId:QQAppID andDelegate:self];
    
    
    self.permissions = @[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,kOPEN_PERMISSION_GET_USER_INFO];
    
//    [self.tencentOAuth authorize:_permissions inSafari:NO];
    
    NSMutableURLRequest * req = [self.tencentOAuth authorizeForCustomWithPermissions:_permissions];
    
    [self.mainView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma webview delegate

//////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
	NSURL* url = request.URL;
    //	NSLog([NSString stringWithFormat:@"absolute url : %@", [url absoluteURL]]);
	
	NSRange start = [[url absoluteString] rangeOfString:@"access_token="];
	if (start.location != NSNotFound)
	{
		NSString * token = [self getStringFromUrl:[url absoluteString] needle:@"access_token="];
		NSString * expireTime = [self getStringFromUrl:[url absoluteString] needle:@"expires_in="];
		NSDate *expirationDate =nil;
        
		
		if (expireTime != nil) {
			int expVal = [expireTime intValue];
			if (expVal == 0) {
				expirationDate = [NSDate distantFuture];
			} else {
				expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
			}
		}
		
		if ((token == (NSString *) [NSNull null]) || (token.length == 0)) {
			if ([self respondsToSelector:@selector(tencentDidNotLogin:)]) {
				[self tencentDidNotLogin:NO];
			}
		} else {
            
            if ([self respondsToSelector:@selector(tencentDidLogin)]) {
                self.tencentOAuth.openId = [self getStringFromUrl:[url absoluteString] needle:@"openid="];
                self.tencentOAuth.accessToken = token;
                self.tencentOAuth.expirationDate = expirationDate;
            
                [self tencentDidLogin];
                
//				[self.tencentOAuth tencentDialogLogin:token expirationDate:expirationDate];
			}
		}
		return NO;
	}
	else
	{
		return YES;
	}
}

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
    
    if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
        
		if ([self respondsToSelector:@selector(tencentDidNotNetWork)]) {
			[self tencentDidNotNetWork];
		}
		
	}
}

/**
 * Find a specific parameter from the url
 */
- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle {
	NSString * str = nil;
	NSRange start = [url rangeOfString:needle];
	if (start.location != NSNotFound) {
		NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
		NSUInteger offset = start.location+start.length;
		str = end.location == NSNotFound
		? [url substringFromIndex:offset]
		: [url substringWithRange:NSMakeRange(offset, end.location)];
		str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	
	return str;
}
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma Tencent delegate

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tencentDidLogin
{
    if (![self.tencentOAuth getUserInfo]) {
        [self tencentDidNotLogin:NO];
    }
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    if (response.retCode == URLREQUEST_SUCCEED)
	{
        NSString * userName = [[response jsonResponse] objectForKey:@"nickname"];
        
        if (![UserInfoHelper storeTencentAuthData:self.tencentOAuth withUserName:userName]) {
            [self tencentDidNotLogin:NO];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:TENCENT_LOGIN_SUCCESS object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self tencentDidNotLogin:NO];
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (!cancelled) {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setLabelText:@"登录失败，请重试"];
        [hud hide:YES afterDelay:1.5f];
        [self performSelector:@selector(backToRoot) withObject:nil afterDelay:1.6];
    }else{
        [self backToRoot];
    }
    
}

- (void)backToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
