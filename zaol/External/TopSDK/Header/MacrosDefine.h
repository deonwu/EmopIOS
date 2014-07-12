//
//  MacrosDefine.h
//  TOPIOSSdk
//
//  Created by fangweng on 12-12-20.
//  Copyright (c) 2012年 tmall.com. All rights reserved.
//

#import <Foundation/Foundation.h>


#define TopAlert(_title, _message)   [[[[UIAlertView alloc] initWithTitle:_title \
message:_message \
delegate:nil \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil] autorelease] show]

