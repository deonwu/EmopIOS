//
//  WebDetailViewController.m
//  zaol
//
//  Created by hark2046 on 13-3-5.
//
//

#import "WebDetailViewController.h"

@interface WebDetailViewController ()

@property (strong, nonatomic) UIActivityIndicatorView * loadingView;

@end

@implementation WebDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationItem.title = [[self query] objectForKey:@"title"];
    
	// Do any additional setup after loading the view.
    self.loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [_loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [_loadingView setHidesWhenStopped:YES];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:_loadingView];
    [_loadingView startAnimating];
    
    self.navigationItem.rightBarButtonItem = item;
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    
    [webView setDelegate:self];
    
    [self.view addSubview:webView];
    
    NSLog([self.query objectForKey:@"url"]);
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.query objectForKey:@"url"]]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.loadingView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.loadingView stopAnimating];
}

@end
