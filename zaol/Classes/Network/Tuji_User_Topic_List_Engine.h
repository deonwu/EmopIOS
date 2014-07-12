//
//  Tuji_User_Topic_List_Engine.h
//  zaol
//
//  Created by li bin on 13-2-22.
//
//

#import "MKNetworkEngine.h"
#import "Bee_Singleton.h"
#import "BlockDef.h"


@interface Tuji_User_Topic_List_Engine : MKNetworkEngine

AS_SINGLETON_ENGINE(Tuji_User_Topic_List_Engine);

//获取列表信息
- (MKNetworkOperation *)operationWithPage:(int)page
                                 pageSize:(int)pageSize
                                     cate:(int)cate
                        completionHandler:(ResponseBlock)completionBlock
                             errorHandler:(MKNKErrorBlock)errorBlock;

//获取收藏夹
- (MKNetworkOperation *)operationForFavWithCompletionHandler:(ResponseBlock)completionBlock
                                                errorHandler:(MKNKErrorBlock)errorBlock;

@end
