//
//  Tuji_Topic_Fav.m
//  zaol
//
//  Created by hark2046 on 13-3-7.
//
//

#import "Tuji_Topic_Fav.h"
#import "TDHHelper.h"
#import "UserInfoHelper.h"

@implementation Tuji_Topic_Fav

DEF_SINGLETON_ENGINE(Tuji_Topic_Fav);

- (MKNetworkOperation *)operationForAddWithTopicId:(NSString *)topicId
                                            itemId:(NSString *)itemId
                                 completionHandler:(ResponseBlock)completionBlock
                                      errorHandler:(MKNKErrorBlock)errorBlock
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:2];
    NSString * uid = [[UserInfoHelper userInfo] objectForKey:@"user_id"];
    [params setObject:uid forKey:@"user_id"];
    [params setObject:topicId forKey:@"topic_id"];
    [params setObject:itemId forKey:@"item_id"];
    
    [params setObject:@"taoke" forKey:@"content_type"];
    
    
    NSDictionary * systemParams = [TDHHelper api:@"tuji_topic_add_item" params:params];
    
    
    MKNetworkOperation * op = [self operationWithURLString:TDH_URL
                                                    params:systemParams
                                                httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseString], completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [[Tuji_Topic_Fav sharedInstance] enqueueOperation:op];
    
    NSLog(@"%@", systemParams);
    
    return op;

}

- (MKNetworkOperation *)operationForAddWithShopId:(NSString *)shopId
                                         itemText:(NSString *)itemText
                                           itemId:(NSString *)itemId
                                      shortUrlKey:(NSString *)shortUrlKey
                                           numIId:(NSString *)numIId
                                          topicId:(NSString *)topicId
                                           picUrl:(NSString *)picUrl
                                completionHandler:(ResponseBlock)completionBlock
                                     errorHandler:(MKNKErrorBlock)errorBlock
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:2];
    NSString * uid = [[UserInfoHelper userInfo] objectForKey:@"user_id"];
    [params setObject:uid forKey:@"user_id"];
    [params setObject:@"taoke" forKey:@"content_type"];
    [params setObject:shopId forKey:@"shop_id"];
    [params setObject:itemText forKey:@"item_text"];
    [params setObject:itemId forKey:@"item_id"];
    [params setObject:shortUrlKey forKey:@"short_url_key"];
    [params setObject:numIId forKey:@"num_iid"];
    [params setObject:topicId forKey:@"topic_id"];
    [params setObject:picUrl forKey:@"pic_url"];
    
    NSDictionary * systemParams = [TDHHelper api:@"tuji_topic_add_item" params:params];
    
    
    MKNetworkOperation * op = [self operationWithURLString:TDH_URL
                                                    params:systemParams
                                                httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseString], completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [[Tuji_Topic_Fav sharedInstance] enqueueOperation:op];
    
    NSLog(@"%@", systemParams);
    
    return op;
}

- (MKNetworkOperation *)operationForRemoveWithTopicId:(NSString *)topicId
                                               itemId:(NSString *)itemId
                                    completionHandler:(ResponseBlock)completionBlock
                                         errorHandler:(MKNKErrorBlock)errorBlock
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:2];
    NSString * uid = [[UserInfoHelper userInfo] objectForKey:@"user_id"];
    [params setObject:uid forKey:@"user_id"];
    [params setObject:itemId forKey:@"item_id"];
    [params setObject:topicId forKey:@"topic_id"];
    
    
    NSDictionary * systemParams = [TDHHelper api:@"tuji_topic_remove_items" params:params];
    
    
    MKNetworkOperation * op = [self operationWithURLString:TDH_URL
                                                    params:systemParams
                                                httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseString], completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [[Tuji_Topic_Fav sharedInstance] enqueueOperation:op];
    
    NSLog(@"%@", systemParams);
    
    return op;
    
    
}
@end
