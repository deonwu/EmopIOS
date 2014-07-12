//
//  LoginViewController.m
//  zaol
//
//  Created by hark2046 on 13-3-6.
//
//

#import "LoginViewController.h"
#import "LoginWithWeiboViewController.h"
#import "LoginWithQQViewController.h"
#import "LoginWithTaobaoViewController.h"

#import "UserInfoHelper.h"

#import "Config.h"
#import "JSONKit.h"
#import "User_Bind_Login_Engine.h"

#import "MBProgressHUD.h"


@interface LoginBtn:UIControl
{
    UIImageView * _imageView;
    UILabel * _titleView;
}

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image withTitle:(NSString *)titleStr;
@end

@implementation LoginBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image withTitle:(NSString *)titleStr
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithImage:image];
        _titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleView setTextAlignment:UITextAlignmentCenter];
        [_titleView setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [_titleView setText:titleStr];
        
        [self addSubview:_imageView];
        [self addSubview:_titleView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_imageView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
    [_titleView setFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetHeight(_imageView.frame))];
    
}

@end

@interface LoginViewController ()

- (void)loginWithWeibo;
- (void)loginWithTaobao;
- (void)loginWithQQ;

- (void)cancel;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"登陆"];
//    增加监听
    [[NSNotificationCenter defaultCenter] addObserverForName:SINA_WEIBO_LOGIN_SUCCESS object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSDictionary * authData = [UserInfoHelper sinaWeiboAuthData];
        
        [self bindUserWithSource:@"sina" refId:[authData objectForKey:@"UserIDKey"] token:[authData objectForKey:@"AccessTokenKey"]];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:TENCENT_LOGIN_SUCCESS object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSDictionary * authData = [UserInfoHelper tencentAuthData];
        
        [self bindUserWithSource:@"qq" refId:[authData objectForKey:@"UserIDKey"] token:[authData objectForKey:@"AccessTokenKey"]];
        
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:TAOBAO_LOGIN_SUCCESS object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSDictionary * authData = [UserInfoHelper taobaoAuthData];
        
        [self bindUserWithSource:@"taobao" refId:[authData objectForKey:@"UserIDKey"] token:[authData objectForKey:@"AccessTokenKey"]];
        
    }];
    
//    返回按钮
    UIButton * backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
	[backBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	[backBarButton setBackgroundImage:[UIImage imageNamed:@"back_active.png"] forState:UIControlStateHighlighted];
	
	[backBarButton addTarget:self
					  action:@selector(cancel)
			forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
	backBarButtonItem.style = UIBarButtonItemStylePlain;
    
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    UILabel * titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 80)];
    [titleLbl setText:@"----------用以下方式互联登陆----------"];
    [titleLbl setTextColor:[UIColor grayColor]];
    [titleLbl setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [titleLbl setTextAlignment:UITextAlignmentCenter];
    
    [self.view addSubview:titleLbl];
    
    
    LoginBtn * loginWithTaobaoBtn = [[LoginBtn alloc] initWithFrame:CGRectMake(40, 80, 54, 80) withImage:[UIImage imageNamed:@"btn_taobao_login.png"] withTitle:@"淘宝"];
    
    [loginWithTaobaoBtn addTarget:self action:@selector(loginWithTaobao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginWithTaobaoBtn];
    
    
    LoginBtn * loginWithQQBtn = [[LoginBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loginWithTaobaoBtn.frame) + 34, 80, 54, 80) withImage:[UIImage imageNamed:@"btn_qq_login.png"] withTitle:@"QQ"];
    
    [loginWithQQBtn addTarget:self action:@selector(loginWithQQ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginWithQQBtn];
    
    
    LoginBtn * loginWithSinaBtn = [[LoginBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loginWithQQBtn.frame) + 34, 80, 54, 80) withImage:[UIImage imageNamed:@"btn_sina_login.png"] withTitle:@"新浪微博"];
    
    [loginWithSinaBtn addTarget:self action:@selector(loginWithWeibo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginWithSinaBtn];
    
    
    
    
    NSString * source = [self.params objectForKey:@"source"];
    if (source && [source isEqualToString:@"taobao"]) {
        [self  loginWithTaobao];
    }else if (source && [source isEqualToString:@"sinaWeibo"]){
        [self loginWithWeibo];
    }else if(source && [source isEqualToString:@"qq"]){
        [self loginWithQQ];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
//        if (![UserInfoHelper isUserBinded]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_CANCEL object:nil userInfo:nil];
//        }
        
    }];
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma bind user
//////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma Login
//////////////////////////////////////////////////////////////////////////////
- (void)loginWithWeibo
{
    LoginWithWeiboViewController * vc = [[LoginWithWeiboViewController alloc] initWithURL:[NSURL URLWithString:@"tdh://loginWithWeibo"] query:@{@"title":@"使用新浪微博登录"}];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loginWithTaobao
{
    LoginWithTaobaoViewController * vc = [[LoginWithTaobaoViewController alloc] initWithURL:[NSURL URLWithString:@"tdh://loginWithTaobao"] query:@{@"title":@"使用淘宝账号登录"}];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loginWithQQ
{
    
    LoginWithQQViewController * vc = [[LoginWithQQViewController alloc] initWithURL:[NSURL URLWithString:@"tdh://loginWithQQ"] query:@{@"title":@"使用QQ登录"}];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bindUserWithSource:(NSString *)s refId:(NSString *)refId token:(NSString *)token
{
    User_Bind_Login_Engine * engine = [User_Bind_Login_Engine sharedInstance];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"绑定用户中...";
    
    [engine operationWithSource:s refId:refId
                   access_token:token
              completionHandler:^(NSString *response, MKNetworkOperation *op) {
        
                  NSLog(@"Response For User Bind:");
                  NSLog(@"%@", response);
                  
                  NSDictionary * userInfo = [response objectFromJSONString];
                  
                  if ([[userInfo objectForKey:@"status"] isEqualToString:@"ok"]) {
                      
                      NSDictionary * userData = [userInfo objectForKey:@"data"];
                      
                      if ([UserInfoHelper storeUserBindInfo:userData]) {
                          
                          hud.labelText = @"绑定成功";
                          [hud hide:YES afterDelay:1.5];
                          
                          [self performSelector:@selector(bindSuccess) withObject:self afterDelay:1.7];
                      }else{
                          hud.labelText = @"绑定失败,请重试";
                          [hud hide:YES afterDelay:1.5];
                      }
                  }else{
                      
                      NSString * code = [userInfo objectForKey:@"code"];
                      
                      if ([code isEqualToString:@"not_found_user"]) {
                          hud.labelText = @"没有找到指定的用户";
                      }else if ([code isEqualToString:@"aleady_bind_other"]){
                          hud.labelText = @"该账户已经绑定到其他fmei用户ID";
                      }else{
                          hud.labelText = @"绑定失败,请重试";
                      }
                      
                      [hud hide:YES afterDelay:1.5];
                      
                  }
                  
    }
                   errorHandler:^(NSError *error) {
                       
                       hud.labelText = @"绑定失败,请重试";
                       [hud hide:YES afterDelay:1.5];
    }];
}

- (void)bindSuccess
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_BINDED object:nil];
    }];
}

@end
