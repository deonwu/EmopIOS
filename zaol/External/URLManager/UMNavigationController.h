//
//  UMViewController.h
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KATAUINavigationController.h"

@class UMViewController;

@interface UMNavigationController : KATAUINavigationController

@property (strong, nonatomic)   UMViewController *rootViewController;

+ (NSMutableDictionary *)config;
+ (void)setViewControllerName:(NSString *)className forURL:(NSString *)url;

- (id)initWithRootViewControllerURL:(NSURL *)url;


- (id)initWithRootViewControllerURL:(NSURL *)url query:(NSDictionary *)quer;

- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query;
- (void)openURL:(NSURL *)url;
- (BOOL)URLAvailable:(NSURL *)url;
- (UMViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query;

@end
