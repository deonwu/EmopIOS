//
//  MyTencentOAuth.m
//  zaol
//
//  Created by hark2046 on 13-3-12.
//
//

#import "MyTencentOAuth.h"
#import <TencentOpenAPI/TencentOAuthObject.h>

#import "Config.h"

static NSString* kGraphBaseURL = @"https://graph.qq.com/oauth2.0/";
static NSString* kRedirectURL = @"www.qq.com";
static NSString* kRestserverBaseURL = @"https://graph.qq.com/";

static NSString* kLogin = @"authorize";

@implementation MyTencentOAuth

- (NSMutableURLRequest *)authorizeForCustomWithPermissions:(NSArray *)permissions
{
    
    _permissions = permissions;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"token", @"response_type",
                                   self.appId, @"client_id",
                                   @"user_agent", @"type",
                                   _redirectURI, @"redirect_uri",
                                   @"mobile", @"display",
								   [NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"status_os",
								   [[UIDevice currentDevice] name],@"status_machine",
                                   @"v2.0",@"status_version",
								   
                                   nil];
    
    NSString * loginDialogURL = [kGraphBaseURL stringByAppendingString:kLogin];
    
    NSURL * url = [self generateURL:loginDialogURL params:params];
    
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:url];
    
    return req;
}

- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
	if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [params objectForKey:key];
			NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
																						  NULL, /* allocator */
																						  (CFStringRef)value,
																						  NULL, /* charactersToLeaveUnescaped */
																						  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																						  kCFStringEncodingUTF8));
			
			[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
		}
		
		NSString* query = [pairs componentsJoinedByString:@"&"];
		NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
        
		
		return [NSURL URLWithString:url];
	}
	else {
		return [NSURL URLWithString:baseURL];
	}
}


@end
