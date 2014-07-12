//
//  Cms_Get_Uuid_Content_Engine.h
//  zaol
//
//  Created by hark2046 on 13-3-5.
//
//

#import "MKNetworkEngine.h"

#import "Bee_Singleton.h"

#import "BlockDef.h"

@interface Cms_Get_Uuid_Content_Engine : MKNetworkEngine

AS_SINGLETON_ENGINE(Cms_Get_Uuid_Content_Engine);

- (MKNetworkOperation *)operationWithUUID:(NSString *)uuid
                        completionHandler:(ResponseBlock)completionBlock
                             errorHandler:(MKNKErrorBlock)errorBlock;

@end
