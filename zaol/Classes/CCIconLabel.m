//
//  CCIconLabel.m
//  CiCi
//
//  Created by funcity on 12-11-20.
//  Copyright (c) 2012年 Zhou Renjian. All rights reserved.
//

#import "CCIconLabel.h"
@interface CCIconLabel()
{
    UIImageView * iconView;
    UILabel * label;
    CGFloat _fs;
}
@end

@implementation CCIconLabel
@synthesize iconName = __iconName;
@synthesize text = __text;

- (id)initWithIcon:(NSString *)iconName text:(NSString *)txt textColor:(UIColor *)tc fontSize:(CGFloat)fs
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initialization code
        
        
        iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:iconView];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:fs];
        
        _fs = fs;
        
        label.textColor = tc;
        [label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:label];
        
        [self setIconName:iconName];
        [self setText:txt];
        
        [self sizeToFit];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (__iconName) {
        iconView.frame = CGRectMake(0, (CGRectGetHeight(self.frame) - CGRectGetHeight(iconView.frame))/2.0, CGRectGetWidth(iconView.frame), CGRectGetHeight(iconView.frame));
        label.frame = CGRectMake(CGRectGetMaxX(iconView.frame) + 2, 0, CGRectGetWidth(label.frame), CGRectGetHeight(self.frame));
    }else{
        label.frame = CGRectMake(0, 0, CGRectGetWidth(label.frame), CGRectGetHeight(label.frame));
    }
}
- (void)sizeToFit
{
    CGSize size = CGSizeZero;
    
    size.width = CGRectGetWidth(iconView.frame) + 3 + CGRectGetWidth(label.frame);
    size.height = MAX(CGRectGetHeight(iconView.frame), CGRectGetHeight(label.frame));
    
    CGRect rect = self.frame;
    rect.size = size;
    
    [self setFrame:rect];
}

- (void)setIconName:(NSString *)theIconName
{
    if (__iconName != theIconName) {
//        [__iconName release];
//        __iconName = [theIconName retain];
        __iconName = nil;
        __iconName = theIconName;
    }
    if (__iconName) {
        UIImage * icon = [UIImage imageNamed:__iconName];
        iconView.image = icon;
        [iconView sizeToFit];
        
    }else{
        iconView.image = nil;
        iconView.frame = CGRectZero;
    }
    [self sizeToFit];
}
- (void)setText:(NSString *)theText
{
    if (__text != theText) {
//        [__text release];
//        __text = [theText retain];
        __text = nil;
        __text = theText;
    }
    label.text = __text;
    [label sizeToFit];
    
    [self sizeToFit];
}

- (void)isBold:(BOOL)value
{
    if (value) {
        [label setFont:[UIFont boldSystemFontOfSize:_fs]];
    }else{
        [label setFont:[UIFont systemFontOfSize:_fs]];
    }
    [self sizeToFit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
