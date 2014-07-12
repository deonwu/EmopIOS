//
//  TopicView.m
//  zaol
//
//  Created by hark2046 on 13-3-5.
//
//

#import "TopicView.h"
#import "CommonDef.h"

const CGFloat kTopicItemPadding = 5.0f;
const CGFloat kTopicItemGap = 30.0f;
const CGFloat kBottomSpacing = 30.0f;

@interface TopicView()

@property (strong, nonatomic) TopicViewItem * item1;
@property (strong, nonatomic) TopicViewItem * item2;
@property (strong, nonatomic) TopicViewItem * item3;
@property (strong, nonatomic) TopicViewItem * item4;

- (void)didClicked:(id)sender;

@end

@implementation TopicView

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.contentView setBackgroundColor:rgba(230, 230, 230, 1)];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
- (void)setGoodsData1:(GoodsVO *)goodsData1
{
    if (_goodsData1 != goodsData1) {
        _goodsData1 = goodsData1;
        
        if (_goodsData1) {
            if (!self.item1) {
                self.item1 = [[TopicViewItem alloc] initWithFrame:CGRectZero];
                
                [_item1 addTarget:self action:@selector(didClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:_item1];
            }
            [self.item1 setData:_goodsData1];
        }
    }
}

////////////////////////////////////////////////////////////////////////////
- (void)setGoodsData2:(GoodsVO *)goodsData2
{
    if (_goodsData2 != goodsData2) {
        _goodsData2 = goodsData2;
        
        if (_goodsData1) {
            if (!self.item2) {
                self.item2 = [[TopicViewItem alloc] initWithFrame:CGRectZero];
                
                [_item2 addTarget:self action:@selector(didClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:_item2];
            }
            [self.item2 setData:_goodsData2];
        }
    }
}

////////////////////////////////////////////////////////////////////////////
- (void)setGoodsData3:(GoodsVO *)goodsData3
{
    if (_goodsData3 != goodsData3) {
        _goodsData3 = goodsData3;
        
        if (_goodsData3) {
            if (!self.item3) {
                self.item3 = [[TopicViewItem alloc] initWithFrame:CGRectZero];
                
                [_item3 addTarget:self action:@selector(didClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:_item3];
            }
            [self.item3 setData:_goodsData3];
        }
    }
}

////////////////////////////////////////////////////////////////////////////
- (void)setGoodsData4:(GoodsVO *)goodsData4
{
    if (_goodsData4 != goodsData4) {
        _goodsData4 = goodsData4;
        
        if (_goodsData4) {
            if (!self.item4) {
                self.item4 = [[TopicViewItem alloc] initWithFrame:CGRectZero];
                
                [_item4 addTarget:self action:@selector(didClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView addSubview:_item4];
            }
            [self.item4 setData:_goodsData4];
        }
    }
}

////////////////////////////////////////////////////////////////////////////
- (void)didClicked:(id)sender
{
    TopicViewItem * item = (TopicViewItem *)sender;
    
    if (self.topicViewDelegate && [self.topicViewDelegate respondsToSelector:@selector(didTopicItemClicked:withData:)]) {
        [self.topicViewDelegate didTopicItemClicked:item withData:item.data];
    }
}

- (void)setLayout:(LayoutType)layout
{
    if (_layout != layout) {
        _layout = layout;
        
        [self  setNeedsLayout];
    }
}

////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds) - kBottomSpacing;
    CGRect item1Frame, item2Frame, item3Frame, item4Frame;
    switch (_layout) {
        case kLayout1:
        {
            
            /**
             * 方向
             * 1 | 2
             * -----
             * 4 | 3
             */
            CGFloat itemW = (w - 3 * kTopicItemPadding) / 2.0;
            
            CGFloat itemH1 = (h - kTopicItemGap - 2 * kTopicItemPadding) / 2.0;
            CGFloat itemH2 = itemH1 + kTopicItemGap;
            
            item1Frame = CGRectMake(kTopicItemPadding, kTopicItemPadding, itemW, itemH2);
            item2Frame = CGRectMake(kTopicItemPadding * 2 + itemW, kTopicItemPadding, itemW, itemH1);
            item3Frame = CGRectMake(kTopicItemPadding * 2 + itemW, 2 * kTopicItemPadding + itemH1, itemW, itemH2);
            item4Frame = CGRectMake(kTopicItemPadding, 2 * kTopicItemPadding + itemH2, itemW, itemH1);
        }
            break;
        case kLayout2:
        {
            /** 
             * 方向
             *   1
             * -----
             * 2|3|4
             */
            CGFloat itemW1 = w - 2 * kTopicItemPadding;
            CGFloat itemW2 = ( w - 4 * kTopicItemPadding) / 3.0;
            CGFloat itemH1 = itemW1- 2 * kTopicItemGap;
            CGFloat itemH2 = h - 2 * kTopicItemPadding - itemH1;
            
            CGFloat sItemY = 2 * kTopicItemPadding + itemH1;
            
            item1Frame = CGRectMake(kTopicItemPadding, kTopicItemPadding, itemW1, itemH1);
            item2Frame = CGRectMake(kTopicItemPadding, sItemY, itemW2, itemH2);
            item3Frame = CGRectMake(2 * kTopicItemPadding + itemW2, sItemY, itemW2, itemH2);
            item4Frame = CGRectMake(3 * kTopicItemPadding + itemW2 * 2, sItemY, itemW2, itemH2);
            
        }
            break;
        case kLayout3:
        {
            /**
             * 方向
             * 1 | 2
             * -----
             * 4 | 3
             */
            CGFloat itemW = (w - 3 * kTopicItemPadding) / 2.0;
            
            CGFloat itemH1 = (h - kTopicItemGap - 2 * kTopicItemPadding) / 2.0;
            CGFloat itemH2 = itemH1 + kTopicItemGap;
            
            item1Frame = CGRectMake(kTopicItemPadding, kTopicItemPadding, itemW, itemH1);
            item2Frame = CGRectMake(kTopicItemPadding * 2 + itemW, kTopicItemPadding, itemW, itemH2);
            item3Frame = CGRectMake(kTopicItemPadding * 2 + itemW, 2 * kTopicItemPadding + itemH2, itemW, itemH1);
            item4Frame = CGRectMake(kTopicItemPadding, 2 * kTopicItemPadding + itemH1, itemW, itemH2);
        }
            break;
        case kLayout4:
        {
            /**
             * 方向
             * 1|2|3
             * -----
             *   4
             */
            CGFloat itemW1 = w - 2 * kTopicItemPadding;
            CGFloat itemW2 = ( w - 4 * kTopicItemPadding) / 3.0;
            CGFloat itemH1 = itemW1 - 2 * kTopicItemGap;
            CGFloat itemH2 = h - 2 * kTopicItemPadding - itemH1;
            
            item1Frame = CGRectMake(kTopicItemPadding, kTopicItemPadding, itemW2, itemH2);
            item2Frame = CGRectMake(2 * kTopicItemPadding + itemW2, kTopicItemPadding, itemW2, itemH2);
            item3Frame = CGRectMake(3 * kTopicItemPadding + itemW2 * 2, kTopicItemPadding, itemW2, itemH2);
            item4Frame = CGRectMake(kTopicItemPadding, 2 * kTopicItemPadding + itemH2, itemW1, itemH1);
        }
            break;
        default:
            break;
    }
    
    if (_item1) {
        [_item1 setFrame:item1Frame];
    }
    if (_item2) {
        [_item2 setFrame:item2Frame];
    }
    if (_item3) {
        [_item3 setFrame:item3Frame];
    }
    if (_item4) {
        [_item4 setFrame:item4Frame];
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
