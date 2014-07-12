//
//  WeiboShareViewController.m
//  zaol
//
//  Created by hark2046 on 13-3-8.
//
//

#import "WeiboShareViewController.h"

#import "MBProgressHUD.h"

#import "UserInfoHelper.h"
#import "Config.h"

#import "CommonDef.h"

#import <QuartzCore/QuartzCore.h>

@interface WeiboShareViewController ()

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UITextView * contentView;

@property (strong, nonatomic) MBProgressHUD * hud;

- (void)sendWeibo;


- (void)keyboardWillShow:(NSNotification *)notif;
- (void)resizeTextViewWithKeyboardHeight:(float)keyboardHeight withDuration:(NSTimeInterval)duration withCure:(UIViewAnimationCurve)curve;

@end

@implementation WeiboShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.navigationItem setTitle:[self.query objectForKey:@"title"]];
    
    //        add observer for keyboard
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    
    //    返回按钮
    UIButton * backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
	[backBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	[backBarButton setBackgroundImage:[UIImage imageNamed:@"back_active.png"] forState:UIControlStateHighlighted];
	
	[backBarButton addTarget:self
					  action:@selector(goBack)
			forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
	backBarButtonItem.style = UIBarButtonItemStylePlain;
    
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - keyboad height changed
- (void)keyboardWillShow:(NSNotification *)notif
{
	
	NSDictionary * userInfo = [notif userInfo];
	
	NSValue * endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	
	CGRect keyboardRect = [endFrameValue CGRectValue];
	
	NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	
    NSTimeInterval animationDuration;
	
    [animationDurationValue getValue:&animationDuration];
	
	NSValue * animationCurveValue = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	UIViewAnimationCurve curve;
	[animationCurveValue getValue:&curve];
	
	[self resizeTextViewWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration withCure:curve];
}

- (void)resizeTextViewWithKeyboardHeight:(float)keyboardHeight withDuration:(NSTimeInterval)duration withCure:(UIViewAnimationCurve)curve
{
//	float targetHeight = CGRectGetHeight(self.view.frame) - keyboardHeight;
    //
    
    if (![_contentView isFirstResponder]) {
        return;
    }
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:curve];
	[UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didAnimFinish:)];
//    [self.tableView setContentOffset:CGPointMake(0, keyboardHeight) animated:YES];
    [self.tableView setContentInset:UIEdgeInsetsMake(-keyboardHeight, 0, 0, 0)];
	[UIView commitAnimations];
}


//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma send

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)sendWeibo
{
    
    if ([_contentView isFirstResponder]) {
        [_contentView resignFirstResponder];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.2];
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [UIView commitAnimations];
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    
    SinaWeibo * sinaweibo = [[SinaWeibo alloc] initWithAppKey:WeiboAppKey appSecret:WeiboSecret appRedirectURI:WeiboRedirectURI andDelegate:self];
    
    NSDictionary * weiboAuthData = [UserInfoHelper sinaWeiboAuthData];
    if ([weiboAuthData objectForKey:@"AccessTokenKey"] && [weiboAuthData objectForKey:@"ExpirationDateKey"] && [weiboAuthData objectForKey:@"UserIDKey"])
    {
        sinaweibo.accessToken = [weiboAuthData objectForKey:@"AccessTokenKey"];
        sinaweibo.expirationDate = [weiboAuthData objectForKey:@"ExpirationDateKey"];
        sinaweibo.userID = [weiboAuthData objectForKey:@"UserIDKey"];
    }
    
    [sinaweibo requestWithURL:@"statuses/upload.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:_contentView.text,@"status", _imageView.image, @"pic", nil]
                   httpMethod:@"POST"
                     delegate:self];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma table view

//////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50.0f)];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(v.frame) - 10, 40)];
    
    [button setTitle:@"分享到新浪微博" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:rgba(255, 59, 62, 1)];
    
    [button addTarget:self action:@selector(sendWeibo) forControlEvents:UIControlEventTouchUpInside];
    
    [v addSubview:button];
    
    return v;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    
    if (row == 0) {
        return CGRectGetHeight(self.tableView.frame) - 170.0;
    }
    return 120.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const imageCellId = @"image";
    static NSString * const inputCellId = @"input";
    
    UITableViewCell * cell;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:imageCellId];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellId];
            
            self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cell.frame) - 10, CGRectGetHeight(cell.frame) - 10)];
            
            [_imageView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
            
            [_imageView setContentMode:UIViewContentModeScaleAspectFill];
            
            [_imageView setClipsToBounds:YES];
            
            [cell.contentView addSubview:_imageView];
        }
        
        _imageView.image = [self.query objectForKey:@"pic"];
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:inputCellId];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inputCellId];
            
            self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(cell.frame) - 10, CGRectGetHeight(cell.frame) - 10)];
            
            [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
            
            [_contentView setDelegate:self];
            [_contentView setContentInset:UIEdgeInsetsMake(5, 0, 5, 0)];
            [_contentView setReturnKeyType:UIReturnKeyDone];
            [_contentView setFont:[UIFont systemFontOfSize:14.0f]];
            
            [[_contentView layer] setCornerRadius:5];
            [[_contentView layer] setMasksToBounds:YES];
            [[_contentView layer] setBorderWidth:1];
            [[_contentView layer] setBorderColor:[rgba(200, 200, 200, 1) CGColor]];
            
            [cell.contentView addSubview:_contentView];
        }
        
        _contentView.text = [self.query objectForKey:@"message"];
    }
    
    return cell;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma textview delegate

//////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.length != 1 && [text isEqualToString:@"\n"]) {
        
        
        
        [_contentView resignFirstResponder];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.2];
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [UIView commitAnimations];
        
        return NO;
    }
    return YES;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma sinaweibo request delegate

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [_hud setMode:MBProgressHUDModeText];
    [_hud setLabelText:@"分享成功"];
    
    [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [_hud setMode:MBProgressHUDModeText];
    [_hud setLabelText:@"分享失败，请重试"];
    
    [_hud hide:YES afterDelay:1.5];
}

@end
