//
//  CategoryItem.h
//  zaol
//
//  Created by hark2046 on 13-3-1.
//
//

#import <UIKit/UIKit.h>
#import "CateVO.h"

@interface CategoryItem : UIControl
{
    __strong UIImageView * _cover;
    __strong UILabel * _titleView;
}

@property (strong, nonatomic) CateVO * data;

@end
