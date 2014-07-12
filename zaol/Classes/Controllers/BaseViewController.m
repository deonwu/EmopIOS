//
//  BaseViewController.m
//  zaol
//
//  Created by li bin on 13-2-18.
//
//

#import "BaseViewController.h"
#import "UIViewController+AKTabBarController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
        _hasViewAppeared = NO;
    }else{
        [super didReceiveMemoryWarning];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - life circle

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _isViewAppearing = YES;
    _hasViewAppeared = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _isViewAppearing = NO;
}



@end
