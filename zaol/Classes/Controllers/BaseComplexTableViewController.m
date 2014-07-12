//
//  BaseComplexTableViewController.m
//  zaol
//
//  Created by hark2046 on 13-2-27.
//
//

#import "BaseComplexTableViewController.h"

#import "CommonDef.h"

#import "ErrorView.h"
#import "LoadMoreCell.h"

@interface BaseComplexTableViewController ()

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BaseComplexTableViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)query
{
    self = [super initWithURL:aUrl query:query];
    if (self) {
        _tableViewStyle = [[[self params] objectForKey:@"style"] isEqualToString:@"Group"]?UITableViewStyleGrouped:UITableViewStylePlain;
        
        _clearSelectionOnViewWillAppear = YES;
    }
    return self;
}

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

    if (_clearSelectionOnViewWillAppear){
        [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:animated];
    }
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.navigationController setToolbarHidden:YES animated:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self tableView];
    
	// Do any additional setup after loading the view.
    [self updateView];
    
    [self loadWithCache:YES more:NO];
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
- (UITableView *)tableView
{
    if ( nil == _tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (MKNetworkEngine *)engine
{
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
#pragma mark UITableViewDatasource && UITableViewDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self shouldLoadMore] && indexPath.row == [self.datas count]) {
        return [LoadMoreCell tableView:tableView rowHeightForObject:nil];
    }
    return 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellIdentifier = @"Loadding...";
    
    if ([self shouldLoadMore] && indexPath.row == [self.datas count]) {
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            cell = [[LoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell setUserInteractionEnabled:NO];
        }
        
        return cell;
    }
    
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableViewCell * cell = (BaseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [self didSelectedObject:cell.object atIndexPath:indexPath];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectedObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    
}

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
    if ([self shouldLoadMore] && fabs((_tableView.contentOffset.y + CGRectGetHeight(_tableView.frame)) - _tableView.contentSize.height) <=  1.0) {
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
        _tableView.dataSource = self;
        
        [self resetOverlayView];
    }else{
        _tableView.dataSource = nil;
    }
    
    [_tableView reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showEmpty:(BOOL)show
{
    if (show) {
        NSString * title = NSLocalizedString(@"内容为空", @"");
        NSString * subtitle = NSLocalizedString(@"内容为空详细提示", @"");
        ErrorView * errorView = [[ErrorView alloc] initWithTitle:title subtitle:subtitle image:nil];
        errorView.backgroundColor = _tableView.backgroundColor;
        
        self.emptyView = errorView;
        
        _flags.isShowingModel = NO;
        _tableView.dataSource = nil;
        [_tableView reloadData];
    }else{
        self.emptyView = nil;
    }
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
                
                _flags.isShowingModel = NO;
                self.errorView = errorView;
                
            } else {
                self.errorView = nil;
            }
            _tableView.dataSource = nil;
            
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
