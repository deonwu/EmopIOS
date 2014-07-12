//
//  User_Bind_Login_Engine.h
//  zaol
//
//  Created by hark2046 on 13-3-7.
//
//

#import "MKNetworkEngine.h"

#import "Bee_Singleton.h"
#import "BlockDef.h"

@interface User_Bind_Login_Engine : MKNetworkEngine

AS_SINGLETON_ENGINE(User_Bind_Login_Engine);

- (MKNetworkOperation *)operationWithSource:(NSString *)s
                                   refId:(NSString*)refId
                            access_token:(NSString *)token
                       completionHandler:(ResponseBlock)completionBlock
                            errorHandler:(MKNKErrorBlock)errorBlock;

@end
