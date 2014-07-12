//
//  TopicViewItem.m
//  zaol
//
//  Created by hark2046 on 13-3-5.
//
//

#import "TopicViewItem.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonDef.h"

#import "UIImageView+WebCache.h"

const CGFloat kTopicViewItemPadding = 5.0f;
const CGFloat kTopicFrameShadowHeight = 4.0f;

@implementation TopicViewItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:rgba(230, 230, 230, 1)];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setClipsToBounds:YES];

        [self addSubview:_imageView];
    }
    return self;
}

- (void)setData:(GoodsVO *)data
{
    if (_data != data) {
        _data = data;
        
        if (_data){
            
            NSMutableString * picUrl = [NSMutableString stringWithString:_data.pic_url];
            
            NSRange range1 = [picUrl rangeOfString:@"mobile01.b0.upaiyun.com"];
            NSRange range2 = [picUrl rangeOfString:@"tdcms.b0.upaiyun.com"];
            
            if ([[UIScreen mainScreen] scale] > 1) {
                if (range1.location != NSNotFound || range2.location != NSNotFound) {
                    [picUrl appendString:@"!weibo"];
                }
            }else{
                if (range1.location != NSNotFound || range2.location != NSNotFound) {
                    [picUrl appendString:@"!190"];
                }
            }

            [_imageView setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"loading.png"]];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_imageView setFrame:CGRectMake(kTopicViewItemPadding, kTopicViewItemPadding, CGRectGetWidth(self.frame) - 2 * kTopicViewItemPadding, CGRectGetHeight(self.frame) - 2 * kTopicViewItemPadding - kTopicFrameShadowHeight)];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage * bgImage = [[UIImage imageNamed:@"theme_template_item_bg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    
    [bgImage drawInRect:rect];
}


@end
