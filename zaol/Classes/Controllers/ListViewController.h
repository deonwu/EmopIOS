//
//  ListViewController.h
//  zaol
//
//  Created by hark2046 on 13-3-1.
//
//

#import "BaseViewController.h"
#import "MKNetworkEngine.h"
#import "PSCollectionView.h"

#import "ODRefreshControl.h"

@interface ListViewController : BaseViewController<PSCollectionViewDataSource, PSCollectionViewDelegate, UIScrollViewDelegate>
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
    
    
    __strong PSCollectionView * _tableView;
    
//    UITableViewStyle _tableViewStyle;
    
//    BOOL _clearSelectionOnViewWillAppear;
    
    BOOL _lastInterfaceOrientation;
    
    __strong MKNetworkEngine * _engine;
    
    /**
     * 页码控制
     */
    uint _currentPage;
    uint _maxPage;
    
}

@property (strong, nonatomic) PSCollectionView * tableView;

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

//@property (assign, nonatomic) BOOL clearSelectionOnViewWillAppear;

@property (assign, nonatomic) BOOL needPullRefresh;

@property (strong, nonatomic) ODRefreshControl * refreshControl;

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

- (UIImage *)imageForEmpty;

/**
 * 点击操作
 */
//- (void)didSelectedObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl;

@end
