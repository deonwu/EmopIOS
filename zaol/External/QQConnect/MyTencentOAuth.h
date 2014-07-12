//
//  MyTencentOAuth.h
//  zaol
//
//  Created by hark2046 on 13-3-12.
//
//

#import <TencentOpenAPI/TencentOAuth.h>

@interface MyTencentOAuth : TencentOAuth

- (NSMutableURLRequest *)authorizeForCustomWithPermissions:(NSArray *)permissions;

- (void)tencentDialogLogin:(NSString *)token expirationDate:(NSDate *)expirationDate;

@end
