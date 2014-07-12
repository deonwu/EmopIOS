//
//  SlideVIew.m
//  zaol
//
//  Created by hark2046 on 13-3-3.
//
//

#import "SlideView.h"

#import "UIImageView+WebCache.h"

@implementation SlideView
{
    __strong UIImageView * _imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setData:(AdItemVO *)data
{
    if (_data != data) {
        _data = data;
        
        if(data){
            [_imageView setImageWithURL:[NSURL URLWithString:_data.pic_url] placeholderImage:[UIImage imageNamed:@"loading_l.png"]];
        }
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
