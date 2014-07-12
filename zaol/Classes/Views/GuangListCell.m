//
//  GuangListCell.m
//  zaol
//
//  Created by li bin on 13-2-22.
//
//

#import "GuangListCell.h"
#import "CommonDef.h"
#import "UIImageView+WebCache.h"
#import "CCIconLabel.h"
#import "ItemVO.h"

#import <QuartzCore/QuartzCore.h>

const CGFloat kPadding = 7.0f;
const CGFloat kBottomLineHeight = 4.0f;
const CGFloat kGuangCellHeight = 200.0f;
const CGFloat kRadius = 5.0f;


@interface GuangListCell()

@property (strong, nonatomic) UIImageView * cover;
@property (strong, nonatomic) UILabel * topic;
@property (strong, nonatomic) CCIconLabel * count;
@property (strong, nonatomic) UILabel * createDate;
@property (strong, nonatomic) ItemVO * item;

@end


@implementation GuangListCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object
{
    return kGuangCellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // Initialization code
        UIImage * bgImage = [[UIImage imageNamed:@"theme_list_bg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        bgView.tag = 100;
        [bgView setImage:bgImage];
        
        [self addSubview:bgView];
        
//        封面图片
        self.cover = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_cover setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_cover setContentMode:UIViewContentModeScaleAspectFill];
        [_cover setClipsToBounds:YES];
        
//        专题标题
        self.topic = [[UILabel alloc] initWithFrame:CGRectZero];
        [_topic setTextAlignment:UITextAlignmentLeft];
        [_topic setTextColor:rgba(106.0f, 106.0f, 106.0f, 1)];
        [_topic setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [_topic setLineBreakMode:UILineBreakModeTailTruncation];
        
//        商品数目
        self.count = [[CCIconLabel alloc] initWithIcon:@"guang_item_ico.png" text:@"0" textColor:rgba(160.0f, 160.0f, 160.0f, 1) fontSize:10.0f];
        [_count setFrame:CGRectZero];
        
//        发布时间
        self.createDate = [[UILabel alloc] initWithFrame:CGRectZero];
        [_createDate setTextColor:rgba(140.0f, 140.0f, 140.0f, 1)];
        [_createDate setTextAlignment:UITextAlignmentRight];
        [_createDate setFont:[UIFont systemFontOfSize:10.0f]];
        
//        加入
        [self.contentView addSubview:_cover];
        [self.contentView addSubview:_topic];
        [self.contentView addSubview:_count];
        [self.contentView addSubview:_createDate];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark - cell data

/////////////////////////////////////////////////////////////////////////////////////////////////
- (id)object
{
    return _item;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object
{
    if (_item != object) {
        _item = object;
        
        self.topic.text = _item.topic_name;
        
        if (_item.front_pic.length) {
            [self.cover setImageWithURL:[NSURL URLWithString:_item.front_pic] placeholderImage:[UIImage imageNamed:@"loading_l.png"]];
        }
        
        self.count.text = _item.item_count;
        
        self.createDate.text = [_item.update_time substringToIndex:[_item.update_time rangeOfString:@" "].location];

    }
}

#pragma mark -
#pragma mark - layout

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];

    //    修整装饰背景部分的位置
    [[self viewWithTag:100] setFrame:CGRectMake(kPadding + kRadius,kGuangCellHeight - kPadding, CGRectGetWidth([[UIScreen mainScreen] applicationFrame]) - (kPadding + kRadius) * 2, 4)];

    //    修整contentView的尺寸和位置
    [self.contentView setFrame:CGRectMake(kPadding, kPadding, CGRectGetWidth([[UIScreen mainScreen] applicationFrame]) - kPadding * 2, kGuangCellHeight - kPadding * 2)];
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    CALayer * layer = self.contentView.layer;
    [layer setCornerRadius:kRadius];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0f];
    [layer setBorderColor:[rgba(236, 236, 236, 1) CGColor]];
    
//    修正图片的尺寸和位置
    [_cover setFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 145)];
//    修改标题的尺寸和位置
    [_topic setFrame:CGRectMake(kPadding, CGRectGetMaxY(_cover.frame), CGRectGetWidth(_cover.frame) - 2 * kPadding, 24)];
//    修正iconlabel的尺寸和位置
    [_count setFrame:CGRectMake(kPadding, CGRectGetMaxY(_topic.frame), 0, 0)];
    [_count sizeToFit];
//    修正日期的尺寸和位置
    [_createDate setFrame:CGRectMake(CGRectGetMaxX(_count.frame), CGRectGetMinY(_count.frame), CGRectGetWidth(_cover.frame) - CGRectGetMaxX(_count.frame) - kPadding, 11.0f)];
    
}

- (void)prepareForReuse
{
    [self.cover cancelCurrentImageLoad];
}

@end
