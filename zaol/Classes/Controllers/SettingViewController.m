//
//  SettingViewController.m
//  zaol
//
//  Created by Bin Li on 13-2-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "UserInfoHelper.h"
#import "CommonDef.h"

#import "SettingCell.h"

#import "MBProgressHUD.h"

#import "SDImageCache.h"

#import "AboutViewController.h"

#import "CCIconLabel.h"

@interface SettingViewController()

@property (strong, nonatomic) NSMutableArray * datas;
- (void)btnClicked:(id)sender event:(id)event;
@end

@implementation SettingViewController

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
    
    [self.tableView setBackgroundColor:rgba(246, 246, 246, 1)];
    [self.tableView setBackgroundView:nil];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (void)createDatasource
{
    self.datas = [NSMutableArray arrayWithCapacity:2];
    
    NSMutableArray * section1RowData = [NSMutableArray arrayWithCapacity:3];
    
    if ([UserInfoHelper taobaoAuthData]) {
        NSString * userName = [[UserInfoHelper taobaoAuthData] objectForKey:@"userName"];
        [section1RowData addObject:@{@"isLogined":@"1", @"title":[NSString stringWithFormat:@"已绑定用户:%@", userName], @"icon":@"taobao_l.png"}];
    }else{
        [section1RowData addObject:@{@"isLogined":@"0", @"title":@"设置淘宝账号登陆", @"icon":@"taobao_l.png"}];
    }
    
    if ([UserInfoHelper tencentAuthData]) {
        NSString * userName = [[UserInfoHelper tencentAuthData] objectForKey:@"userName"];
        [section1RowData addObject:@{@"isLogined":@"1", @"title":[NSString stringWithFormat:@"已绑定用户:%@", userName], @"icon":@"qq_l.png"}];
    }else{
        [section1RowData addObject:@{@"isLogined":@"0", @"title":@"设置QQ账号登陆", @"icon":@"qq_l.png"}];
    }
    
    if ([UserInfoHelper sinaWeiboAuthData]) {
        NSString * userName = [[UserInfoHelper sinaWeiboAuthData] objectForKey:@"userName"];
        [section1RowData addObject:@{@"isLogined":@"1", @"title":[NSString stringWithFormat:@"已绑定用户:%@", userName], @"icon":@"sina_l.png"}];
    }else{
        [section1RowData addObject:@{@"isLogined":@"0", @"title":@"设置新浪微博账号登陆", @"icon":@"sina_l.png"}];
    }
    
    NSMutableDictionary * section1Dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"用户绑定",@"sectionTitle" ,section1RowData, @"data", nil];
    
//    Group 2
    NSMutableArray * section2RowData = [NSMutableArray arrayWithCapacity:2];
    [section2RowData addObject:@{@"title":@"清除本地缓存", @"icon":@"setting_clear_up.png"}];
    [section2RowData addObject:@{@"title":@"关于兜兜购", @"icon":@"setting_about.png"}];
    
    NSMutableDictionary * section2Dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"其他",@"sectionTitle",section2RowData, @"data", nil];
    
    [self.datas addObject:section1Dict];
    [self.datas addObject:section2Dict];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma table view delegate && datasource

//////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary * sectionData = [self.datas objectAtIndex:section];
    
    NSArray * rowsData = [sectionData objectForKey:@"data"];
    
    return [rowsData count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.datas count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSMutableDictionary * sectionData = [self.datas objectAtIndex:section];
    return [sectionData objectForKey:@"sectionTitle"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const userCellId = @"UserCellIdentifier";
    static NSString * const funCellId = @"FunCellIdentifier";
    
    UITableViewCell * cell;
    
    NSDictionary * sectionData = [self.datas objectAtIndex:indexPath.section];
    NSArray * rowsData = [sectionData objectForKey:@"data"];
    
    NSDictionary * rowData = [rowsData objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:userCellId];
        
        if (!cell) {
            cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userCellId];
            
            [cell.textLabel setTextColor:rgba(140, 140, 140, 1)];
            
            [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_bg.png"]]];
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
            
            [button setFrame:CGRectMake(0, 0, 43, 21)];
            
            cell.accessoryView = button;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIButton * btn = (UIButton *)cell.accessoryView;
        if ([[rowData objectForKey:@"isLogined"] intValue] == 1) {
            [btn setImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
        }else{
            
            [btn setImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
        }
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:funCellId];
        if (!cell) {
            cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:funCellId];
            
            [cell.textLabel setTextColor:rgba(140, 140, 140, 1)];
            
            [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setting_cell_bg.png"]]];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
    }
    
    cell.imageView.image = [UIImage imageNamed:[rowData objectForKey:@"icon"]];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
    cell.textLabel.text = [rowData objectForKey:@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self clearCache];
        }else{
            [self showAbout];
        }
    }
}

- (void)clearCache
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(clearInBack) withObject:nil];
    
    [hud hide:YES];
}

- (void)clearInBack
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] cleanDisk];
}

- (void)showAbout
{
    AboutViewController * vc = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
    
    [vc setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 36.0f)];
    
    NSMutableDictionary * sectionData = [self.datas objectAtIndex:section];
    
    CCIconLabel * iconLabel = [[CCIconLabel alloc] initWithIcon:@"setting_section_dot.png" text:[sectionData objectForKey:@"sectionTitle"] textColor:rgba(170, 170, 170, 1) fontSize:14.0f];
    
    [iconLabel isBold:YES];
    
    [iconLabel setFrame:CGRectMake(10, 0, CGRectGetWidth(iconLabel.frame), 36.0f)];
    
    [v addSubview:iconLabel];
    
    return v;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma login && logout

//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)btnClicked:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    
    if(indexPath != nil)
        
    {
        
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
        
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * sectionData = [self.datas objectAtIndex:indexPath.section];
    NSArray * rowsData = [sectionData objectForKey:@"data"];
    
    NSDictionary * rowData = [rowsData objectAtIndex:indexPath.row];
    
    switch (indexPath.row) {
        case 0:
        {
            if ([[rowData objectForKey:@"isLogined"] intValue]) {
//                注销
                [UserInfoHelper taobaoLogout];
                [self logoutIfNeed];
                [self reload];
            }else{
                [UserInfoHelper showLoginPage:@"taobao"];
            }
        }
            break;
        case 1:
        {
            
            if ([[rowData objectForKey:@"isLogined"] intValue]) {
                //                注销
                [UserInfoHelper tencentLogout];
                [self logoutIfNeed];
                [self reload];
            }else{
                [UserInfoHelper showLoginPage:@"qq"];
            }
        }
            break;
        case 2:
        {
            if ([[rowData objectForKey:@"isLogined"] intValue]) {
                //                注销
                [UserInfoHelper sinaWeiboLogout];
                [self logoutIfNeed];
                [self reload];
            }else{
                [UserInfoHelper showLoginPage:@"sinaWeibo"];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)logoutIfNeed
{
    if (![UserInfoHelper taobaoAuthData] && ![UserInfoHelper sinaWeiboAuthData] && ![UserInfoHelper tencentAuthData] && [UserInfoHelper userInfo]) {
        [UserInfoHelper removeUserBindInfo];
    }
}

- (void)reload
{
    [self createDatasource];
    [self.tableView reloadData];
}

@end
