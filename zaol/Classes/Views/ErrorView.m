//
//  ErrorView.m
//  zaol
//
//  Created by hark2046 on 13-2-27.
//
//

#import "ErrorView.h"
#import "CommonDef.h"

static const CGFloat kVPadding1 = 30.0f;
static const CGFloat kVPadding2 = 10.0f;
static const CGFloat kVPadding3 = 15.0f;
static const CGFloat kHPadding  = 10.0f;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ErrorView

@synthesize reloadButton = _reloadButton;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addReloadButton
{
    _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reloadButton setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
    [_reloadButton sizeToFit];
    [self addSubview:_reloadButton];
    
    [self setNeedsLayout];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _imageView = [[UIImageView alloc] init];
        [_imageView setContentMode:UIViewContentModeCenter];
        [self addSubview:_imageView];
        
        _titleView = [[UILabel alloc] init];
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.textColor = rgba(96, 103, 111, 1);
        _titleView.font = [UIFont boldSystemFontOfSize:18];
        _titleView.textAlignment = UITextAlignmentCenter;
        [self addSubview:_titleView];
        
        _subtitleView = [[UILabel alloc] init];
        _subtitleView.backgroundColor = [UIColor clearColor];
        _subtitleView.textColor = rgba(96, 103, 111, 1);
        _subtitleView.font = [UIFont boldSystemFontOfSize:12];
        _subtitleView.textAlignment = UITextAlignmentCenter;
        _subtitleView.numberOfLines = 0;
        [self addSubview:_subtitleView];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image
{
    self = [self init];
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
        self.image = image;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 
#pragma mark layout uiview


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    CGRect subtitleViewFrame = _subtitleView.frame;
    subtitleViewFrame.size = [_subtitleView sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) - kHPadding * 2, 0)];
    _subtitleView.frame = subtitleViewFrame;
    
    [_titleView sizeToFit];
    [_imageView sizeToFit];
    
    CGFloat maxHeight = CGRectGetHeight(_imageView.frame) + CGRectGetHeight(_titleView.frame) + CGRectGetHeight(_subtitleView.frame) + kVPadding1 +  kVPadding2;

    BOOL canShowImage = _imageView.image && (CGRectGetHeight(self.frame) > maxHeight);
    
    CGFloat totalHeight = 0.0;
    
    if (canShowImage) {
        totalHeight += _imageView.frame.size.height;
    }
    
    if (_titleView.text.length) {
        totalHeight += ( totalHeight?kVPadding1:0 ) + CGRectGetHeight(_titleView.frame);
    }
    
    if (_subtitleView.text.length) {
        totalHeight += ( totalHeight?kVPadding2:0 ) + CGRectGetHeight(_subtitleView.frame);
    }
    
    totalHeight += (totalHeight ? kVPadding3 : 0) + CGRectGetHeight(_reloadButton.frame);
    
    CGFloat top = floor(CGRectGetHeight(self.frame) / 2 - totalHeight / 2);
    
    if (canShowImage) {
        _imageView.frame = CGRectMake(floor(CGRectGetWidth(self.frame) / 2 - CGRectGetWidth(_imageView.frame) / 2), top, CGRectGetWidth(_imageView.frame), CGRectGetHeight(_imageView.frame));
        _imageView.hidden = NO;
        top += CGRectGetHeight(_imageView.frame) + kVPadding1;
    } else {
        _imageView.hidden = YES;
    }
    
    if (_titleView.text.length) {
        CGRect titleViewFrame = _titleView.frame;
        titleViewFrame.origin = CGPointMake(floor(CGRectGetWidth(self.frame) / 2 - CGRectGetWidth(_titleView.frame) / 2), top);
        _titleView.frame = titleViewFrame;
        
        top += CGRectGetHeight(_titleView.frame) + kVPadding2;
    }
    
    if (_subtitleView.text.length) {
        CGRect subtitleViewFrame = _subtitleView.frame;
        subtitleViewFrame.origin = CGPointMake(floor(CGRectGetWidth(self.frame) / 2 - CGRectGetWidth(_subtitleView.frame) / 2), top);
        _subtitleView.frame = subtitleViewFrame;
        
        top += CGRectGetHeight(_subtitleView.frame) + kVPadding3;
    }
    
    if (_reloadButton != nil) {
        CGRect reloadButtonFrame = _reloadButton.frame;
        reloadButtonFrame.origin = CGPointMake(floor(CGRectGetWidth(self.frame) / 2 - CGRectGetWidth(_reloadButton.frame) / 2), top);
        _reloadButton.frame = reloadButtonFrame;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark properties


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)title
{
    return _titleView.text;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTitle:(NSString *)title
{
    _titleView.text = title;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)subtitle
{
    return _subtitleView.text;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSubtitle:(NSString *)subtitle
{
    _subtitleView.text = subtitle;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage *)image
{
    return _imageView.image;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
}

///////////////////////////////////////////////////////////////////////////////////////////////////


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
