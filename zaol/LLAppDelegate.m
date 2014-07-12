//
//  LLAppDelegate.m
//  zaol
//
//  Created by Bin Li on 13-2-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "LLAppDelegate.h"

#import "ShoppingViewController.h"
#import "HotspotViewController.h"
#import "CategoryViewController.h"
#import "FavoriteViewController.h"
#import "SettingViewController.h"

#import "TopicDetailViewController.h"
#import "ListViewController.h"
#import "GoodsDetailViewController.h"
#import "WebDetailViewController.h"
#import "LoginViewController.h"
#import "LoginWithWeiboViewController.h"
#import "LoginWithQQViewController.h"
#import "LoginWithTaobaoViewController.h"

#import "WeiboShareViewController.h"

#import "UMNavigationController.h"

#import "AKTabBarController.h"

#import "SinaWeibo.h"

#import "Config.h"

#import "TopIOSClient.h"
#import "TopAppConnector.h"

//#import "BaiduMobStat.h"

#import <Parse/Parse.h>

@implementation LLAppDelegate

@synthesize window = _window;
@synthesize rootViewController = _rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [Parse setApplicationId:@"9XhFJwVFlFhxpIc8iQXIy3J8qUJx4AYIVzTETDxY"
                  clientKey:@"ljy9BLrdSZKfZphFcGO4DLlb09XZAGovxhiZnBN3"];
    
    //    注册本地通知
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
    [application setApplicationIconBadgeNumber:0];
    
//    初始化统计
//    BaiduMobStat * statTracker = [BaiduMobStat defaultStat];
//    statTracker.enableExceptionLog = NO;
//    statTracker.channelId = @"AppStore";
//    statTracker.logSendWifiOnly = YES;
//    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;
//    statTracker.sessionResumeInterval = 60.0;
//    
//    [statTracker startWithAppId:@"208ad1f809"];
    
//    初始化界面
//////////////////////////////////////////////////////////////    
    
    _rootViewController = [[AKTabBarController alloc] initWithTabBarHeight:49];
    [_rootViewController setMinimumHeightToDisplayTitle:40.0f];
    
    [_rootViewController setTabTitleIsHidden:NO];
    [_rootViewController setBackgroundImageName:@"nav_menu_bg.png"];
    [_rootViewController setSelectedBackgroundImageName:@"nav_menu_bg_selected.png"];
    [_rootViewController setTabEdgeColor:[UIColor colorWithWhite:0 alpha:0]];
    [_rootViewController setTabColors:@[[UIColor colorWithWhite:0 alpha:0],[UIColor colorWithWhite:0 alpha:0]]];
    [_rootViewController setSelectedTabColors:@[[UIColor colorWithWhite:0 alpha:0],[UIColor colorWithWhite:0 alpha:0]]];
    
    [_rootViewController setTabStrokeColor:[UIColor colorWithWhite:0 alpha:0]];
    
    [_rootViewController setTextColor:[UIColor colorWithWhite:1 alpha:0.8]];
    [_rootViewController setSelectedTextColor:[UIColor whiteColor]];
    
    [_rootViewController setIconGlossyIsHidden:YES];
    
    
//    注册URL和ViewController之间的对应关系
    [[UMNavigationController config] setValuesForKeysWithDictionary:
     [[NSDictionary alloc] initWithObjectsAndKeys:
      @"ShoppingViewController", @"tdh://shopping",
      @"TopicDetailViewController", @"tdh://topic",
      @"HotspotViewController", @"tdh://hotspot", 
      @"CategoryViewController", @"tdh://category",
      @"ListViewController", @"tdh://list",
      @"GoodsDetailViewController", @"tdh://goodsDetail",
      @"WebDetailViewController", @"tdh://webdetail",
      @"FavoriteViewController", @"tdh://favorite", 
      @"SettingViewController", @"tdh://setting",
      @"LoginViewController", @"tdh://login",
      @"LoginWithWeiboViewController", @"tdh://loginWithWeibo",
      @"WeiboShareViewController", @"tdh://shareWithWeibo",
      @"LoginWithQQViewController", @"tdh://loginWithQQ",
      @"LoginWithTaobaoViewController", @"tdh://loginWithTaobao",
      nil]];
    
//    navigations
    UMNavigationController * shoppingNav = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:@"tdh://shopping"]
                                                                                                          addParams:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"逛街", @""),@"title",
                                                                                                                     @"nav_menu_guang.png", @"icon",
                                                                                                                     @"nav_menu_guang.png", @"icon_selected",
                                                                                                                     @"Plain", @"style",nil]]];
    
    UMNavigationController * hotspotNav = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:@"tdh://hotspot"]
                                                                                                         addParams:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"热门", @""),@"title",
                                                                                                                    @"nav_menu_hot.png", @"icon",
                                                                                                                    @"nav_menu_hot.png", @"icon_selected", nil]]];
    
    UMNavigationController * categoryNav = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:@"tdh://category"]
                                                                                                          addParams:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"分类", @""),@"title",
                                                                                                                     @"nav_menu_cate.png", @"icon",
                                                                                                                     @"nav_menu_cate.png", @"icon_selected", nil]]];
    
    UMNavigationController * favoriteNav = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:@"tdh://favorite"]
                                                                                                          addParams:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"收藏", @""),@"title",
                                                                                                                     @"nav_menu_myfav.png", @"icon",
                                                                                                                     @"nav_menu_myfav.png", @"icon_selected", nil]]];
    
    UMNavigationController * settingNav = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:@"tdh://setting"]
                                                                                                         addParams:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"设置", @""),@"title",
                                                                                                                     @"nav_menu_setting.png", @"icon",
                                                                                                                     @"nav_menu_setting.png", @"icon_selected", @"Group", @"style",nil]]];
    
    [_rootViewController setViewControllers:[NSArray arrayWithObjects:
                                             shoppingNav,
                                             hotspotNav,
                                             categoryNav,
                                             favoriteNav,
                                             settingNav
                                             ,nil]];
    
    [self.window setRootViewController:_rootViewController];
    
    [self.window makeKeyAndVisible];
    
    
//    注册TOP接口相关
    TopIOSClient * topIOSClient = [TopIOSClient registerIOSClient:TaobaoAppKey appSecret:TaobaoAppSecret callbackUrl:@"callback://authresult" needAutoRefreshToken:YES];
    
    [TopAppConnector registerAppConnector:TaobaoAppKey topclient:topIOSClient];
    
//    向微信注册
    [WXApi registerApp:WeixinAppId];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    
    if ([[url absoluteString] rangeOfString:WeixinAppId].location != NSNotFound) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SSONotification object:nil userInfo:@{@"url": url}];
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    
    if ([[url absoluteString] rangeOfString:WeixinAppId].location != NSNotFound) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SSONotification object:nil userInfo:@{@"url": url}];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 
#pragma weixin

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) onReq:(BaseReq *)req
{
    
}

- (void) onResp:(BaseResp *)resp
{
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma Push

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [PFPush storeDeviceToken:deviceToken];
    
    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully subscribed to the broadcast channel.");
        } else {
            NSLog(@"Failed to subscribe to the broadcast channel.");
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}


@end
