//
//  Tuji_Topic_Fav.h
//  zaol
//
//  Created by hark2046 on 13-3-7.
//
//

#import "MKNetworkEngine.h"
#import "Bee_Singleton.h"
#import "BlockDef.h"

@interface Tuji_Topic_Fav : MKNetworkEngine

AS_SINGLETON_ENGINE(Tuji_Topic_Fav);

- (MKNetworkOperation *)operationForAddWithTopicId:(NSString *)topicId
                                      itemId:(NSString *)itemId
                           completionHandler:(ResponseBlock)completionBlock
                                errorHandler:(MKNKErrorBlock)errorBlock;

- (MKNetworkOperation *)operationForAddWithShopId:(NSString *)shopId
                                         itemText:(NSString *)itemText
                                           itemId:(NSString *)itemId
                                      shortUrlKey:(NSString *)shortUrlKey
                                           numIId:(NSString *)numIId
                                          topicId:(NSString *)topicId
                                           picUrl:(NSString *)picUrl
                                completionHandler:(ResponseBlock)completionBlock
                                     errorHandler:(MKNKErrorBlock)errorBlock;

- (MKNetworkOperation *)operationForRemoveWithTopicId:(NSString *)topicId
                                               itemId:(NSString *)itemId
                           completionHandler:(ResponseBlock)completionBlock
                                errorHandler:(MKNKErrorBlock)errorBlock;

@end
