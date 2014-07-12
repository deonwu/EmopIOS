//
//  HotspotViewController.h
//  zaol
//
//  Created by Bin Li on 13-2-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "MKNetworkEngine.h"

#import "KKGridView.h"

@interface HotspotViewController : BaseViewController<KKGridViewDataSource, KKGridViewDelegate>
{
    struct {
        unsigned int isLoading:1;
        unsigned int isFirstLoading:1;
        unsigned int isModelLoaded:1;
        unsigned int isShowingModel:1;
        unsigned int isShowingLoading:1;
        unsigned int isShowingEmpty:1;
        unsigned int isShowingError:1;
        unsigned int isUpdatingView:1;
    } _flags;
    
    
    __strong KKGridView * _gridView;
    
    BOOL _clearSelectionOnViewWillAppear;
    
    BOOL _lastInterfaceOrientation;
    
    __strong MKNetworkEngine * _engine;
    
    /**
     * 页码控制
     */
    uint _currentPage;
    uint _maxPage;
    
}

@property (strong, nonatomic) KKGridView * gridView;

@property (strong, nonatomic) NSError * modelError;

//不同情况可能用到的View
@property (strong, nonatomic) UIView * tableOverlayView;
@property (strong, nonatomic) UIView * loadingView;
@property (strong, nonatomic) UIView * errorView;
@property (strong, nonatomic) UIView * emptyView;

/**
 * 需要在子类中对getter方法重写一下
 */
@property (strong, nonatomic) MKNetworkEngine * engine;

@property (strong, nonatomic) NSMutableArray * datas;

@property (strong, nonatomic) NSMutableArray * adDatas;

@property (assign, nonatomic) BOOL clearSelectionOnViewWillAppear;

/**
 * 是否可以加载更多
 */
- (BOOL)shouldLoadMore;

/**
 * 加载
 */
- (void)reload;

- (void)loadWithCache:(BOOL)cache more:(BOOL)more;


/**
 * 更新视图
 */
- (void)updateView;

- (void)updateViewState;

/**
 * 显示特定的视图
 */
- (void)showModel:(BOOL)show;
- (void)showError:(BOOL)show;
- (void)showEmpty:(BOOL)show;
- (void)showLoading:(BOOL)show;

/**
 * 点击操作
 */
- (void)didSelectedObject:(id)object atIndexPath:(NSIndexPath *)indexPath;



@end
