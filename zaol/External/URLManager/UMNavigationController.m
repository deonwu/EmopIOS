//
//  UMViewController.m
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import "UMNavigationController.h"
#import "UMViewController.h"
#import "UMWebViewController.h"

#import "KATAUINavigationBar.h"

@interface UMNavigationController ()
{
//    是否收到内存报警
    BOOL receivedMemoryWarning;
}
@end

@implementation UMNavigationController

@synthesize rootViewController = _rootViewController;

#pragma mark - static

+ (NSMutableDictionary *)config
{
    static NSMutableDictionary *config;
    if (nil == config) {
        config = [[NSMutableDictionary alloc] init];
    }
    
    return config;
}

+ (void)setViewControllerName:(NSString *)className forURL:(NSString *)url
{
    [[UMNavigationController config] setValue:className forKey:url];
}

#pragma mark - public

- (id)initWithRootViewControllerURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        UMViewController *rootVC = [self viewControllerForURL:url withQuery:nil];
        self = [self initWithRootViewController:rootVC];
        return self;
    }
    return nil;
}


- (id)initWithRootViewControllerURL:(NSURL *)url query:(NSDictionary *)query
{
    self = [super init];
    if (self) {
        UMViewController *rootVC = [self viewControllerForURL:url withQuery:query];
        self = [self initWithRootViewController:rootVC];
        return self;
    }
    return nil;
}

- (void)openURL:(NSURL *)url
{
    [self openURL:url withQuery:nil];
}

- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    UMViewController *lastViewController = (UMViewController *)[self.viewControllers lastObject];
    UMViewController *viewController = [self viewControllerForURL:url withQuery:query];
    if ([lastViewController shouldOpenViewControllerWithURL:url]) {
        [self pushViewController:viewController animated:YES];
        [viewController openedFromViewControllerWithURL:lastViewController.url];
    }
}

- (UMViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
    UMViewController * viewController = nil;

    if ([self URLAvailable:url]) {
        Class class = NSClassFromString([[UMNavigationController config] objectForKey:urlString]);
        
        if (nil == query) {
            viewController = (UMViewController *)[[class alloc] initWithURL:url];
        }
        else {
            viewController = (UMViewController *)[[class alloc] initWithURL:url query:query];
        }
        viewController.navigator = self;
    }
    else if ([@"http" isEqualToString:[url scheme]]) {
        viewController = (UMViewController *)[[UMWebViewController alloc] initWithURL:url query:query];
    }
    
    return viewController;
}

- (BOOL)URLAvailable:(NSURL *)url
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
    return [[[UMNavigationController config] allKeys] containsObject:urlString];
}

#pragma parent

- (id)initWithRootViewController:(UMViewController *)aRootViewController
{
    self = [super initWithRootViewController:aRootViewController];
    if (self) {
        aRootViewController.navigator = self;
        self.rootViewController = aRootViewController;
        return self;
    }
    return nil;
}

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    设置NavigationBar的自定义背景
    KATAUINavigationBar * navBar = (KATAUINavigationBar *)self.navigationBar;
	if (navBar) {
		[navBar setNavBgImageName:MAIN_NAV_BG_NAME];
	}
}
#pragma mark - 解决内存报警引起的界面刷新为默认状态的问题
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    receivedMemoryWarning = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (receivedMemoryWarning) {
        [self setValue:[[KATAUINavigationBar alloc] init] forKey:@"navigationBar"];
        KATAUINavigationBar * navBar = (KATAUINavigationBar *)[self navigationBar];
        if (navBar) {
            [navBar setNavBgImageName:MAIN_NAV_BG_NAME];
        }
        
        receivedMemoryWarning = NO;
    }
}

@end
