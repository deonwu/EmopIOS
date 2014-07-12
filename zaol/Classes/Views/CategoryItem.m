//
//  CategoryItem.m
//  zaol
//
//  Created by hark2046 on 13-3-1.
//
//

#import "CategoryItem.h"
#import "CommonDef.h"

#import "UIImageView+WebCache.h"

@implementation CategoryItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _cover = [[UIImageView alloc] init];
        [_cover setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_cover];
        
        _titleView = [[UILabel alloc] init];
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.font = [UIFont systemFontOfSize:10.0f];
        _titleView.textAlignment = UITextAlignmentCenter;
        [self addSubview:_titleView];
    }
    return self;
}

- (void)setData:(CateVO *)data
{
    if (_data != data) {
        _data = data;
        
        if (_data)
        {
            [_cover setImageWithURL:[NSURL URLWithString:_data.front_pic] placeholderImage:[UIImage imageNamed:@"cate_img_bg.png"]];
            
            [_titleView setText:_data.topic_name];
        }else{
//            单元格重用时可能会重置为空
            [_cover cancelCurrentImageLoad];
            [_cover setImage:nil];
            [_titleView setText:@""];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_data) {
        
        CGFloat rate = 5.0f / 6.0f ; //h/w
        
        CGFloat h = CGRectGetWidth(self.frame) * rate;
        
        [_cover setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), h)];
        [_titleView setFrame:CGRectMake(0, h - 15, CGRectGetWidth(self.frame), 15)];
    }else{
        [_cover setFrame:CGRectZero];
        [_titleView setFrame:CGRectZero];
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
