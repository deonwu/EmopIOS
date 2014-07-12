//
//  kata_SliderPageControl.m
//  XiaoXiaoTao
//
//  Created by 黎 斌 on 12-6-19.
//  Copyright (c) 2012年 kata. All rights reserved.
//

#import "KATAPageControl.h"

#import <QuartzCore/QuartzCore.h>

@interface KATAPageControl()

- (void)updateDots;

@end

@implementation KATAPageControl

@synthesize imagePageStateNormal = _imagePageStateNormal;
@synthesize imagePageStateHighlighted = _imagePageStateHighlighted;


- (id)initWithFrame:(CGRect)frame background:(UIColor *)bg
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		if (bg) {
			self.backgroundColor = bg;
		}
		self.userInteractionEnabled = NO;
		CALayer * layer	=	self.layer;
		[layer setCornerRadius:3];
		[layer setMasksToBounds:YES];
		
    }
    return self;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
	[super setNumberOfPages:numberOfPages];
	
//	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width * numberOfPages / 2, 16);
}

- (void)setCurrentPage:(NSInteger)currentPage
{
	[super setCurrentPage:currentPage];
	[self updateDots];
}

- (void)setImagePageStateNormal:(UIImage *)img
{
	if (_imagePageStateNormal) {
		_imagePageStateNormal = nil;
	}
	
	_imagePageStateNormal = img;
	[self updateDots];
}

- (void)setImagePageStateHighlighted:(UIImage *)img
{
	if (_imagePageStateHighlighted) {
		_imagePageStateHighlighted = nil;
	}
	_imagePageStateHighlighted = img;
	[self updateDots];
}

- (void)updateDots
{
	if (_imagePageStateNormal || _imagePageStateHighlighted) {
		NSArray * subviews = self.subviews;
		for (unsigned i = 0 ; i < [subviews count]; i++) {
			UIImageView *dot = (UIImageView *)[subviews objectAtIndex:i];
			if (dot) {
				dot.image = (self.currentPage == i)?_imagePageStateHighlighted:_imagePageStateNormal;
			}
		}
	}
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
