//
//  BaseTableViewController.h
//  zaol
//
//  Created by li bin on 13-2-22.
//
//

#import "BaseViewController.h"
#import "MKNetworkOperation.h"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView * tableView;

@end
