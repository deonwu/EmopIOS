//
//  ListViewController.m
//  zaol
//
//  Created by hark2046 on 13-3-1.
//
//

#import "ListViewController.h"

#import "Tuji_Topic_Convert_Item_Click_Url_Engine.h"

#import "JSONKit.h"
#import "GoodsVO.h"

#import "GoodsListViewCell.h"
#import "GoodsDetailViewController.h"

#import "ErrorView.h"

#import "CommonDef.h"

#import "UIImageView+WebCache.h"

@interface ListViewController ()


@end

@implementation ListViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark view life circle


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView
{
    [super loadView];
    [self tableView];
    
    _flags.isLoading = YES;
    _flags.isFirstLoading = YES;
    _flags.isShowingModel = NO;
    _flags.isShowingLoading = NO;
    _flags.isShowingEmpty = NO;
    _flags.isShowingError = NO;
    _flags.isUpdatingView = NO;
    
    _currentPage = 0;
    _maxPage = 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateView];
    
    if (_lastInterfaceOrientation != self.interfaceOrientation) {
        _lastInterfaceOrientation = self.interfaceOrientation;
        [_tableView reloadData];
    }
    
//    if (_clearSelectionOnViewWillAppear){
//        [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:animated];
//    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    [self tableView];
    self.navigationItem.title = [[self query] objectForKey:@"title"];
	// Do any additional setup after loading the view.
    [self updateView];
    
    [self loadWithCache:YES more:NO];
    
    self.needPullRefresh = YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark getter && setter


///////////////////////////////////////////////////////////////////////////////////////////////////
- (PSCollectionView *)tableView
{
    if ( nil == _tableView ) {
        _tableView = [[PSCollectionView alloc] initWithFrame:self.view.bounds];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        [_tableView setCollectionViewDataSource:self];
        [_tableView setCollectionViewDelegate:self];
        
        [_tableView setNumColsPortrait:3];
        
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        [_tableView setDelegate:self];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (MKNetworkEngine *)engine
{
    if (!_engine) {
        self.engine = [Tuji_Topic_Convert_Item_Click_Url_Engine sharedInstance];
    }
    
    return _engine;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark about pullRefreshing


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNeedPullRefresh:(BOOL)needPullRefresh
{
    _needPullRefresh = needPullRefresh;
    if (_needPullRefresh && !_refreshControl) {
        self.refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableView];
        [_refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    }else{
        self.refreshControl = nil;
    }
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    _flags.isLoading = YES;
    _flags.isFirstLoading = NO;
    _flags.isShowingModel = YES;
    _flags.isShowingLoading = NO;
    _flags.isShowingEmpty = NO;
    _flags.isShowingError = NO;
    _flags.isUpdatingView = NO;
    
    self.modelError = nil;
    
    [self loadWithCache:YES more:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark CollectionViewDatasource && CollectionViewDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index
{
    return [GoodsListViewCell class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView
{
    return [self.datas count];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    GoodsVO * vo = [self.datas objectAtIndex:index];
    return [GoodsListViewCell rowHeightForObject:vo inColumnWidth:collectionView.colWidth];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    PSCollectionViewCell * cell = [collectionView dequeueReusableViewForClass:[GoodsListViewCell class]];
    
    if (!cell) {
        cell = [[GoodsListViewCell alloc] initWithFrame:CGRectZero];
    }
    
    cell.object = [self.datas objectAtIndex:index];
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    GoodsVO * vo = (GoodsVO *)[cell object];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"宝贝详情页" forKey:@"title"];
    [params setObject:[vo id] forKey:@"goodsId"];
    [params setObject:[vo item_id] forKey:@"itemId"];
    [params setObject:[vo rect_rate] forKey:@"rect_rate"];
    [params setObject:[vo shop_id] forKey:@"shopId"];
    [params setObject:[vo pic_url] forKey:@"picUrl"];
    [params setObject:[vo short_url_key] forKey:@"shortUrlKey"];
    
    [params setObject:[self datas] forKey:@"listData"];
    [params setObject:[NSNumber numberWithInt:[self.datas indexOfObject:vo]] forKey:@"curIndex"];
    
    [params setObject:[vo price] forKey:@"price"];
    
    [params setObject:[[(GoodsListViewCell *)cell goodsPicView] image] forKey:@"pic"];
    
    [params setObject:[vo uuid] forKey:@"uuid"];
    
    GoodsDetailViewController * goodsVC = [[GoodsDetailViewController alloc] initWithURL:[NSURL URLWithString:@"tdh://goodsDetail"] query:params];
    
    [goodsVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:goodsVC animated:YES];
    
//    [self didSelectedObject:vo atIndexPath:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)didSelectedObject:(id)object atIndexPath:(NSIndexPath *)indexPath
//{
//    
//    GoodsVO * vo = (GoodsVO *)object;
//    
//    
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSLog(@"_tableView.contentOffset.y + CGRectGetHeight(_tableView.frame)): %f", _tableView.contentOffset.y + CGRectGetHeight(_tableView.frame));
    
    NSLog(@"_tableView.contentSize.height: %f", round(_tableView.contentSize.height));
    
    
    
    if ([self shouldLoadMore] && fabs(_tableView.contentSize.height - _tableView.contentOffset.y) <  2 * CGRectGetHeight(_tableView.frame) && !_flags.isLoading) {
        [self loadWithCache:YES more:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark about network


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadWithCache:(BOOL)cache more:(BOOL)more
{
    if (more && ![self shouldLoadMore]) {
        return;
    }
    if (cache) {
        [self.engine useCache];
    }
    
    if (more){
        _currentPage++;
    }else{
        _currentPage = 0;
    }
    
    _flags.isLoading = YES;
    
    [(Tuji_Topic_Convert_Item_Click_Url_Engine *)self.engine operationWithPage:_currentPage
                                                                      pageSize:40
                                                                         topic:[self.query objectForKey:@"topic_id"]
                                                             completionHandler:^(NSString *response, MKNetworkOperation *op) {
                                                                 _flags.isModelLoaded = YES;
                                                                 _flags.isLoading = NO;
                                                                 if (!self.datas) {
                                                                     self.datas = [NSMutableArray arrayWithCapacity:20];
                                                                 }
                                                                 if (self.needPullRefresh && [self.refreshControl refreshing]) {
                                                                     self.datas = [NSMutableArray arrayWithCapacity:20];
                                                                     double delayInSeconds = 1.0;
                                                                     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                                                     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                                         [self.refreshControl endRefreshing];
                                                                     });
                                                                 }
                                                                 
                                                                 NSDictionary * goods = [response objectFromJSONString];
                                                                 
                                                                 if ([[goods objectForKey:@"status"] isEqualToString:@"ok"]) {
                                                                     if (!_maxPage) {
                                                                         _maxPage = floor([[[goods objectForKey:@"data"] objectForKey:@"item_count"] intValue] / 40);
                                                                     }
                                                                     
                                                                     NSArray * items = [GoodsVO ItemsWithArray:[[goods objectForKey:@"data"] objectForKey:@"items"]];
                                                                     
                                                                     [self.datas addObjectsFromArray:items];
                                                                     
                                                                     self.modelError = nil;
                                                                     
                                                                 }else{
                                                                     
                                                                     self.modelError = [[NSError alloc] initWithDomain:[goods objectForKey:@"code"] code:0 userInfo:nil];
                                                                 }
                                                                 
                                                                 if ([self shouldLoadMore]) {
                                                                     
                                                                     if (![self.tableView footerView]) {
                                                                         
                                                                         UILabel * foot = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] applicationFrame]), 44.0f)];
                                                                         
                                                                         [foot setText:NSLocalizedString(@"正在加载", @"")];
                                                                         [foot setFont:[UIFont systemFontOfSize:12.0f]];
                                                                         [foot setTextAlignment:UITextAlignmentCenter];
                                                                         
                                                                         UIActivityIndicatorView * loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                                                                         
                                                                         [loading setFrame:CGRectMake(100, (44 - 24) / 2.0, 24, 24)];
                                                                         
                                                                         [loading startAnimating];
                                                                         
                                                                         [foot addSubview:loading];
                                                                     
                                                                         self.tableView.footerView = foot;
                                                                     }
                                                                 }else{
                                                                     [self.tableView.footerView removeFromSuperview];
                                                                     [self.tableView setFooterView:nil];
                                                                 }
                                                                 
                                                                 [self updateView];
                                                                 
                                                             } errorHandler:^(NSError *error) {
                                                                 
                                                                 _flags.isLoading = NO;
                                                                 
                                                                 self.modelError = error;
                                                                 [self updateView];
                                                             }];
    
}

- (void)reload
{
    _flags.isLoading = YES;
    _flags.isFirstLoading = YES;
    _flags.isShowingModel = NO;
    _flags.isShowingLoading = NO;
    _flags.isShowingEmpty = NO;
    _flags.isShowingError = YES;
    _flags.isUpdatingView = NO;
    
    self.modelError = nil;
    
    [self updateView];
    
    [self loadWithCache:YES more:NO];
}

- (BOOL)shouldLoadMore
{
    return _currentPage < _maxPage;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark about view render


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateView
{
    if (!_flags.isUpdatingView && _isViewAppearing) {
        _flags.isUpdatingView = YES;
        
        [self updateViewState];
        
        _flags.isUpdatingView = NO;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateViewState
{
    BOOL showModel = NO, showLoading = NO, showError = NO, showEmpty = NO;
    
    if (_flags.isLoading && _flags.isFirstLoading) {
        showLoading = !_flags.isShowingLoading;
        _flags.isShowingLoading = YES;
    }else {
        if (_flags.isShowingLoading) {
            [self showLoading:NO];
            _flags.isShowingLoading = NO;
        }
    }
    
    if (_flags.isModelLoaded) {
        showModel = !_flags.isShowingModel;
        _flags.isShowingModel = YES;
        
        if (!showModel) {
            [_tableView reloadData];
        }
    } else {
        if (_flags.isShowingModel) {
            [self showModel:NO];
            _flags.isShowingModel = NO;
        }
    }
    
    if (_flags.isModelLoaded && !_flags.isLoading && !self.datas.count) {
        showEmpty = !_flags.isShowingEmpty;
        _flags.isShowingEmpty = YES;
    }else {
        if (_flags.isShowingEmpty) {
            [self showEmpty:NO];
            _flags.isShowingEmpty = NO;
        }
    }
    
    if (_modelError) {
        showError = !_flags.isShowingError;
        _flags.isShowingError = YES;
    }else{
        if (_flags.isShowingError) {
            [self showError:NO];
            _flags.isShowingError = NO;
        }
    }
    
    if (showModel) {
        [self showModel:YES];
    }
    
    if (showLoading) {
        [self showLoading:YES];
    }
    
    if (showEmpty) {
        [self showEmpty:YES];
    }
    
    if (showError) {
        [self showError:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showLoading:(BOOL)show
{
    if (show) {
        if (_flags.isLoading) {
//            NSString * title = NSLocalizedString(@"正在加载", @"");
            
//            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.frame))];
//            [label setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
//            [label setTextAlignment:UITextAlignmentCenter];
//            [label setText:title];
//            [label setTextColor:rgba(96, 103, 111, 1)];
//            [label setBackgroundColor:[_tableView backgroundColor]];
            
            UIImageView * loading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.frame))];
            [loading setImage:[UIImage imageNamed:@"loading.png"]];
            [loading setContentMode:UIViewContentModeScaleAspectFit];
            [loading setBackgroundColor:rgba(250, 250, 250, 1)];

            
            _flags.isShowingModel = NO;
            
//            self.loadingView = label;
            self.loadingView = loading;
        }
    }else{
        self.loadingView = nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showModel:(BOOL)show
{
    if (show) {
//        _tableView.dataSource = self;
        _tableView.collectionViewDataSource = self;
        
        [self resetOverlayView];
    }else{
//        _tableView.dataSource = nil;
        _tableView.collectionViewDataSource = nil;
    }
    
    [_tableView reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showEmpty:(BOOL)show
{
    if (show) {
//        NSString * title = NSLocalizedString(@"内容为空", @"");
//        NSString * subtitle = NSLocalizedString(@"内容为空详细提示", @"");
        
        
        
        ErrorView * errorView = [[ErrorView alloc] initWithTitle:nil subtitle:nil image:[UIImage imageNamed:@"no_items.png"]];
        errorView.backgroundColor = rgba(245, 245, 245, 1);
        
        self.emptyView = errorView;
        
        _flags.isShowingModel = NO;
        
//        _tableView.dataSource = nil;
        _tableView.collectionViewDataSource = nil;
        [_tableView reloadData];
    }else{
        self.emptyView = nil;
    }
}

- (UIImage *)imageForEmpty
{
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showError:(BOOL)show
{
    if (show) {
        if (self.modelError) {
            NSString * title = NSLocalizedString(@"加载出错", @"");
            NSString * subtitle = NSLocalizedString(@"加载出错详细提示", @"");
            
            if (title.length || subtitle.length) {
                ErrorView * errorView = [[ErrorView alloc] initWithTitle:title subtitle:subtitle image:nil];
                
                [errorView addReloadButton];
                [[errorView reloadButton] addTarget:self
                                             action:@selector(reload)
                                   forControlEvents:UIControlEventTouchUpInside];
                
                errorView.backgroundColor = _tableView.backgroundColor;
                
                self.errorView = errorView;
                
            } else {
                self.errorView = nil;
            }
//            _tableView.dataSource = nil;
            _tableView.collectionViewDataSource = nil;
            
            _flags.isShowingModel = NO;
            [_tableView reloadData];
        }
    }else{
        self.errorView = nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLoadingView:(UIView *)loadingView
{
    if (loadingView != _loadingView) {
        if (_loadingView) {
            [_loadingView removeFromSuperview];
            _loadingView = nil;
        }
        
        _loadingView = loadingView;
        
        if (_loadingView) {
            [self addToOverlayView:_loadingView];
        }else{
            [self resetOverlayView];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setErrorView:(UIView *)errorView
{
    if (errorView != _errorView) {
        [_errorView removeFromSuperview];
        _errorView = nil;
    }
    
    _errorView = errorView;
    
    if (_errorView){
        [self addToOverlayView:_errorView];
    }else {
        [self resetOverlayView];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setEmptyView:(UIView *)emptyView
{
    if (emptyView != _emptyView) {
        [_emptyView removeFromSuperview];
        _emptyView = nil;
    }
    _emptyView = emptyView;
    
    if (_emptyView) {
        [self addToOverlayView:_emptyView];
    }else{
        [self resetOverlayView];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addToOverlayView:(UIView *)view
{
    if (!_tableOverlayView) {
        CGRect frame = [_tableView frame];
        _tableOverlayView = [[UIView alloc] initWithFrame:frame];
        _tableOverlayView.autoresizesSubviews = YES;
        _tableOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        NSInteger tableIndex = [_tableView.superview.subviews indexOfObject:_tableView];
        if (tableIndex != NSNotFound) {
            [_tableView.superview addSubview:_tableOverlayView];
        }
    }
    
    view.frame = _tableOverlayView.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableOverlayView addSubview:view];
}

- (void)resetOverlayView
{
    if (_tableOverlayView && !_tableOverlayView.subviews.count) {
        [_tableOverlayView removeFromSuperview];
        _tableOverlayView = nil;
    }
}


@end
