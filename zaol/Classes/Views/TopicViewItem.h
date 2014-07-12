//
//  TopicViewItem.h
//  zaol
//
//  Created by hark2046 on 13-3-5.
//
//

#import <UIKit/UIKit.h>

#import "GoodsVO.h"

@interface TopicViewItem : UIControl

@property (strong, nonatomic) GoodsVO * data;

@property (strong, nonatomic) UIImageView * imageView;
@end
