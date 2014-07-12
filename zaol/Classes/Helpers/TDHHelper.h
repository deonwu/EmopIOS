//
//  TDHHelper.h
//  zaol
//
//  Created by li bin on 13-2-19.
//
//

#import <Foundation/Foundation.h>

@interface TDHHelper : NSObject

extern NSString * const TDH_HOST_NAME;
extern NSString * const TDH_PATH;
extern NSString * const TDH_URL;
//extern NSString * const TDH_ROUTE;
// 配置接口的接口参数，返回接口的系统参数
+ (NSDictionary *)api:(NSString *)method params:(NSDictionary *)params;

@end
