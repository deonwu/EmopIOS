//
//  Tuji_topic_item_list_engine.m
//  zaol
//
//  Created by hark2046 on 13-3-3.
//
//

#import "Tuji_topic_item_list_engine.h"
#import "TDHHelper.h"

@implementation Tuji_topic_item_list_engine

DEF_SINGLETON_ENGINE(Tuji_topic_item_list_engine);

- (MKNetworkOperation *)operationWithTopicId:(NSString *)topicId
                                      userId:(NSString *)userId
                                    pageSize:(NSString *)pageSize
                                        page:(NSString *)page
                           completionHandler:(ResponseBlock)completionBlock
                                errorHandler:(MKNKErrorBlock)errorBlock
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [params setObject:userId forKey:@"user_id"];
    
    [params setObject:topicId forKey:@"topic_id"];
    
    if (pageSize) 
        [params setObject:pageSize forKey:@"page_size"];
    
    if (page)
        [params setObject:page forKey:@"page_no"];
    
    [params setObject:@"id,text,pic_url,price,content_type,num_iid,shop_id,short_url_key,item_id,update_time,status" forKey:@"fields"];
    
    NSDictionary * systemParams = [TDHHelper api:@"tuji_topic_item_list" params:params];
    
    MKNetworkOperation * op = [self operationWithURLString:TDH_URL
                                                    params:systemParams
                                                httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseString], completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [[Tuji_topic_item_list_engine sharedInstance] enqueueOperation:op];
    
    return op;
    
}

@end
