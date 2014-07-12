//
//  HotspotCell.m
//  zaol
//
//  Created by hark2046 on 13-3-1.
//
//

#import "HotspotCell.h"

#import <QuartzCore/QuartzCore.h>

#import "CommonDef.h"

#import "UIImageView+WebCache.h"

const CGFloat kCoverPadding = 3.0f;

@interface HotspotCell()

//@property (strong, nonatomic) UIImageView * cover;
@property (strong, nonatomic) UILabel * titleView;

@end


@implementation HotspotCell

//@synthesize titleView = _titleView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
        CALayer * contentLayer = [[self contentView] layer];
        [contentLayer setBorderColor:[rgba(202, 202, 202, 1) CGColor]];
        [contentLayer setBorderWidth:1.0f];
        
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        
        [self.imageView setContentMode:UIViewContentModeScaleToFill];
        
    }
    return self;
}

- (void)setData:(ItemVO *)data
{
    if (_data != data) {
        _data = data;
        
        if (_data) {
            [self.imageView setImageWithURL:[NSURL URLWithString:_data.front_pic] placeholderImage:[UIImage imageNamed:@"loading.png"]];
            
            [self.titleView setText:_data.topic_name];
        }
    }
}

- (UILabel *)titleView
{
    if (!_titleView) {
        _titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [_titleView setTextAlignment:UITextAlignmentCenter];
        [_titleView setTextColor:[UIColor whiteColor]];
        [_titleView setFont:[UIFont systemFontOfSize:14.0f]];
        
        [_titleView setBackgroundColor:rgba(0, 0, 0, 0.4)];
        
        [self.contentView addSubview:_titleView];
    }
    return _titleView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView setFrame:CGRectMake(kCoverPadding, kCoverPadding, CGRectGetWidth(self.frame) - kCoverPadding * 2, CGRectGetHeight(self.frame) - kCoverPadding * 2)];
    
    [self.titleView setFrame:CGRectMake(kCoverPadding, CGRectGetHeight(self.frame) - kCoverPadding - 20.0f, CGRectGetWidth(self.frame) - 2 * kCoverPadding, 20.0f)];
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
