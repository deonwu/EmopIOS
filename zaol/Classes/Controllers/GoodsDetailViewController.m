//
//  GoodsDetailViewController.m
//  zaol
//
//  Created by hark2046 on 13-3-3.
//
//

#import <QuartzCore/QuartzCore.h>

#import "GoodsDetailViewController.h"

#import "CommonDef.h"

#import "UIImageView+WebCache.h"

#import "CCIconLabel.h"

#import "GoodsDetailView.h"

#import "Cms_Get_Uuid_Content_Engine.h"

#import "DetailVO.h"

#import "JSONKit.h"

#import "WebDetailViewController.h"

#import "MBProgressHUD.h"

#import "UserInfoHelper.h"

#import "Tuji_User_Topic_List_Engine.h"
#import "Tuji_Topic_Fav.h"

#import "WXApi.h"
#import "WXApiObject.h"

#import "SinaWeibo.h"

#import "WeiboShareViewController.h"

#import "ToolbarButton.h"

#import "Config.h"

#import "GoodsVO.h"

@interface GoodsDetailViewController ()
{
    BOOL _isWeiboShareShow;
    
    int curIndex;
}

@property (strong, nonatomic) GoodsDetailView * goodsDetailView;

@property (assign, nonatomic) SEL delayJob;

@property (assign, nonatomic) BOOL isFav;

@property (strong, nonatomic) NSString * topicId;

-(void)doWeiboShare;

- (void)doWeiXinShare;

- (void)doFavOper;

- (void)addFav;
- (void)removeFav;

- (void)toBuy;


@end

@implementation GoodsDetailViewController

- (void)loadView
{
    [super loadView];
    
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    
    [[self.navigationController toolbar] setTintColor:rgba(249, 249, 249, 1)];
    
    UIBarButtonItem * share = [self createItemWithTitle:@"分享" selectedTitle:@"分享" image:@"detail_share.png" activeImage:@"detail_share_active.png" selector:@selector(doWeiboShare)];
    
    [share setTag:101];
    
    UIBarButtonItem * weixin = [self createItemWithTitle:@"朋友圈" selectedTitle:@"朋友圈" image:@"detail_weixin.png" activeImage:@"detail_weixin.png" selector:@selector(doWeiXinShare)];
    
    [weixin setTag:102];
    
    UIBarButtonItem * fav = [self createItemWithTitle:@"收藏" selectedTitle:@"已收藏" image:@"detail_fav.png" activeImage:@"detail_fav_active.png" selector:@selector(doFavOper)];
    
    [fav setTag:103];
    
    UIBarButtonItem * buy = [self createItemWithTitle:@"购买" selectedTitle:@"购买" image:@"detail_buy.png" activeImage:@"detail_buy.png" selector:@selector(toBuy)];
    
    [buy setTag:104];
    
    self.toolbarItems = @[[self createSpace],share,[self createSpace], weixin,[self createSpace], fav,[self createSpace], buy,[self createSpace]];
    
}

- (UIBarButtonItem *)createSpace
{
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    return space;
}

- (UIBarButtonItem *)createItemWithTitle:(NSString *)title image:(NSString *)image activeImage:(NSString *)activeImage selector:(SEL)selector;
{
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:activeImage] forState:UIControlStateHighlighted];
    
//    [btn setImage:[UIImage imageNamed:activeImage] forState:UIControlStateSelected];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return item;
}

- (UIBarButtonItem *)createItemWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle image:(NSString *)image activeImage:(NSString *)activeImage selector:(SEL)selector
{
    ToolbarButton * btn = [[ToolbarButton alloc] initWithTitle:title seletedTitle:selectedTitle image:[UIImage imageNamed:image] selectedImage:[UIImage imageNamed:activeImage]];
    [btn setFrame:CGRectMake(0, 0, 60, 44)];
    
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return item;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:rgba(240, 240, 240, 1)];
    
    [self.navigationItem setTitle:[self.query objectForKey:@"title"]];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:LOGIN_CANCEL object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        self.delayJob = nil;
        
    }];
    
    
    self.goodsDetailView = [[GoodsDetailView alloc] initWithPlaceholderImage:[self.query objectForKey:@"pic"] andPrice:[self.query objectForKey:@"price"]];
    [_goodsDetailView setFrame:self.view.bounds];
    [_goodsDetailView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    [_goodsDetailView.buyButton addTarget:self action:@selector(didClickToBuy:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_goodsDetailView];
    
    [self loadDataWithUUID:[self.query objectForKey:@"uuid"]];
    
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 20130409 增加左右滑动翻页效果
////////////////////////////////////////////////////////////////////////////////////////////////////
    [self addGestureRecognizer];
}

- (void)loadDataWithUUID:(NSString *)uuid{
    [[Cms_Get_Uuid_Content_Engine sharedInstance] cancelAllOperations];
    [[Cms_Get_Uuid_Content_Engine sharedInstance] operationWithUUID:uuid
                                                  completionHandler:^(NSString *response, MKNetworkOperation *op) {
                                                      NSDictionary * goodsData = [response objectFromJSONString];
                                                      if ([[goodsData objectForKey:@"status"] isEqualToString:@"ok"]) {
                                                          DetailVO * vo = [DetailVO DataWithDictionary:[goodsData objectForKey:@"data"]];
                                                          
                                                          [_goodsDetailView setData:vo];
                                                          
                                                          self.isFav = [vo.is_fav boolValue];
                                                          ToolbarButton * btn = [self favBtn];
                                                          //                                                          设置当前收藏状态
                                                          if (_isFav) {
                                                              
                                                              [btn showSelectedStatus:YES];
                                                              
                                                              //                                                              [btn setHighlighted:YES];
                                                          }else{
                                                              [btn showSelectedStatus:NO];
                                                          }
                                                          
                                                      }
                                                  }
                                                       errorHandler:^(NSError *error) {
                                                           
                                                       }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _isWeiboShareShow = false;
    
    if (self.delayJob) {
        [self performSelector:@selector(checkDelayJob) withObject:self afterDelay:0.5];
    }
}

- (void)checkDelayJob
{
    if (self.delayJob) {
        [self performSelector:_delayJob withObject:self afterDelay:0.5];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!_isWeiboShareShow) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (ToolbarButton *)favBtn
{
    for (UIBarButtonItem * item in self.toolbarItems) {
        if (item.tag == 103) {
            ToolbarButton * btn = (ToolbarButton *)item.customView;
            
            return btn;
        }
    }
    return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma about buy

////////////////////////////////////////////////////////////////////////////////////////////
- (void)toBuy
{
    if (![UserInfoHelper taobaoAuthData]){
        
        
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"您还没有绑定淘宝账号" message:@"现在就使用淘宝账号绑定？" delegate:self cancelButtonTitle:@"继续购买" otherButtonTitles:@"现在绑定", nil];
        
        [alertView show];
        
        return;
    }
    
    self.delayJob = nil;
    
    [self didClickToBuy:nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            self.delayJob = nil;
            
            [self didClickToBuy:nil];
        }
            break;
        case 1:
        {
            
            if (self.delayJob) {
                self.delayJob = nil;
            }else{
                self.delayJob = @selector(toBuy);
            }
            [UserInfoHelper showLoginPage:@"taobao"];
        }
            break;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////
- (void)didClickToBuy:(id)sender
{
    WebDetailViewController * vc = [[WebDetailViewController alloc] initWithURL:[NSURL URLWithString:@"tdh://webdetail"] query:@{@"title":@"手机淘宝",@"url":[NSString stringWithFormat:@"http://www.emop.cn/ShortUrlRouteNew.php/c/%@?from=app&auto_mobile=y", _goodsDetailView.data.short_url_key]}];
    
    [vc setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:vc animated:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma about weibo share

////////////////////////////////////////////////////////////////////////////////////////////
- (void)doWeiboShare
{
    if (![UserInfoHelper sinaWeiboAuthData]) {
        
        if (self.delayJob) {
            self.delayJob = nil;
        }else{
            self.delayJob = @selector(doWeiboShare);
        }
        
        [UserInfoHelper showLoginPage:@"sinaWeibo"];
        
        return;
    }
    
    self.delayJob = nil;
    
//    开始进行新浪微博分享
    
    UIImage * img = _goodsDetailView.image;
    NSString * text = _goodsDetailView.data.message;
    
    
//    WeiboShareViewController * vc = [[WeiboShareViewController alloc] initWithURL:[NSURL URLWithString:@"tdh://shareWithWeibo"] query:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"逛街", @""),@"title",@"nav_menu_guang.png", @"icon",@"nav_menu_guang.png", @"icon_selected",@"Plain", @"style",img,@"pic",text, @"message",nil]];
    
    UMNavigationController * shareWithWeibo = [[UMNavigationController alloc] initWithRootViewControllerURL:[NSURL URLWithString:@"tdh://shareWithWeibo"] query:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"分享到新浪微博", @""),@"title",@"nav_menu_guang.png", @"icon",@"nav_menu_guang.png", @"icon_selected",@"Plain", @"style",img,@"pic",text, @"message",nil]];
    
    _isWeiboShareShow = YES;
    
    [self presentModalViewController:shareWithWeibo animated:YES];
    
}

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma about weixin share

////////////////////////////////////////////////////////////////////////////////////////////
- (void)doWeiXinShare
{
    WXMediaMessage *message = [WXMediaMessage message];
    
    [message setTitle:@"亲，帮忙给点建议"];
    if (_goodsDetailView.data) {
        
        [message setDescription:_goodsDetailView.data.message];
    }
    
    NSMutableString * picUrl = [NSMutableString stringWithString:[self.query objectForKey:@"picUrl"]];
    
    NSRange range1 = [picUrl rangeOfString:@"mobile01.b0.upaiyun.com"];
    NSRange range2 = [picUrl rangeOfString:@"tdcms.b0.upaiyun.com"];
    
    if (range1.location != NSNotFound || range2.location != NSNotFound) {
        [picUrl appendString:@"!190"];
    }
    
    NSData * dat = [NSData dataWithContentsOfURL:[NSURL URLWithString:picUrl]];
    
    CGFloat rate = 1;
    while (dat.length > 32000) {
        UIImage * img = [UIImage imageWithData:dat];
        
        rate /= 2;
        
        dat = UIImageJPEGRepresentation(img, rate);
        
        if (rate < 0.1) {
            break;
        }
    }
    
    while (dat.length > 32000) {
//        如果无法通过图片压缩减小到32k以下，则缩小图片尺寸
        UIImage * img = [UIImage imageWithData:dat scale:0.5];
        dat = UIImageJPEGRepresentation(img, 0.8);
    }
    
    [message setThumbData:dat];
    
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [NSString stringWithFormat:@"http://www.emop.cn/ShortUrlRouteNew.php/c/%@?from=app&auto_mobile=y", [self.query objectForKey:@"shortUrlKey"]];
    
    //NSString *string;
    //string = [NSString initWithFormat:@"%@,%@", "click url:", ext.webpageUrl ];
    NSLog(ext.webpageUrl);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
//    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
}

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma about fav

////////////////////////////////////////////////////////////////////////////////////////////
- (void)doFavOper
{
    
    if (![UserInfoHelper isUserBinded]) {
        
        if (self.delayJob) {
            self.delayJob = nil;
        }else{
            self.delayJob = @selector(doFavOper);
        }
        [UserInfoHelper showLoginPage:nil];
        
        return;
    }

    self.delayJob = nil;
    
    if ([UserInfoHelper topicId]) {
        self.topicId = [UserInfoHelper topicId];
        
        if (_isFav) {
            [self removeFav];
        }else{
            [self addFav];
        }
        
    }else{
        Tuji_User_Topic_List_Engine * getTopicIdEngine = [Tuji_User_Topic_List_Engine sharedInstance];
        
        [getTopicIdEngine operationForFavWithCompletionHandler:^(NSString *response, MKNetworkOperation *op) {
            
            NSDictionary * topicData = [response objectFromJSONString];
            
            if ([[topicData objectForKey:@"status"] isEqualToString:@"ok"]){
                
//                NSInteger count = [[[topicData objectForKey:@"data"] objectForKey:@"item_count"] intValue];
                
                self.topicId = [[topicData objectForKey:@"data"] objectForKey:@"topic_id"];
                
                [UserInfoHelper storeTopicId:self.topicId];
                
                if (_isFav) {
                    [self removeFav];
                }else{
                    [self addFav];
                }
                
//                if (count) {
//                    
//                    NSString * topicId = [[[[topicData objectForKey:@"data"] objectForKey:@"items"] objectAtIndex:0] objectForKey:@"id"];
//                    self.topicId = topicId;
//                    
//                    [UserInfoHelper storeTopicId:topicId];
//                    
//                    
//                    if (_isFav) {
//                        [self removeFav];
//                    }else{
//                        [self addFav];
//                    }
//                }
                
            }else{
                
            }
            
        } errorHandler:^(NSError *error) {
            
        }];
    }
}

- (void)addFav
{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    Tuji_Topic_Fav * addFavEngine = [Tuji_Topic_Fav sharedInstance];

    [addFavEngine operationForAddWithShopId:[self.query objectForKey:@"shopId"]
                                   itemText:_goodsDetailView.data.message
                                     itemId:[self.query objectForKey:@"itemId"]
                                shortUrlKey:_goodsDetailView.data.short_url_key
                                     numIId:_goodsDetailView.data.num_iid
                                    topicId:self.topicId
                                     picUrl:_goodsDetailView.data.pic_url
                          completionHandler:^(NSString *response, MKNetworkOperation *op) {
                              
                NSDictionary * addFavData = [response objectFromJSONString];
        
        if ([[addFavData objectForKey:@"status"] isEqualToString:@"ok"]) {
            
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"加入收藏成功";
            [hud hide:YES afterDelay:1.5];
            
            ToolbarButton * btn = [self favBtn];
//            [btn setHighlighted:YES];
            [btn showSelectedStatus:YES];
            
            _isFav = YES;
            
            [UserInfoHelper storeNeedRefreshFav:YES];
            
            [self.goodsDetailView updateFavCount:1];
            
        }else{
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"加入收藏失败";
            [hud hide:YES afterDelay:1.5];
        }
        
    } errorHandler:^(NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"加入收藏失败";
        [hud hide:YES afterDelay:1.5];
    }];
}

- (void)removeFav
{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    Tuji_Topic_Fav * removeFavEngine = [Tuji_Topic_Fav sharedInstance];
    
    [removeFavEngine operationForRemoveWithTopicId:self.topicId
                                            itemId:[self.query objectForKey:@"itemId"]
                                 completionHandler:^(NSString *response, MKNetworkOperation *op) {
                                     NSDictionary * removeFavData = [response objectFromJSONString];
                                     
                                     if ([[removeFavData objectForKey:@"status"] isEqualToString:@"ok"]) {
                                         
                                         hud.mode = MBProgressHUDModeText;
                                         hud.labelText = @"取消收藏成功";
                                         [hud hide:YES afterDelay:1.5];
                                         
                                         _isFav = NO;
                                         
                                         [UserInfoHelper storeNeedRefreshFav:YES];
                                         
                                         ToolbarButton * btn = [self favBtn];
//                                         [btn setHighlighted:NO];
                                         [btn showSelectedStatus:NO];
                                         
                                         [self.goodsDetailView updateFavCount:-1];
                                         
                                     }else{
                                         hud.mode = MBProgressHUDModeText;
                                         hud.labelText = @"取消收藏失败";
                                         [hud hide:YES afterDelay:1.5];
                                     }
                                     
                                 } errorHandler:^(NSError *error) {
                                     hud.mode = MBProgressHUDModeText;
                                     hud.labelText = @"取消收藏失败";
                                     [hud hide:YES afterDelay:1.5];
                                 }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 20130409 增加左右滑动翻页效果
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addGestureRecognizer
{
    if ([self.query objectForKey:@"listData"]) {
        
        curIndex = [[self.query objectForKey:@"curIndex"] intValue];
        
        UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [recognizer setNumberOfTouchesRequired:1];
        [recognizer setDelegate:self];
        
        [self.view addGestureRecognizer:recognizer];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [recognizer setNumberOfTouchesRequired:1];
        [recognizer setDelegate:self];
        
        [self.view addGestureRecognizer:recognizer];
    }
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"%@", recognizer.direction == UISwipeGestureRecognizerDirectionLeft?@"LEFT":@"RIGHT");
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self goNext];
    }else{
        [self goPrev];
    }
}

//上一页
- (void)goPrev{
    if ([self canGoPrev]) {
        
        curIndex--;
    
        [self animationToSwitchWithDirect:kCATransitionFromLeft];
    }else{
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        [hud setRemoveFromSuperViewOnHide:YES];
        hud.labelText = @"当前已经是第一页";
        [hud hide:YES afterDelay:1.5];
    }
}
//下一页
- (void)goNext{
    if ([self canGoNext]) {
        curIndex++;
        
        [self animationToSwitchWithDirect:kCATransitionFromRight];
    }else{
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        [hud setRemoveFromSuperViewOnHide:YES];
        hud.labelText = @"当前已经是最后一页";
        [hud hide:YES afterDelay:1.5];
    }
}

- (void)animationToSwitchWithDirect:(NSString *)direct
{
    GoodsVO * vo = (GoodsVO *)[[self.query objectForKey:@"listData"] objectAtIndex:curIndex];
    
    GoodsDetailView * willShowView = [[GoodsDetailView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"loading.png"] andPrice:[vo price]];
    [willShowView setFrame:self.view.bounds];
    [willShowView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    [willShowView.buyButton addTarget:self action:@selector(didClickToBuy:) forControlEvents:UIControlEventTouchUpInside];
    
    CATransition * animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = direct;
    
    [self.view addSubview:willShowView];
    [self.goodsDetailView removeFromSuperview];
    self.goodsDetailView = willShowView;
    self.delayJob = nil;
    
    [[self.view layer] addAnimation:animation forKey:@"animation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        GoodsVO * vo = (GoodsVO *)[[self.query objectForKey:@"listData"] objectAtIndex:curIndex];
        [self loadDataWithUUID:[vo uuid]];
    }
}

- (BOOL)canGoNext{
    return curIndex < [[self.query objectForKey:@"listData"] count]-1;
}

- (BOOL)canGoPrev{
    return curIndex > 0;
}

@end
