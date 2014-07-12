//
//  CategoryCell.m
//  zaol
//
//  Created by hark2046 on 13-3-1.
//
//

#import "CategoryCell.h"

#import "CategoryItem.h"

const int kLeftItemTag  = 101;
const int kRightItemTag = 102;

const CGFloat kCategoryItemSPadding = 20.0f;

const CGFloat kCategoryItemMPadding = 10.0f;

const CGFloat kCategoryItemVPadding = 10.0f;

const CGFloat kCategoryCellHeight = 150.0f;

const CGFloat kPicRate = 5.0f/ 6.0f;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CategoryCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object
{
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] applicationFrame]);
    
    CGFloat itemW = w/2.0 - kCategoryItemSPadding - kCategoryItemMPadding;
    CGFloat itemH = kPicRate * itemW;
    
    return itemH + kCategoryItemVPadding * 2;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 
#pragma mark setter && getter


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeftCateData:(CateVO *)leftCateData
{
    if (_leftCateData != leftCateData) {
        _leftCateData = leftCateData;
        
        if (_leftCateData) {
//            左边的类目按钮
            CategoryItem * leftItem = (CategoryItem *)[self.contentView viewWithTag:kLeftItemTag];
            if (!leftItem) {
                leftItem = [[CategoryItem alloc] initWithFrame:CGRectZero];
                [leftItem setTag:kLeftItemTag];
                
                [leftItem addTarget:self action:@selector(didSelectCategory:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView addSubview:leftItem];
            }
            
            [leftItem setData:_leftCateData];
        }else{
            CategoryItem * leftItem = (CategoryItem *)[self.contentView viewWithTag:kLeftItemTag];
            
            if (leftItem) {
                [leftItem setData:nil];
            }
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRightCateData:(CateVO *)rightCateData
{
    if (_rightCateData != rightCateData) {
        _rightCateData = rightCateData;
        
        if (_rightCateData) {
//            右边的类目按钮
            CategoryItem * rightItem = (CategoryItem *)[self.contentView viewWithTag:kRightItemTag];
            if (!rightItem) {
                rightItem = [[CategoryItem alloc] initWithFrame:CGRectZero];
                [rightItem setTag:kRightItemTag];
                
                [rightItem addTarget:self action:@selector(didSelectCategory:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView addSubview:rightItem];
            }
            
            [rightItem setData:_rightCateData];
        }else{
            
            CategoryItem * rightItem = (CategoryItem *)[self.contentView viewWithTag:kRightItemTag];
            
            if (rightItem) {
                [rightItem setData:nil];
            }
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark layout

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = CGRectGetWidth([[UIScreen mainScreen] applicationFrame]);
    
    CGFloat itemW = w/2.0 - kCategoryItemSPadding - kCategoryItemMPadding;
    CGFloat itemH = kPicRate * itemW;
    
    if ( _leftCateData ) {
        CategoryItem * leftItem = (CategoryItem * )[self.contentView viewWithTag:kLeftItemTag];
        [leftItem setFrame:CGRectMake(kCategoryItemSPadding, kCategoryItemVPadding, itemW, itemH)];
    }
    
    if (_rightCateData) {
        CategoryItem * rightItem = (CategoryItem * )[self.contentView viewWithTag:kRightItemTag];
        [rightItem setFrame:CGRectMake(w / 2.0 + kCategoryItemMPadding, kCategoryItemVPadding, itemW, itemH)];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark event


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectCategory:(CategoryItem *)item
{
    CateVO * selectedData = item.data;
    
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(didClickItemWithData:)]) {
        [self.cellDelegate didClickItemWithData:selectedData];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark about reuse


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    self.leftCateData = nil;
    self.rightCateData = nil;
}

@end
