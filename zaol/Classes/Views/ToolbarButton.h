//
//  ToolbarButton.h
//  zaol
//
//  Created by hark2046 on 13-3-18.
//
//

#import <UIKit/UIKit.h>

@interface ToolbarButton : UIControl

- (id)initWithTitle:(NSString *)title seletedTitle:(NSString *)selectedTitle image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * selectedTitle;
@property (strong, nonatomic) UIImage * image;
@property (strong, nonatomic) UIImage * selectedImage;

- (void)showSelectedStatus:(BOOL)value;

@end
