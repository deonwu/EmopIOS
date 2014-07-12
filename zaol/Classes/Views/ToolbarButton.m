//
//  ToolbarButton.m
//  zaol
//
//  Created by hark2046 on 13-3-18.
//
//

#import "ToolbarButton.h"
#import "CommonDef.h"

@implementation ToolbarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title seletedTitle:(NSString *)selectedTitle image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    self = [super init];
    if (self) {
        self.title = title;
        self.selectedTitle = selectedTitle;
        self.image = image;
        self.selectedImage = selectedImage;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        if (_title) {
            
            UILabel * lbl = (UILabel *)[self viewWithTag:101];
            if (!lbl) {
                lbl = [[UILabel alloc] initWithFrame:CGRectZero];
                [lbl setTextColor:rgba(155, 155, 155, 1)];
                [lbl setTextAlignment:UITextAlignmentCenter];
                [lbl setFont:[UIFont boldSystemFontOfSize:10.0f]];
                [lbl setBackgroundColor:[UIColor clearColor]];
                
                [lbl setTag:101];
                
                [self addSubview:lbl];
            }
            [lbl setText:_title];
        }
    }
}

- (void)setImage:(UIImage *)image
{
    if (_image != image) {
        _image = image;
        if (_image) {
            UIImageView * imgV = (UIImageView *)[self viewWithTag:102];
            if (!imgV) {
                imgV = [[UIImageView alloc] initWithImage:_image];
                [imgV setContentMode:UIViewContentModeScaleAspectFit];
                
                [imgV setTag:102];
                
                [self addSubview:imgV];
            }
        }
    }
}
- (void)showSelectedStatus:(BOOL)value
{
    
    UILabel * lbl = (UILabel *)[self viewWithTag:101];
    UIImageView * img = (UIImageView *)[self viewWithTag:102];
    if (value) {
        [lbl setTextColor:rgba(235, 89, 2, 1)];
        [lbl setText:self.selectedTitle];
        
        [img setImage:self.selectedImage];
    }else{
        [lbl setTextColor:rgba(155, 155, 155, 1)];
        [lbl setText:self.title];
        
        [img setImage:self.image];
    }
}

- (void)sizeToFit
{
    [super sizeToFit];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = CGRectGetWidth(self.frame);
//    CGFloat h = CGRectGetHeight(self.frame);
    
    CGFloat padding = 5.0f;
    
    
    UILabel * lbl = (UILabel *)[self viewWithTag:101];
    UIImageView * img = (UIImageView *)[self viewWithTag:102];
    
    [lbl sizeToFit];
    
    CGFloat iconWH = 20.0f;
    
    CGRect imgF = CGRectMake((w - iconWH) / 2.0, padding, iconWH,iconWH);
    CGRect lblF = CGRectMake(0, CGRectGetMaxY(imgF) + 2, w, CGRectGetHeight(lbl.frame));
    
    [lbl setFrame:lblF];
    [img setFrame:imgF];
    
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
