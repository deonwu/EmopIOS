//
//  CCIconLabel.h
//  CiCi
//  带icon的label
//  Created by funcity on 12-11-20.
//  Copyright (c) 2012年 Zhou Renjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCIconLabel : UIView

@property (strong, nonatomic) NSString * iconName;
@property (strong, nonatomic) NSString * text;

- (id)initWithIcon:(NSString *)iconName text:(NSString *)txt textColor:(UIColor *)tc fontSize:(CGFloat)fs;

- (void)isBold:(BOOL)value;

@end
