//
//  GoodsDetailView.m
//  zaol
//
//  Created by hark2046 on 13-3-5.
//
//

#import "GoodsDetailView.h"
#import "CommonDef.h"

#import "UIImageView+WebCache.h"

#import "CCIconLabel.h"

#import <QuartzCore/QuartzCore.h>

const CGFloat kGoodsCellPadding = 5.0f;

@interface FavCountView : UIView

- (void)setText:(NSString *)text;

- (int)count;

@end

@implementation FavCountView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"fav_count_bg.png"]]];
        
        UILabel * countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [countLabel setTextAlignment:UITextAlignmentCenter];
        [countLabel setTextColor:[UIColor whiteColor]];
        [countLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [countLabel setTag:101];
        [countLabel setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:countLabel];
    }
    
    return self;
}

- (void)setText:(NSString *)text
{
    UILabel * lbl = (UILabel *)[self viewWithTag:101];
    
    [lbl setText:text];
}

- (int)count
{
    UILabel * lbl = (UILabel *)[self viewWithTag:101];
    return [lbl.text intValue];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UILabel * lbl = (UILabel *)[self viewWithTag:101];
    
    lbl.frame = CGRectMake(22, 0, self.frame.size.width - 27.0, self.frame.size.height);
}

@end


@interface GoodsDetailView()

@property (strong, nonatomic) UIView * contentView;
@property (strong, nonatomic) UIView * bottom;
@property (strong, nonatomic) UIImageView * picView;
@property (strong, nonatomic) UILabel * priceView;
@property (strong, nonatomic) CCIconLabel * volumne;

@property (strong, nonatomic) UILabel * titleView;

@property (strong, nonatomic) FavCountView * favView;

@property (strong, nonatomic) UIActivityIndicatorView * loadingView;

@end

@implementation GoodsDetailView


- (id)initWithPlaceholderImage:(UIImage *)placeholder andPrice:(NSString *)price
{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:rgba(240, 240, 240, 1)];
        
//        内容视图
        self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
//        [_contentView setFrame:CGRectMake(kGoodsCellPadding, kGoodsCellPadding, w, h)];
        
        self.bottom = [[UIView alloc] initWithFrame:CGRectZero];
        [_bottom setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"wave_bottom.png"]]];
        
        [_contentView addSubview:_bottom];
        
        self.picView = [[UIImageView alloc] initWithImage:placeholder];
        [_picView.layer setBorderColor:[rgba(240, 240, 240, 1) CGColor]];
        [_picView.layer setBorderWidth:1.0f];
        [_picView setClipsToBounds:YES];
        
        [_picView setContentMode:UIViewContentModeScaleAspectFill];
        
        [_contentView addSubview:_picView];
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        self.priceView = [[UILabel alloc] initWithFrame:CGRectZero];
        [_priceView setTextColor:rgba(234, 55, 58, 1)];
//        [_priceView setFont:[UIFont fontWithName:@"Georgia-Bold" size:20.0f]];
        [_priceView setFont:[UIFont boldSystemFontOfSize:22.0f]];
        [_priceView setTextAlignment:UITextAlignmentLeft];
        
        [_priceView setText:[NSString stringWithFormat:@"￥%@",price]];
        
        [_contentView addSubview:_priceView];
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        self.favView = [[FavCountView alloc] initWithFrame:CGRectZero];
        [_favView setText:@"0"];
        
        [_contentView addSubview:_favView];

        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        self.volumne = [[CCIconLabel alloc] initWithIcon:@"detail_buy_min.png" text:@"最近销量0件" textColor:rgba(153, 153, 153, 1) fontSize:10.0f];
        [_volumne setHidden:YES];
        
        [_contentView addSubview:_volumne];
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        self.buyButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buyButton setTitle:@"查看详情" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyButton setBackgroundColor:rgba(255, 59, 62, 1)];
        [[_buyButton titleLabel] setFont:[UIFont boldSystemFontOfSize:14.0f]];
        
        [_contentView addSubview:_buyButton];
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        self.titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleView setTextAlignment:UITextAlignmentLeft];
        [_titleView setTextColor:rgba(26, 26, 26, 1)];
        [_titleView setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleView setNumberOfLines:0];
        [_titleView setLineBreakMode:UILineBreakModeCharacterWrap];
        
        [_titleView setText:@"加载中..."];
        
        [_contentView addSubview:_titleView];
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        self.loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        [_loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [_loadingView startAnimating];
        
        [_contentView addSubview:_loadingView];
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////
        [self addSubview:_contentView];
        
    }
    return self;
}

- (void)setData:(DetailVO *)data
{
    if (_data != data) {
        _data = data;
        
        if (_data) {
            
            NSMutableString * picUrl = [NSMutableString stringWithString:data.pic_url];
            
            NSRange range1 = [_data.pic_url rangeOfString:@"mobile01"];
            NSRange range2 = [_data.pic_url rangeOfString:@"tdcms"];
            
            
            if (range1.location != NSNotFound) {
                [picUrl appendString:@"!weibo2"];
            }else if (range2.location != NSNotFound){
                [picUrl appendString:@"!weibo"];
            }
            
            __block GoodsDetailView * blockself = self;
            
            [_picView setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:_picView.image success:^(UIImage *image, BOOL cached) {
                [[[blockself->_contentView subviews] lastObject] removeFromSuperview];
                
                CATransition * animation = [CATransition animation];
                animation.duration = cached?0.15:0.3;
                animation.type = kCATransitionFade;
                animation.timingFunction = UIViewAnimationCurveEaseInOut;
                [blockself->_picView setImage:image];
                
                [blockself.layer addAnimation:animation forKey:@"animation"];
                
            } failure:^(NSError *error) {
                
            }];
            
            [_priceView setText:[NSString stringWithFormat:@"￥%@", _data.price]];
            
            if (_data.fav_count) {
                [_favView setText:_data.fav_count];
            }
            
            [_volumne setText:[NSString stringWithFormat:@"最近销量%@件",_data.volume]];
            
            [_titleView setText:_data.message];
            
            [self setNeedsLayout];
        }
    }
}

- (void)updateFavCount:(int)count
{
    [self.favView setText:[NSString stringWithFormat:@"%i", (_favView.count + count)]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = CGRectGetWidth(self.frame) - 2 * kGoodsCellPadding;
    CGFloat h = CGRectGetHeight(self.frame) - 2 * kGoodsCellPadding;
    
    [_contentView setFrame:CGRectMake(kGoodsCellPadding, kGoodsCellPadding, w, h)];
    [_bottom setFrame:CGRectMake(0, h - 10, w, 10)];
    [_picView setFrame:CGRectMake(0, 0, w, h - 100)];
    
    if ([self.loadingView superview]) {
        [self.loadingView setFrame:CGRectMake((w - 24.0)/2, (h - 100 - 24.0)/2, 24.0, 24.0)];
    }
    
//    if (_data) {
    
        CGSize priceSize = [_priceView.text sizeWithFont:_priceView.font];
        
        [_priceView setFrame:CGRectMake( kGoodsCellPadding, CGRectGetMaxY(_picView.frame) + kGoodsCellPadding, priceSize.width, 32)];
        
        [_favView setFrame:CGRectMake(kGoodsCellPadding * 2, CGRectGetMaxY(_picView.frame) - kGoodsCellPadding * 2 - 21.0f, 58.0f, 21.0f)];
        
        [_volumne setHidden:NO];  
        [_volumne setFrame:CGRectMake(CGRectGetMaxX(_priceView.frame) + kGoodsCellPadding, CGRectGetMinY(_priceView.frame) + 25 - CGRectGetHeight(_volumne.frame), CGRectGetWidth(_volumne.frame), CGRectGetHeight(_volumne.frame))];
        
        [_buyButton setFrame:CGRectMake(w - kGoodsCellPadding - 95.0f, CGRectGetMinY(_priceView.frame) + 5, 90.0f, 22.0f)];
        
        CGSize titleSize = [_titleView.text sizeWithFont:_titleView.font constrainedToSize:CGSizeMake(w - 2 * kGoodsCellPadding, CGFLOAT_MAX) lineBreakMode:_titleView.lineBreakMode];
        
        [_titleView setFrame:CGRectMake(kGoodsCellPadding, CGRectGetMaxY(_buyButton.frame) + kGoodsCellPadding, titleSize.width, titleSize.height)];
//    }
}

- (UIImage *)image
{
    return self.picView.image;
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
