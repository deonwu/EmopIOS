//
//  CategoryCell.h
//  zaol
//
//  Created by hark2046 on 13-3-1.
//
//

#import "BaseTableViewCell.h"

#import "CateVO.h"

@protocol CategoryCellDelgate <NSObject>

- (void)didClickItemWithData:(CateVO *)data;

@end

@interface CategoryCell : BaseTableViewCell

@property (strong, nonatomic) CateVO * leftCateData;
@property (strong, nonatomic) CateVO * rightCateData;

@property (assign, nonatomic) id<CategoryCellDelgate> cellDelegate;

@end


