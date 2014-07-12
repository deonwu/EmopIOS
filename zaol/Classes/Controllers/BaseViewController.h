//
//  BaseViewController.h
//  zaol
//
//  Created by li bin on 13-2-18.
//
//

#import "UMViewController.h"


@interface BaseViewController : UMViewController
{
    @protected
    BOOL _hasViewAppeared;
    BOOL _isViewAppearing;
}
@property (readonly, nonatomic) BOOL hasViewAppeared;
@property (readonly, nonatomic) BOOL isViewAppearing;

@end
