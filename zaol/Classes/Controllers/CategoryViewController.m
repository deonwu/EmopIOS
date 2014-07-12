//
//  CategoryViewController.m
//  zaol
//
//  Created by Bin Li on 13-2-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"

#import "TDHHelper.h"
#import "JSONKit.h"

#import "Tuji_User_Topic_List_Engine.h"
#import "CateVO.h"

#import "ListViewController.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
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
    
    return [CategoryCell tableView:tableView rowHeightForObject:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil([self.datas count] / 2.0);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const categoryCellIdentifier = @"categoryIdentifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:categoryCellIdentifier];
    
    if (!cell) {
        cell = [[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryCellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [(CategoryCell *)cell setCellDelegate:self];
    }
    
    int idx = indexPath.row * 2;
    
    [(CategoryCell *)cell setLeftCateData:[self.datas objectAtIndex:idx]];
    [(CategoryCell *)cell setRightCateData:[self.datas objectAtIndex:(idx + 1)]];
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didClickItemWithData:(CateVO *)data
{
    
//    NSLog(@"selected category:%@", data);
    
    ListViewController * vc = [[ListViewController alloc] initWithURL:[NSURL URLWithString:@"tdh://list"] query:@{@"title":data.topic_name, @"topic_id":data.id}];
    
    [vc setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectedObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark load data
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
    
    [(Tuji_User_Topic_List_Engine *)self.engine operationWithPage:0
                                                         pageSize:0
                                                             cate:4
                                                completionHandler:^(NSString *response, MKNetworkOperation *op) {
                                                    
                                                    _flags.isModelLoaded = YES;
                                                    _flags.isLoading = NO;
                                                    
                                                    if (!self.datas) {
                                                        self.datas = [NSMutableArray arrayWithCapacity:10];
                                                    }
                                                    
                                                    NSDictionary * cates = [response objectFromJSONString];
                                                    
                                                    if ([[cates objectForKey:@"status"] isEqualToString:@"ok"]) {
                                                        NSArray * items = [CateVO CatesWithArray:[[cates objectForKey:@"data"] objectForKey:@"items"]];
                                                        
                                                        NSSortDescriptor * sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"view_order" ascending:YES];
                                                        
                                                        NSArray * sorted = [items sortedArrayUsingDescriptors:@[sortDesc]];
                                                        
                                                        [self.datas addObjectsFromArray:sorted];
                                                        
                                                        self.modelError = nil;
                                                    }else{
                                                        self.modelError = [[NSError alloc] initWithDomain:[cates objectForKey:@"code"] code:0 userInfo:nil];
                                                    }
                                                    
                                                    [self updateView];
    }
                                                     errorHandler:^(NSError *error) {
                                                         self.modelError = error;
                                                         
                                                         [self updateView];
    }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldLoadMore
{
    return NO;
}
@end
