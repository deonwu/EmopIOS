//
//  GoodsDetailView.h
//  zaol
//
//  Created by hark2046 on 13-3-5.
//
//

#import <UIKit/UIKit.h>

#import "DetailVO.h"

@interface GoodsDetailView : UIView

@property (strong, nonatomic) DetailVO * data;

@property (strong, nonatomic) UIButton * buyButton;

- (id)initWithPlaceholderImage:(UIImage *)placeholder andPrice:(NSString *)price;



- (void)updateFavCount:(int)count;


- (UIImage *)image;

@end
