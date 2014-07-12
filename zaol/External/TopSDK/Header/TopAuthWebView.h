//
//  TopAuthWebView.h
//  TOPIOSSdk
//
//  Created by emerson_li on 13-1-22.
//  Copyright (c) 2013年 tmall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TopAuthWebViewToken:NSObject
    

@end
@interface TopAuthWebView : UIWebView

-(void) open:(TopAuthWebViewToken*)token;
-(void) close;

@end
