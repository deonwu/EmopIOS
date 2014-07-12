//
//  Cms_Get_Uuid_Content_Engine.m
//  zaol
//
//  Created by hark2046 on 13-3-5.
//
//

#import "Cms_Get_Uuid_Content_Engine.h"
#import "TDHHelper.h"

#import "UserInfoHelper.h"

@implementation Cms_Get_Uuid_Content_Engine

DEF_SINGLETON_ENGINE(Cms_Get_Uuid_Content_Engine);

- (MKNetworkOperation *)operationWithUUID:(NSString *)uuid
                        completionHandler:(ResponseBlock)completionBlock
                             errorHandler:(MKNKErrorBlock)errorBlock
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:2];
    
    NSString * uid = nil;
    
    if ([UserInfoHelper isUserBinded]) {
        uid = [[UserInfoHelper userInfo] objectForKey:@"user_id"];
    }else{
        uid = @"";
    }
    
    [params setObject:uid forKey:@"user_id"];
    [params setObject:uuid forKey:@"uuid"];
    
    
    NSDictionary * systemParams = [TDHHelper api:@"cms_get_uuid_content" params:params];
    
    
    MKNetworkOperation * op = [self operationWithURLString:TDH_URL
                                                    params:systemParams
                                                httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseString], completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [[Cms_Get_Uuid_Content_Engine sharedInstance] enqueueOperation:op];
    
    NSLog(@"%@", systemParams);
    
    return op;
}

@end
