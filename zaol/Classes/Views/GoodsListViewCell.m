//
//  GoodsListViewCell.m
//  zaol
//
//  Created by hark2046 on 13-3-3.
//
//

#import "GoodsListViewCell.h"

#import "GoodsVO.h"

#import "UIImageView+WebCache.h"
#import "CommonDef.h"

#import <QuartzCore/QuartzCore.h>

const int kGoodsPicTag = 101;
const int kGoodsPriceTag = 102;
const CGFloat kPricePadding = 3.0f;

@implementation GoodsListViewCell

+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth
{
    CGFloat h = columnWidth / [[(GoodsVO *)object rect_rate] floatValue];
    
    return h;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:rgba(249, 249, 249, 1)];
        
        _goodsPicView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_goodsPicView setContentMode:UIViewContentModeScaleAspectFit];
        [_goodsPicView setClipsToBounds:YES];
        
        [_goodsPicView setTag:kGoodsPicTag];
        
        [self addSubview:_goodsPicView];
        
        
        UILabel * priceView = [[UILabel alloc] initWithFrame:CGRectZero];
        [priceView setTextColor:[UIColor whiteColor]];
        [priceView setTextAlignment:UITextAlignmentCenter];
        [priceView setFont:[UIFont systemFontOfSize:11.0f]];
        [priceView setBackgroundColor:rgba(0, 0, 0, 0.3)];
        
        [priceView.layer setCornerRadius:4.0f];
        [priceView.layer setMasksToBounds:YES];
        
        [priceView setTag:kGoodsPriceTag];
        
        [self addSubview:priceView];
        
    }
    return self;
}

- (void)setObject:(id)object
{
    [super setObject:object];
    
    if (object) {
        GoodsVO * vo = (GoodsVO *)object;
        
        NSMutableString * picUrl = [NSMutableString stringWithString:vo.pic_url];
        
        NSRange range1 = [picUrl rangeOfString:@"mobile01.b0.upaiyun.com"];
        NSRange range2 = [picUrl rangeOfString:@"tdcms.b0.upaiyun.com"];
        
        if ([[UIScreen mainScreen] scale] > 1) {
            if (range1.location != NSNotFound || range2.location != NSNotFound) {
                [picUrl appendString:@"!190"];
            }
        }else{
            if (range1.location != NSNotFound || range2.location != NSNotFound) {
                [picUrl appendString:@"!small"];
            }
        }
        
        [_goodsPicView setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"loading.png"]];
        
        UILabel * priceView = (UILabel *)[self viewWithTag:kGoodsPriceTag];
        priceView.text = [NSString stringWithFormat:@"￥%.0f", [vo.price floatValue]];
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.object) {
        
        _goodsPicView.frame = self.bounds;
        
        
        UILabel * priceView = (UILabel *)[self viewWithTag:kGoodsPriceTag];
        [priceView sizeToFit];
        
        CGFloat w = CGRectGetWidth(self.frame);
        CGFloat h = CGRectGetHeight(self.frame);
        
        [priceView setFrame:CGRectMake(w - CGRectGetWidth(priceView.frame) - kPricePadding * 3, h - CGRectGetHeight(priceView.frame) - kPricePadding, CGRectGetWidth(priceView.frame) + kPricePadding * 2, CGRectGetHeight(priceView.frame))];
    }
    
}

- (void)prepareForReuse
{
    
    [_goodsPicView cancelCurrentImageLoad];
    
    UILabel * priceView = (UILabel *)[self viewWithTag:kGoodsPriceTag];
    [priceView setText:@""];
    
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
