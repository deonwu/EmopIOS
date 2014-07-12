//
//  User_Bind_Login_Engine.m
//  zaol
//
//  Created by hark2046 on 13-3-7.
//
//

#import "User_Bind_Login_Engine.h"
#import "TDHHelper.h"
#import "UserInfoHelper.h"

@implementation User_Bind_Login_Engine

DEF_SINGLETON_ENGINE(User_Bind_Login_Engine);


- (MKNetworkOperation *)operationWithSource:(NSString *)s
                                   refId:(NSString*)refId
                            access_token:(NSString *)token
                       completionHandler:(ResponseBlock)completionBlock
                            errorHandler:(MKNKErrorBlock)errorBlock
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setObject:s forKey:@"source"];
    [params setObject:refId forKey:@"ref_id"];
    [params setObject:token forKey:@"access_token"];
    
    if ([UserInfoHelper isUserBinded]) {
        
        NSDictionary * userInfo = [UserInfoHelper userInfo];
        
        NSString * userId = [userInfo objectForKey:@"user_id"];
        
        if (userId && ![userId isEqualToString:@""]) {
            [params setObject:userId forKey:@"user_id"];
        }
    }
    
    NSDictionary * systemParams = [TDHHelper api:@"user_bind_login" params:params];
    
    
    MKNetworkOperation * op = [self operationWithURLString:TDH_URL
                                                    params:systemParams
                                                httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseString], completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [[User_Bind_Login_Engine sharedInstance] enqueueOperation:op];
    
    return op;
}

@end
