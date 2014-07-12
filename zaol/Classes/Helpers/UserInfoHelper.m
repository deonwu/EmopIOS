//
//  UserInfoHelper.m
//  zaol
//
//  Created by hark2046 on 13-3-6.
//
//

#import "UserInfoHelper.h"
#import "LLAppDelegate.h"
#import "AKTabBarController.h"
#import "UMNavigationController.h"
#import "LoginViewController.h"

#import "TopIOSClient.h"

#import "Config.h"

static NSString * const kBindedUserInfoKey= @"BindedUserInfoKey";
static NSString * const kSinaWeiboDataKey = @"SinaWeiboAuthData";
static NSString * const kTencentDataKey    = @"TencentAuthData";
static NSString * const kTaobaoDataKey    = @"TaobaoAuthData";

static NSString * const kNeddRefreshFav = @"NeedRefreshFavKey";

static NSString * const kTopicIdKey = @"TopicId";

@implementation UserInfoHelper


+ (void)showLoginPage:(NSString *)source
{
    UMNavigationController * nav = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:@"tdh://login"]
                                                                                                  addParams:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"登陆", @""),@"title",
                                                                                                             @"nav_menu_guang.png", @"icon",
                                                                                                             @"nav_menu_guang.png", @"icon_selected",
                                                                                                             @"Plain", @"style",source,@"source",nil]]];
    
    [[(LLAppDelegate *)[[UIApplication sharedApplication] delegate] rootViewController] presentModalViewController:nav animated:YES];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma about status check

////////////////////////////////////////////////////////////////////////////////////
//是否已经绑定用户(即用户是否已经登陆)
+ (BOOL)isUserBinded
{
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kBindedUserInfoKey];
    return !!userInfo;
}

+ (BOOL)isNeedRefreshFav
{
    NSNumber * value = [[NSUserDefaults standardUserDefaults] objectForKey:kNeddRefreshFav];
    
    if (!value) {
        return NO;
    }
    
    return [value boolValue];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma getter

////////////////////////////////////////////////////////////////////////////////////
+ (NSDictionary *)userInfo
{
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kBindedUserInfoKey];
    return userInfo;
}

+ (NSString *)topicId
{
    NSString * topicId = [[NSUserDefaults standardUserDefaults] objectForKey:kTopicIdKey];
    
    return topicId;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma about data save && load

////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)storeUserBindInfo:(NSDictionary *)userInfo
{
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithCapacity:5];
    
    for (NSString * key in userInfo.allKeys) {
        [data setObject:[NSString stringWithFormat:@"%@",[userInfo objectForKey:key]] forKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kBindedUserInfoKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)removeUserBindInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBindedUserInfoKey];
    
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)storeNeedRefreshFav:(BOOL)need
{
    NSNumber * data = [NSNumber numberWithBool:need];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kNeddRefreshFav];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)storeTopicId:(NSString *)topicId
{
    [[NSUserDefaults standardUserDefaults] setObject:topicId forKey:kTopicIdKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)storeSinaWeiboAuthData:(SinaWeibo *)sinaweibo withUserName:(NSString *)userName
{
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:
                           sinaweibo.accessToken, @"AccessTokenKey",
                           sinaweibo.expirationDate, @"ExpirationDateKey",
                           sinaweibo.userID, @"UserIDKey",
                           userName, @"userName",nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kSinaWeiboDataKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)sinaWeiboAuthData
{
    NSDictionary * authData = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaWeiboDataKey];
    return authData;
}

+ (BOOL)removSinaWeiboAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSinaWeiboDataKey];
    
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)storeTencentAuthData:(TencentOAuth *)tencentOAuth withUserName:(NSString *)userName
{
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:
                           tencentOAuth.accessToken, @"AccessTokenKey",
                           tencentOAuth.expirationDate, @"ExpirationDateKey",
                           tencentOAuth.openId, @"UserIDKey",
                           userName, @"userName",nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kTencentDataKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)tencentAuthData
{
    NSDictionary * authData = [[NSUserDefaults standardUserDefaults] objectForKey:kTencentDataKey];
    return authData;
}

+ (BOOL)removTencentAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTencentDataKey];
    
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)storeTaobaoAuthData:(TopAuth *)topAuth
{
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:
                           topAuth.access_token, @"AccessTokenKey",
                           topAuth.mobile_token, @"mobile_token",
                           topAuth.refresh_token, @"refresh_token",
                           [NSString stringWithFormat:@"%i", topAuth.token_expire_time], @"ExpirationDateKey",
                           topAuth.user_id, @"UserIDKey",
                           topAuth.user_name, @"userName",nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kTaobaoDataKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)taobaoAuthData
{
    NSDictionary * authData = [[NSUserDefaults standardUserDefaults] objectForKey:kTaobaoDataKey];
    return authData;
}

+ (BOOL)removTaobaoAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTaobaoDataKey];
    
    return [[NSUserDefaults standardUserDefaults] synchronize];
}
////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma about logout

////////////////////////////////////////////////////////////////////////////////////
+ (void)taobaoLogout
{
    TopIOSClient * iosClient = [TopIOSClient getIOSClientByAppKey:TaobaoAppKey];
    
    NSDictionary * taobaoAuthData = [UserInfoHelper taobaoAuthData];
    
    [iosClient removeAuthByUserId:[taobaoAuthData objectForKey:@"UserIDKey"]];
    
    [UserInfoHelper removTaobaoAuthData];
}
+ (void)sinaWeiboLogout
{
    SinaWeibo * sinaweibo = [[SinaWeibo alloc] initWithAppKey:WeiboAppKey appSecret:WeiboSecret appRedirectURI:WeiboRedirectURI andDelegate:nil];
    
    NSDictionary * weiboAuthData = [UserInfoHelper sinaWeiboAuthData];
    if ([weiboAuthData objectForKey:@"AccessTokenKey"] && [weiboAuthData objectForKey:@"ExpirationDateKey"] && [weiboAuthData objectForKey:@"UserIDKey"])
    {
        sinaweibo.accessToken = [weiboAuthData objectForKey:@"AccessTokenKey"];
        sinaweibo.expirationDate = [weiboAuthData objectForKey:@"ExpirationDateKey"];
        sinaweibo.userID = [weiboAuthData objectForKey:@"UserIDKey"];
    }
    
    [sinaweibo logOut];
    
    [UserInfoHelper removSinaWeiboAuthData];
}

+ (void)tencentLogout
{
    TencentOAuth * tencentOauth = [[TencentOAuth alloc] initWithAppId:QQAppID andDelegate:nil];
    
    NSDictionary * tencentAuthData = [UserInfoHelper tencentAuthData];
    if ([tencentAuthData objectForKey:@"AccessTokenKey"] && [tencentAuthData objectForKey:@"ExpirationDateKey"] && [tencentAuthData objectForKey:@"UserIDKey"])
    {
        tencentOauth.accessToken = [tencentAuthData objectForKey:@"AccessTokenKey"];
        tencentOauth.expirationDate = [tencentAuthData objectForKey:@"ExpirationDateKey"];
        tencentOauth.openId = [tencentAuthData objectForKey:@"UserIDKey"];
    }
    
    [tencentOauth logout:nil];
    
    [UserInfoHelper removTencentAuthData];
}



@end
