//
//  ShoppingViewController.m
//  zaol
//
//  Created by Bin Li on 13-2-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ShoppingViewController.h"
#import "TDHHelper.h"
#import "GuangListCell.h"
#import "JSONKit.h"

#import "ItemVO.h"

#import "Tuji_User_Topic_List_Engine.h"

const int kPageSize = 30;


@interface ShoppingViewController()

//@property (strong, nonatomic) NSMutableArray * datasource;

@end

@implementation ShoppingViewController

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
    [super viewDidLoad];
    
    self.needPullRefresh = YES;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
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

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark about list


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (height) {
        return height;
    }
    
    return [GuangListCell tableView:tableView rowHeightForObject:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self shouldLoadMore]?([self.datas count] + 1):[self.datas count];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const guangListCellIdentifier = @"GuangListCelIdentifier";

    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell) {
        return cell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:guangListCellIdentifier];
    
    if (!cell) {
        cell = [[GuangListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:guangListCellIdentifier];
    }
    
    [(GuangListCell *)cell setObject:[self.datas objectAtIndex:indexPath.row]];
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectedObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    ItemVO * vo = (ItemVO *)object;
    [self.navigator openURL:[NSURL URLWithString:@"tdh://topic"] withQuery:@{@"title": @"逛街",@"topic_id": [vo id]}];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Override


///////////////////////////////////////////////////////////////////////////////////////////////////
- (MKNetworkEngine *)engine
{
    if (!_engine) {
        self.engine = [Tuji_User_Topic_List_Engine sharedInstance];
    }
    return _engine;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadWithCache:(BOOL)cache more:(BOOL)more
{
    [super loadWithCache:cache more:more];
    
    if (more){
        _currentPage++;
    }else{
        _currentPage = 0;
    }
    
    [(Tuji_User_Topic_List_Engine *)self.engine operationWithPage:_currentPage
                                                         pageSize:kPageSize
                                                             cate:3
                                                completionHandler:^(NSString *response, MKNetworkOperation *op) {
//                                                    NSLog(@"%@", response);
                                                    
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
                                                    
                                                    NSDictionary * topics = [response objectFromJSONString];
                                                    
                                                    if ([[topics objectForKey:@"status"] isEqualToString:@"ok"] && [[[topics objectForKey:@"data"] objectForKey:@"items"] isKindOfClass:[NSArray class]]) {
                                                        if (!_maxPage) {
                                                            _maxPage = floor([[[topics objectForKey:@"data"] objectForKey:@"item_count"] intValue] / kPageSize);
                                                        }
                                                        
                                                        NSArray * items = [ItemVO ItemsWithArray:[[topics objectForKey:@"data"] objectForKey:@"items"]];
                                                        
                                                        [self.datas addObjectsFromArray:items];
                                                        
                                                        self.modelError = nil;
                                                        
                                                    }else{
                                                        
                                                        self.modelError = [[NSError alloc] initWithDomain:@"Data Error" code:0 userInfo:nil];
                                                    }
                                                    
                                                    [self updateView];
                                                    
                                                    
                                                } errorHandler:^(NSError *error) {
                                                    
                                                    NSLog(@"%@", [error localizedDescription]);
                                                    self.modelError = error;
                                                    
                                                    [self updateView];
                                                }];
}

@end
