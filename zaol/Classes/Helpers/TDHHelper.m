//
//  TDHHelper.m
//  zaol
//
//  Created by li bin on 13-2-19.
//
//

#import "TDHHelper.h"
#import "NSString+MD5.h"
#import "JSONKit.h"

#define TDH_KEY     @"16"
#define TDH_SECRET  @"a006e1826c377881080882b6bea15b80"

NSString * const TDH_HOST_NAME = @"fmei.sinaapp.com/api";
NSString * const TDH_PATH = @"route";
NSString * const TDH_URL = @"http://fmei.sinaapp.com/api/route";

@implementation TDHHelper

+ (NSDictionary *)api:(NSString *)method params:(NSDictionary *)params
{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYYMMddHHmmss"];
    
    NSString * curr = [df stringFromDate:[NSDate date]];
    
    NSString * signString = [NSString stringWithFormat:@"%@,%@,%@",TDH_KEY, curr, TDH_SECRET];
//    NSLog(@"sign string: %@", signString);
    
    NSString * md5Sigh = [signString MD5Hash];
//    NSLog(@"sign md5: %@", md5Sigh);
    
    NSMutableDictionary * systemParams = [NSMutableDictionary dictionaryWithCapacity:5];
    [systemParams setObject:TDH_KEY forKey:@"app_id"];
    [systemParams setObject:method forKey:@"name"];
    [systemParams setObject:md5Sigh forKey:@"sign"];
    [systemParams setObject:curr forKey:@"time"];
    if (params) {
        [systemParams setObject:[params JSONString] forKey:@"params"];
    }
    
    return systemParams;
}

@end
