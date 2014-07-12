//
//  HotspotViewController.m
//  zaol
//
//  Created by Bin Li on 13-2-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "HotspotViewController.h"

#import "Tuji_User_Topic_List_Engine.h"
#import "Tuji_topic_item_list_engine.h"

#import "JSONKit.h"

#import "CommonDef.h"

#import "ErrorView.h"

#import "ItemVO.h"
#import "AdItemVO.h"

#import "HotspotCell.h"

#import "GCPagedScrollView.h"
#import "SlideView.h"

#import "ListViewController.h"

#import "WebDetailViewController.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HotspotViewController
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)query
{
    self = [super initWithURL:aUrl query:query];
    if (self) {
        _clearSelectionOnViewWillAppear = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark reset view

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - KKGridViewDataSource

- (NSUInteger)gridView:(KKGridView *)gridView numberOfItemsInSection:(NSUInteger)section
{
    return [self.datas count];
}

- (KKGridViewCell *)gridView:(KKGridView *)gridView cellForItemAtIndexPath:(KKIndexPath *)indexPath
{
//    return [KKGridViewCell cellForGridView:gridView];
    
    HotspotCell * cell = [HotspotCell cellForGridView:gridView];
    
    cell.data = [self.datas objectAtIndex:indexPath.index];
    
    [cell setHighlightAlpha:0];
    [cell setHighlighted:NO];
    
    return cell;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark view life circle


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView
{
    [super loadView];
    [self gridView];
    
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
    
    [self.navigationController setToolbarHidden:YES];
    
    [self updateView];
    
    if (_lastInterfaceOrientation != self.interfaceOrientation) {
        _lastInterfaceOrientation = self.interfaceOrientation;
        [_gridView reloadData];
    }
    
    if (_clearSelectionOnViewWillAppear){
        [_gridView deselectItemsAtIndexPaths:[_gridView indexPathsForSelectedCells] animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.datas = [NSMutableArray arrayWithCapacity:10];
	// Do any additional setup after loading the view.
    [self updateView];
    
    [self loadWithCache:YES more:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark getter && setter


///////////////////////////////////////////////////////////////////////////////////////////////////
- (KKGridView *)gridView
{
    if ( nil == _gridView ) {
        
        _gridView = [[KKGridView alloc] initWithFrame:self.view.bounds];
        [_gridView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        [_gridView setScrollsToTop:YES];
        [_gridView setBackgroundColor:rgba(240, 240, 240, 1)];
        [_gridView setCellSize:CGSizeMake(100, 125)];
        [_gridView setCellPadding:CGSizeMake(5.0, 5)];
        [_gridView setAllowsMultipleSelection:NO];
        
        [_gridView setDataSource:self];
        [_gridView setDelegate:self];
        
        [self.view addSubview:_gridView];
    }
    return _gridView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (MKNetworkEngine *)engine
{
    return [Tuji_User_Topic_List_Engine sharedInstance];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)gridView:(KKGridView *)gridView didSelectItemAtIndexPath:(KKIndexPath *)indexPath
{
    
    ItemVO * data = [self.datas objectAtIndex:indexPath.index];
    
    ListViewController * vc = [[ListViewController alloc] initWithURL:[NSURL URLWithString:@"tdh://list"] query:@{@"title":data.topic_name, @"topic_id":data.id}];
    
    [vc setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didSelectedObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    
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
    
    [(Tuji_User_Topic_List_Engine *)self.engine operationWithPage:_currentPage
                                                         pageSize:0
                                                             cate:5
                                                completionHandler:^(NSString *response, MKNetworkOperation *op) {
//                                                    NSLog(@"%@", response);
                                                    
                                                    _flags.isModelLoaded = YES;
                                                    _flags.isLoading = NO;
                                                    
                                                    if (!self.datas) {
                                                        self.datas = [NSMutableArray arrayWithCapacity:20];
                                                    }
                                                    
                                                    
                                                    NSDictionary * topics = [response objectFromJSONString];
                                                    
                                                    if ([[topics objectForKey:@"status"] isEqualToString:@"ok"]) {
                                                        
                                                        NSArray * items = [ItemVO ItemsWithArray:[[topics objectForKey:@"data"] objectForKey:@"items"]];
                                                        
                                                        NSSortDescriptor * sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"view_order" ascending:YES];
                                                        
                                                        NSArray * sorted = [items sortedArrayUsingDescriptors:@[sortDesc]];
                                                        
                                                        [self.datas addObjectsFromArray:sorted];
                                                        
                                                        self.modelError = nil;
                                                        
                                                    }else{
                                                        
                                                        self.modelError = [[NSError alloc] initWithDomain:[topics objectForKey:@"code"] code:0 userInfo:nil];
                                                    }
                                                    
                                                    [self updateView];
                                                    
                                                    
                                                } errorHandler:^(NSError *error) {
                                                    
                                                    NSLog(@"%@", [error localizedDescription]);
                                                    self.modelError = error;
                                                    
                                                    [self updateView];
                                                }];
//    顶部滚动广告
    Tuji_topic_item_list_engine * adEngine = [Tuji_topic_item_list_engine sharedInstance];
    
    [adEngine operationWithTopicId:@"4277"
                            userId:@"2"
                          pageSize:nil
                              page:nil
                 completionHandler:^(NSString *response, MKNetworkOperation *op) {
//                     NSLog(@"===================================================");
//                     NSLog(@"AD:%@", response);
                     
                     NSDictionary * ads = [response objectFromJSONString];
                     
                     if ([[ads objectForKey:@"status"] isEqualToString:@"ok"]) {
                         NSArray * adItems = [AdItemVO ItemsWithArray:[[ads objectForKey:@"data"] objectForKey:@"items"]];
                         
                         if (!self.adDatas) {
                             self.adDatas = [NSMutableArray arrayWithCapacity:4];
                         }
                         
                         for (AdItemVO * item in adItems) {
                             if ([item.status isEqualToString:@"0"]) {
                                 [self.adDatas addObject:item];
                             }
                         }
                         
                         GCPagedScrollView * pageScrollView = [[GCPagedScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 106)];
                         
//                         [pageScrollView setPage:[self.adDatas count] animated:YES];
                         [pageScrollView setPagingEnabled:YES];
                         
                         for (AdItemVO * item in _adDatas) {
                             SlideView * v = [[SlideView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 106.0f)];
                             [v setData:item];
                             
                             [v addTarget:self action:@selector(didClickAdItem:) forControlEvents:UIControlEventTouchUpInside];
                             
                             [pageScrollView addContentSubview:v];
                         }
                         
                         [pageScrollView setPage:0];
                         
                         [self.gridView setGridHeaderView:pageScrollView];
                         
                         [self.gridView reloadData];
                     }
                     
    }
                      errorHandler:^(NSError *error) {
                    
    }];
    
}

- (void)didClickAdItem:(SlideView *)adItem
{
    AdItemVO *data = adItem.data;
    
    WebDetailViewController * vc = [[WebDetailViewController alloc] initWithURL:[NSURL URLWithString:@"tdh://webdetail"] query:@{@"title":@"手机淘宝",@"url":data.text}];
    
    [vc setHidesBottomBarWhenPushed:YES];
    
//    [self.navigationController pushViewController:vc animated:YES];
    [self.navigator pushViewController:vc animated:YES];
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
            [_gridView reloadData];
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
//            
//            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_gridView.frame), CGRectGetHeight(_gridView.frame))];
//            [label setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
//            [label setTextAlignment:UITextAlignmentCenter];
//            [label setText:title];
//            [label setTextColor:rgba(96, 103, 111, 1)];
//            [label setBackgroundColor:[_gridView backgroundColor]];
            
            UIImageView * loading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_gridView.frame), CGRectGetHeight(_gridView.frame))];
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
        _gridView.dataSource = self;
        
        [self resetOverlayView];
    }else{
        _gridView.dataSource = nil;
    }
    
    [_gridView reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showEmpty:(BOOL)show
{
    if (show) {
        NSString * title = NSLocalizedString(@"内容为空", @"");
        NSString * subtitle = NSLocalizedString(@"内容为空详细提示", @"");
        ErrorView * errorView = [[ErrorView alloc] initWithTitle:title subtitle:subtitle image:nil];
        errorView.backgroundColor = _gridView.backgroundColor;
        
        self.emptyView = errorView;
        
        _flags.isShowingModel = NO;
        _gridView.dataSource = nil;
        [_gridView reloadData];
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
                
                errorView.backgroundColor = _gridView.backgroundColor;
                
                self.errorView = errorView;
                
            } else {
                self.errorView = nil;
            }
            _gridView.dataSource = nil;
            
            _flags.isShowingModel = NO;
            [_gridView reloadData];
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
        CGRect frame = [_gridView frame];
        _tableOverlayView = [[UIView alloc] initWithFrame:frame];
        _tableOverlayView.autoresizesSubviews = YES;
        _tableOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        NSInteger tableIndex = [_gridView.superview.subviews indexOfObject:_gridView];
        if (tableIndex != NSNotFound) {
            [_gridView.superview addSubview:_tableOverlayView];
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
