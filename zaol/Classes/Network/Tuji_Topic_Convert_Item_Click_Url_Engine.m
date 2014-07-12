//
//  Tuji_Topic_Convert_Item_Click_Url_Engine.m
//  zaol
//
//  Created by hark2046 on 13-3-3.
//
//

#import "Tuji_Topic_Convert_Item_Click_Url_Engine.h"

@implementation Tuji_Topic_Convert_Item_Click_Url_Engine

DEF_SINGLETON_ENGINE(Tuji_Topic_Convert_Item_Click_Url_Engine);


- (MKNetworkOperation *)operationWithPage:(int)page
                                 pageSize:(int)pageSize
                                    topic:(NSString *)topicId
                        completionHandler:(ResponseBlock)completionBlock
                             errorHandler:(MKNKErrorBlock)errorBlock
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:10];
    [params setObject:@"2" forKey:@"user_id"];
    [params setObject:@"11" forKey:@"track_user_id"];
    [params setObject:@(page) forKey:@"page_no"];
    [params setObject:@(pageSize) forKey:@"page_size"];
    [params setObject:topicId forKey:@"topic_id"];
    [params setObject:@"taoke" forKey:@"content_type"];
    [params setObject:@"id,pic_url,price,content_type,num_iid,shop_id,short_url_key,item_id,update_time,status" forKey:@"fields"];
    
    NSDictionary * systemParams = [TDHHelper api:@"tuji_topic_convert_item_click_url" params:params];
    
    NSLog(@"%@", systemParams);
    
    MKNetworkOperation * op = [self operationWithURLString:TDH_URL
                                                    params:systemParams
                                                httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseString], completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [[Tuji_Topic_Convert_Item_Click_Url_Engine sharedInstance] enqueueOperation:op];
    
    return op;

    
}

@end
