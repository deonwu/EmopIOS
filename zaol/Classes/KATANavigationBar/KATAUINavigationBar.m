//
//  kata_UINavigationBar.m
//  CityStar
//
//  Created by 黎 斌 on 12-8-3.
//  Copyright (c) 2012年 kata. All rights reserved.
//

#import "KATAUINavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@interface KATAUINavigationBar ()
{
	__strong UIImage * customBgImage;
}

@end

@implementation KATAUINavigationBar

@synthesize navBgImageName = _navBgImageName;

//- (void)dealloc
//{
//	[_navBgImageName release];
//	_navBgImageName = nil;
//	
//	[customBgImage release];
//	customBgImage = nil;
//	
//	[super dealloc];
//}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setNavBgImageName:(NSString *)navBgImageName
{
	if (navBgImageName != _navBgImageName) {
//		[_navBgImageName release];
		_navBgImageName = navBgImageName;
		
        CGRect rect = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, self.bounds.size.height);
        
//		UIView * bgView = [[UIView alloc] initWithFrame:self.bounds];
		UIView * bgView = [[UIView alloc] initWithFrame:rect];
		
		UIImage * tmpImage = nil;
		
		bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:_navBgImageName]];
		
		UIGraphicsBeginImageContextWithOptions(bgView.frame.size, YES, 0);
		[bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
		tmpImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	
        customBgImage = tmpImage;
        
//		[bgView release];
/*
//      当前项目不需要圆角
//		将图片圆角
		float w = tmpImage.size.width * [UIScreen mainScreen].scale;
		float h = tmpImage.size.height * [UIScreen mainScreen].scale;
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
		
		CGRect rect = CGRectMake(0, 0, w, h);
		
		CGContextBeginPath(context);
		CGContextSaveGState(context);
		CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGContextScaleCTM(context, 5 * [UIScreen mainScreen].scale , 5 * [UIScreen mainScreen].scale);
		float fw = CGRectGetWidth(rect) / (5  * [UIScreen mainScreen].scale);
		float fh = CGRectGetHeight(rect) / (5  * [UIScreen mainScreen].scale);
		CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
		CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
		CGContextAddArcToPoint(context, 0, 0, 0, 0, 1); // Lower left corner
		CGContextAddArcToPoint(context, fw, 0, 0, 0, 1); // Back to lower right
		CGContextClosePath(context);
		CGContextRestoreGState(context);
		
		CGContextClip(context);
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), tmpImage.CGImage);
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		
//		if (customBgImage) {
//			[customBgImage release];
			customBgImage = nil;
//		}
		
		customBgImage = [[UIImage alloc] initWithCGImage:imageMasked];
		
//		[tmpImage release];
		CGImageRelease(imageMasked);
 
 */
		
	}else {
//		[_navBgImageName release];
		_navBgImageName = nil;
	}
	
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	if (customBgImage) {
		[customBgImage drawInRect:rect];
	}else {
		[super drawRect:rect];
	}
}

@end
