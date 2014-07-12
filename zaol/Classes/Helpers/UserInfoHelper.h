//
//  UserInfoHelper.h
//  zaol
//
//  Created by hark2046 on 13-3-6.
//
//

#import <Foundation/Foundation.h>
#import "SinaWeibo.h"
#import "TopAuth.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface UserInfoHelper : NSObject


+ (void)showLoginPage:(NSString *)source;
////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma about status check

////////////////////////////////////////////////////////////////////////////////////
//是否已经绑定用户(即用户是否已经登陆)
+ (BOOL)isUserBinded;

////////////////////////////////////////////////////////////////////////////////////
//是否需要刷新收藏
+ (BOOL)isNeedRefreshFav;


////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma getter

////////////////////////////////////////////////////////////////////////////////////
+ (NSDictionary *)userInfo;
+ (NSDictionary *)sinaWeiboAuthData;
+ (NSDictionary *)tencentAuthData;
+ (NSDictionary *)taobaoAuthData;
+ (NSString *)topicId;

////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma about data save && load

////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)storeUserBindInfo:(NSDictionary *)userInfo;
+ (BOOL)removeUserBindInfo;

+ (BOOL)storeNeedRefreshFav:(BOOL)need;

+ (BOOL)storeTopicId:(NSString *)topicId;

+ (BOOL)storeSinaWeiboAuthData:(SinaWeibo *)sinaweibo withUserName:(NSString *)userName;
+ (BOOL)removSinaWeiboAuthData;


+ (BOOL)storeTencentAuthData:(TencentOAuth *)tencentOAuth withUserName:(NSString *)userName;
+ (BOOL)removTencentAuthData;


+ (BOOL)storeTaobaoAuthData:(TopAuth *)topAuth;
+ (BOOL)removTaobaoAuthData;

////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma about logout

////////////////////////////////////////////////////////////////////////////////////
+ (void)taobaoLogout;
+ (void)sinaWeiboLogout;
+ (void)tencentLogout;

@end
