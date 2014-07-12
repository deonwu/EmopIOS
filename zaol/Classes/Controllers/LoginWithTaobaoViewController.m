//
//  LoginWithTaobaoViewController.m
//  zaol
//
//  Created by hark2046 on 13-3-7.
//
//

#import "LoginWithTaobaoViewController.h"
#import "Config.h"
#import "UserInfoHelper.h"
#import "MBProgressHUD.h"
@interface LoginWithTaobaoViewController ()

@property (strong, nonatomic) UIActivityIndicatorView * loadingView;
@property (strong, nonatomic) TopAuthWebView * mainView;
@property (strong, nonatomic) TopIOSClient * iosClient;
@end

@implementation LoginWithTaobaoViewController

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
        
        NSURL * urls = (NSURL * )[info objectForKey:@"url"];
        
        if ([[urls absoluteString] rangeOfString:@"top_sign"].location == NSNotFound) {
            return ;
        }
        
        [[TopAppConnector getAppConnectorbyAppKey:TaobaoAppKey]  receiveMessageFromApp:[urls absoluteString]];
        
        [self auth];
        
    }];
    
    
    [self.navigationItem setTitle:[self.query objectForKey:@"title"]];
    
    TopAuthWebView * webView = [[TopAuthWebView alloc] initWithFrame:self.view.bounds];
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
    
    [self auth];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)auth
{
    
    self.iosClient = [TopIOSClient getIOSClientByAppKey:TaobaoAppKey];
    
    id result = [_iosClient auth:self cb:@selector(authCallback:)];
    
    if ([result isMemberOfClass:[TopAuthWebViewToken class]]) {
        [self.mainView open:result];
    }
}

- (void)authCallback:(id)data
{
    if ([data isKindOfClass:[TopAuth class]]){
        
        [UserInfoHelper storeTaobaoAuthData:data];
        [[NSNotificationCenter defaultCenter] postNotificationName:TAOBAO_LOGIN_SUCCESS object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
