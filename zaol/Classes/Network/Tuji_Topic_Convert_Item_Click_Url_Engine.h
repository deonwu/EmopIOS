//
//  Tuji_Topic_Convert_Item_Click_Url_Engine.h
//  zaol
//
//  Created by hark2046 on 13-3-3.
//
//

#import "MKNetworkEngine.h"

#import "Bee_Singleton.h"
#import "BlockDef.h"

@interface Tuji_Topic_Convert_Item_Click_Url_Engine : MKNetworkEngine

AS_SINGLETON_ENGINE(Tuji_Topic_Convert_Item_Click_Url_Engine);

- (MKNetworkOperation *)operationWithPage:(int)page
                                 pageSize:(int)pageSize
                                    topic:(NSString *)topicId
                        completionHandler:(ResponseBlock)completionBlock
                             errorHandler:(MKNKErrorBlock)errorBlock;

@end
