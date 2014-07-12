//
//  Tuji_topic_item_list_engine.h
//  zaol
//
//  Created by hark2046 on 13-3-3.
//
//

#import "MKNetworkEngine.h"
#import "Bee_Singleton.h"
#import "BlockDef.h"

@interface Tuji_topic_item_list_engine : MKNetworkEngine

AS_SINGLETON_ENGINE(Tuji_topic_item_list_engine);

- (MKNetworkOperation *)operationWithTopicId:(NSString *)topicId
                                      userId:(NSString *)userId
                                    pageSize:(NSString *)pageSize
                                        page:(NSString *)page
                           completionHandler:(ResponseBlock)completionBlock
                                          errorHandler:(MKNKErrorBlock)errorBlock;


@end
