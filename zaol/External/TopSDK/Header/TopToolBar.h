//
//  ToolBar.h
//  TopTooBar
//
//  Created by lihao on 12-11-28.
//  Copyright (c) 2012年 lihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopBridgeWebview.h"

@protocol TopToolBarProtocol <NSObject>

-(void) willGotoPlatform;

-(void) willGotoPlugin;

@end

@interface TopToolBar : NSObject

@property(assign,nonatomic) id<TopToolBarProtocol> delegate;
@property(copy,nonatomic) NSString* appkey;
@property(copy,nonatomic) NSString* userId;


+(TopToolBar*) bindBaseView:(UIView*) baseView
                    withApp:(NSString*) app
                 tmallStyle:(bool) tmalluser;

+(TopToolBar*) bindBaseView:(UIView*) baseView
                    withApp:(NSString*) app
                 tmallStyle:(bool) tmalluser
                unreadCountFromUser:(NSString*) user;
+(TopToolBar*) getBindToolbar:(UIView*) baseView;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;
- (CGFloat)top ;
- (void)setTop:(CGFloat)y ;
- (CGFloat)left;
- (void)setLeft:(CGFloat)left;


- (void)bringToFront;
- (void)hidden:(bool)yesOrNo;
- (void)unbind;


@end



