//
//  kata_SliderPageControl.h
//  XiaoXiaoTao
//
//  Created by 黎 斌 on 12-6-19.
//  Copyright (c) 2012年 kata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KATAPageControl: UIPageControl

@property (nonatomic, strong) UIImage * imagePageStateNormal;
@property (nonatomic, strong) UIImage * imagePageStateHighlighted;

- (id)initWithFrame:(CGRect)frame background:(UIColor *)bg;

@end