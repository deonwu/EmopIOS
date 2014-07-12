//
//  TopicView.h
//  zaol
//
//  Created by hark2046 on 13-3-5.
//
//

#import <UIKit/UIKit.h>

//#import "KKGridViewCell.h"
#import "AQGridViewCell.h"
#import "GoodsVO.h"
#import "TopicViewItem.h"

typedef enum{
    kLayout1 = 0,
    kLayout2 = 1,
    kLayout3 = 2,
    kLayout4 = 3
} LayoutType;

@protocol TopicViewItemDelegate <NSObject>

- (void)didTopicItemClicked:(TopicViewItem *)item withData:(GoodsVO *)data;

@end

//@interface TopicView : KKGridViewCell
@interface TopicView : AQGridViewCell

@property (assign, nonatomic) LayoutType layout;

@property (strong, nonatomic) GoodsVO * goodsData1;
@property (strong, nonatomic) GoodsVO * goodsData2;
@property (strong, nonatomic) GoodsVO * goodsData3;
@property (strong, nonatomic) GoodsVO * goodsData4;

@property (unsafe_unretained, nonatomic) id<TopicViewItemDelegate> topicViewDelegate;

@end
