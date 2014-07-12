//
//  SettingCell.m
//  zaol
//
//  Created by hark2046 on 13-3-8.
//
//

#import "SettingCell.h"

@implementation SettingCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.image) {
        
        [self.imageView setFrame:CGRectMake(8, (CGRectGetHeight(self.frame) - 17)/2.0 , 17, 17)];
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
