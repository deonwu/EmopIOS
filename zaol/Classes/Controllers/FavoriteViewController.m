//
//  FavoriteViewController.m
//  zaol
//
//  Created by Bin Li on 13-2-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "FavoriteViewController.h"

#import "UserInfoHelper.h"

#import "LLAppDelegate.h"
#import "AKTabBarController.h"

#import "Tuji_topic_item_list_engine.h"
#import "Tuji_User_Topic_List_Engine.h"

#import "JSONKit.h"

#import "Config.h"

#import "GoodsVO.h"

#import "ErrorView.h"

#import "CommonDef.h"

@interface FavoriteViewController()
{
    BOOL _isAppearing;
}

@property (nonatomic, retain) NSString * topicId;


- (void)readyToLoadData;

@end

@implementation FavoriteViewController

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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
//    [super viewDidLoad];
    
    [self.navigationItem setTitle:[[self params] objectForKey:@"title"]];
    
    
    [self updateView];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:LOGIN_CANCEL object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (![UserInfoHelper isUserBinded] && _isAppearing) {
            
            [self performSelector:@selector(showPrevViewController) withObject:nil afterDelay:0];
        }
    }];
    
    if (![UserInfoHelper isUserBinded]) {

        
        [[NSNotificationCenter defaultCenter] addObserverForName:USER_BINDED object:nil queue:nil usingBlock:^(NSNotification *note) {
            NSLog(@"绑定成功，开始获取收藏列表");
            [self readyToLoadData];
        }];
    }else{
        [self readyToLoadData];
    }
    
    self.needPullRefresh = YES;
}

- (void)showPrevViewController
{
    
    AKTabBarController * vc = [(LLAppDelegate *)[[UIApplication sharedApplication] delegate] rootViewController];
    
    [vc didSelectTabAtIndex:vc.prevSelectedIndex];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _isAppearing = YES;
    
    if (![UserInfoHelper isUserBinded]) {
        
        self.datas = nil;
        
        [self.tableView reloadData];
        
        [UserInfoHelper showLoginPage:nil];
        return;
    }
    
    BOOL neeRefresh = [UserInfoHelper isNeedRefreshFav];
    
    if (neeRefresh) {
        
        [self.refreshControl beginRefreshing];
        
//        [self dropViewDidBeginRefreshing:self.refreshControl];
       
        self.modelError = nil;
        
        [self readyToLoadData];
        
        [self updateView];
        
        [UserInfoHelper storeNeedRefreshFav:NO];
        
        return;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isAppearing = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma about load

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
    
    [self readyToLoadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)readyToLoadData
{
    
    if ([UserInfoHelper topicId]) {
        self.topicId = [UserInfoHelper topicId];
        
        [self loadWithCache:YES more:NO];
    }else{
        Tuji_User_Topic_List_Engine * getTopicIdEngine = [Tuji_User_Topic_List_Engine sharedInstance];
        
        [getTopicIdEngine operationForFavWithCompletionHandler:^(NSString *response, MKNetworkOperation *op) {
            
            NSDictionary * topicData = [response objectFromJSONString];
            
            if ([[topicData objectForKey:@"status"] isEqualToString:@"ok"]){
                
//                NSInteger count = [[[topicData objectForKey:@"data"] objectForKey:@"item_count"] intValue];
                
                self.topicId = [[topicData objectForKey:@"data"] objectForKey:@"topic_id"];
                
                [UserInfoHelper storeTopicId:self.topicId];
                [self loadWithCache:YES more:NO];
                
//                if (count) {
//                    
//                    NSString * topicId = [[[[topicData objectForKey:@"data"] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"id"];
//                    self.topicId = topicId;
//                    
//                    [UserInfoHelper storeTopicId:topicId];
//                    
//                    [self loadWithCache:YES more:NO];
//                }else{
//                    _flags.isLoading = NO;
//                    _flags.isModelLoaded = YES;
//                    
//                    self.datas = [NSArray array];
//                    
//                    [self updateView];
//                }
                
            }else{
                
            }
            
        } errorHandler:^(NSError *error) {
            
        }];
    }

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (MKNetworkEngine *)engine
{
    if (!_engine) {
        self.engine = [Tuji_topic_item_list_engine sharedInstance];
    }
    
    return _engine;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
    

    NSString * uid = [[UserInfoHelper userInfo] objectForKey:@"user_id"];
    [(Tuji_topic_item_list_engine *)self.engine operationWithTopicId:_topicId userId:uid pageSize:@"40" page:[NSString stringWithFormat:@"%i", _currentPage] completionHandler:^(NSString *response, MKNetworkOperation *op) {
        _flags.isModelLoaded = YES;
        _flags.isLoading = NO;
        
        if (!self.datas) {
            self.datas = [NSMutableArray arrayWithCapacity:20];
        }
        if (self.needPullRefresh && [self.refreshControl refreshing]) {
            self.datas = [NSMutableArray arrayWithCapacity:20];
            double delayInSeconds = 0.5;
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

- (void)showEmpty:(BOOL)show
{
    if (show) {
        ErrorView * errorView = [[ErrorView alloc] initWithTitle:nil subtitle:nil image:[UIImage imageNamed:@"no_fav.png"]];
        errorView.backgroundColor = rgba(245, 245, 245, 1);
        
        self.emptyView = errorView;
        
        _flags.isShowingModel = NO;
        
        _tableView.collectionViewDataSource = nil;
        
        [_tableView reloadData];
    }else{
        self.emptyView = nil;
    }
}

@end
