//
//  kata_UINavigationController.m
//  CityStar
//
//  Created by 黎 斌 on 12-8-3.
//  Copyright (c) 2012年 kata. All rights reserved.
//

#import "KATAUINavigationController.h"
#import "KATAUINavigationBar.h"

#import "CommonDef.h"

@interface KATAUINavigationController ()

- (UIBarButtonItem *)createBackBarButonItem;

- (void)popSelf;

@end

@implementation KATAUINavigationController


- (id)init
{
    self = [super init];
    if (self) {
        
        [self setValue:[[KATAUINavigationBar alloc] init] forKey:@"navigationBar"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//	[self setValue:[[KATAUINavigationBar alloc] init] forKey:@"navigationBar"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 自定义返回按钮
- (void)popSelf
{
	[self popViewControllerAnimated:YES];
}
- (UIBarButtonItem *)createBackBarButonItem
{
	UIButton * backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
	[backBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	[backBarButton setBackgroundImage:[UIImage imageNamed:@"back_active.png"] forState:UIControlStateHighlighted];
	
//	[backBarButton setTitle:@"返回" 
//				   forState:UIControlStateNormal];
//	
//	[[backBarButton titleLabel] setFont:[UIFont boldSystemFontOfSize:14]];
//	[backBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
//	[backBarButton setTitleShadowColor:rgba(33, 33, 33, 0.75) forState:UIControlStateNormal];
//	[[backBarButton titleLabel] setShadowOffset:CGSizeMake(0, -1)];
	
	[backBarButton addTarget:self
					  action:@selector(popSelf) 
			forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
	backBarButtonItem.style = UIBarButtonItemStylePlain;
	
    return backBarButtonItem;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[super pushViewController:viewController animated:animated];
	if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1) {
		[viewController.navigationItem setLeftBarButtonItem:[self createBackBarButonItem] animated:YES];
	}
}
- (void)redrawCustomBg
{
    [self setValue:[[KATAUINavigationBar alloc] init] forKey:@"navigationBar"];
    [(KATAUINavigationBar *)self.navigationBar setNavBgImageName:MAIN_NAV_BG_NAME];
    
}


@end
