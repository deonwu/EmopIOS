//
//  Tuji_User_Topic_List_Engine.m
//  zaol
//
//  Created by li bin on 13-2-22.
//
//

#import "Tuji_User_Topic_List_Engine.h"
#import "TDHHelper.h"
#import "UserInfoHelper.h"
@implementation Tuji_User_Topic_List_Engine

DEF_SINGLETON_ENGINE(Tuji_User_Topic_List_Engine);

- (MKNetworkOperation *)operationWithPage:(int)page
                                 pageSize:(int)pageSize
                                     cate:(int)cate
                        completionHandler:(ResponseBlock)completionBlock
                             errorHandler:(MKNKErrorBlock)errorBlock
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setObject:@"2" forKey:@"user_id"];
    if (page)
        [params setObject:@(page) forKey:@"page_no"];
    [params setObject:@(cate) forKey:@"cate"];
    [params setObject:@"0" forKey:@"item_head_count"];
    [params setObject:@"site" forKey:@"scope"];
    [params setObject:@"1001" forKey:@"status"];
    [params setObject:@"topic_name,description,create_time,update_time,item_count,front_pic,view_order,status" forKey:@"fields"];
    if (pageSize)
        [params setObject:@(pageSize) forKey:@"page_size"];
    
    NSDictionary * systemParams = [TDHHelper api:@"tuji_user_topic_list" params:params];
    
    
    MKNetworkOperation * op = [self operationWithURLString:TDH_URL
                                                    params:systemParams
                                                httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseString], completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [[Tuji_User_Topic_List_Engine sharedInstance] enqueueOperation:op];
    
    return op;
}


- (MKNetworkOperation *)operationForFavWithCompletionHandler:(ResponseBlock)completionBlock
                                                errorHandler:(MKNKErrorBlock)errorBlock
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:2];
    NSString * uid = [[UserInfoHelper userInfo] objectForKey:@"user_id"];
    [params setObject:uid forKey:@"user_id"];
    [params setObject:@"1" forKey:@"cate"];
    [params setObject:@"收藏夹" forKey:@"topic_name"];
//    [params setObject:@"0" forKey:@"item_head_count"];
//    [params setObject:@"site" forKey:@"scope"];
    [params setObject:@"1001" forKey:@"status"];
//    [params setObject:@"topic_name,description,create_time,update_time,item_count,front_pic,view_order,status" forKey:@"fields"];
    
    NSDictionary * systemParams = [TDHHelper api:@"tuji_create_topic" params:params];
    
    
    MKNetworkOperation * op = [self operationWithURLString:TDH_URL
                                                    params:systemParams
                                                httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseString], completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [[Tuji_User_Topic_List_Engine sharedInstance] enqueueOperation:op];
    
    return op;

}

@end
