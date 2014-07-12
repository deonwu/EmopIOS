//
//  ErrorView.h
//  zaol
//
//  Created by hark2046 on 13-2-27.
//
//

#import <UIKit/UIKit.h>

@interface ErrorView : UIView
{
   __strong UIImageView * _imageView;
   __strong UILabel * _titleView;
   __strong UILabel * _subtitleView;
}
@property (strong, nonatomic) UIImage * image;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * subtitle;
@property (strong, nonatomic) UIButton * reloadButton;

/**
 * 创建View
 */

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image;

/**
 * 添加reload按钮
 */
- (void)addReloadButton;

@end
