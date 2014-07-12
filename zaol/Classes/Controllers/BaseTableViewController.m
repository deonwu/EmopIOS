//
//  BaseTableViewController.m
//  zaol
//
//  Created by li bin on 13-2-22.
//
//

#import "BaseTableViewController.h"
#import "CommonDef.h"

@interface BaseTableViewController ()


@end

@implementation BaseTableViewController

- (void)loadView
{
    UITableViewStyle style = [[[self params] objectForKey:@"style"] isEqualToString:@"Group"]?UITableViewStyleGrouped:UITableViewStylePlain;
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:style];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    [_tableView setBackgroundColor:rgba(240, 240, 240, 1)];
    
    self.view = _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    _isViewAppearing = YES;
    _hasViewAppeared = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [[self params] objectForKey:@"title"];
}

- (NSString *)tabImageName
{
    return (NSString *)[self.params objectForKey:@"icon"];
}

- (NSString *)selectedTabImageName
{
    return (NSString *)[self.params objectForKey:@"icon_selected"];
}

- (NSString *)tabTitle
{
    return (NSString *)[self.params objectForKey:@"title"];
}

- (void)didReceiveMemoryWarning
{
    if (_hasViewAppeared && !_isViewAppearing) {
        [super didReceiveMemoryWarning];
    }else{
        [super didReceiveMemoryWarning];
    }
}

/////////////////////////////////////////////////////////////////////////////////////////


@end
