//
//  TopicDetailViewController.m
//  zaol
//
//  Created by hark2046 on 13-2-28.
//
//

#import "TopicDetailViewController.h"

#import "Tuji_Topic_Convert_Item_Click_Url_Engine.h"

#import "CommonDef.h"

#import "GoodsVO.h"

#import "JSONKit.h"

#import "TopicView.h"

#import "KATAPageControl.h"

#import "GoodsDetailViewController.h"

@interface TopicDetailViewController ()

@property (nonatomic, strong) AQGridView *gridView;
@property (strong,nonatomic) NSMutableArray * datas;
@property (strong, nonatomic) KATAPageControl * pageControl;

@property (strong, nonatomic) UIImageView * loadingView;

- (void)showLoading;

- (void)showEmpty;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TopicDetailViewController

- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)query
{
    self = [super initWithURL:aUrl query:query];
    
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (id)initWithURL:(NSURL *)aUrl
{
    self = [super initWithURL:aUrl];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = [[self query] objectForKey:@"title"];
    
    [self.view setBackgroundColor:rgba(230, 230, 230, 1)];

//    初始化gridView
//    self.gridView = [[KKGridView alloc] initWithFrame:self.view.bounds];
    self.gridView = [[AQGridView alloc] initWithFrame:self.view.bounds];
    
    [_gridView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    [_gridView setDataSource:self];
    [_gridView setDelegate:self];
    [_gridView setPagingEnabled:YES];
    [_gridView setUsesPagedHorizontalScrolling:YES];
    [_gridView setShowsHorizontalScrollIndicator:NO];
    [_gridView setShowsVerticalScrollIndicator:NO];
    [_gridView setBackgroundColor:rgba(230, 230, 230, 1)];
    
    [_gridView setLayoutDirection:AQGridViewLayoutDirectionHorizontal];
    
    
    [self.view addSubview:_gridView];
    
    self.datas = [NSMutableArray arrayWithCapacity:16];
    
    self.pageControl = [[KATAPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 30.0f, CGRectGetWidth(self.view.bounds), 30.0f)];
    [_pageControl setImagePageStateNormal:[UIImage imageNamed:@"normalDot.png"]];
    [_pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"selectedDot.png"]];
    [_pageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [_pageControl setNumberOfPages:0];
    
    [self.view addSubview:_pageControl];
    
    
    [self showLoading];
//    加载数据
    Tuji_Topic_Convert_Item_Click_Url_Engine * engine = [Tuji_Topic_Convert_Item_Click_Url_Engine sharedInstance];
    
    [engine operationWithPage:0 pageSize:0 topic:[[self query] objectForKey:@"topic_id"]  completionHandler:^(NSString *response, MKNetworkOperation *op) {
        
        NSDictionary * goods = [response objectFromJSONString];
        
        if ([[goods objectForKey:@"status"] isEqualToString:@"ok"]) {
            

            NSArray * items = [GoodsVO ItemsWithArray:[[goods objectForKey:@"data"] objectForKey:@"items"]];
            
            [self.datas addObjectsFromArray:items];
            
            if ([items count] == 0) {
                [self showEmpty];
                return;
            }
            
            [_pageControl setNumberOfPages:ceil([self.datas count] / 4.0)];
            [_pageControl setCurrentPage:0];
            
            [self.loadingView removeFromSuperview];
            
            [self.gridView reloadData];
        }
        
    } errorHandler:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showEmpty
{
    UIImageView * emptyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_items.png"]];
    
    [emptyView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.loadingView.frame), CGRectGetHeight(self.loadingView.frame) - 50)];
    [emptyView setContentMode:UIViewContentModeCenter];
    [self.loadingView setBackgroundColor:rgba(245, 245, 245, 1)];
    [emptyView setBackgroundColor:rgba(245, 245, 245, 1)];
    
    [self.loadingView addSubview:emptyView];
}


- (void)showLoading
{
    if (!_loadingView) {
//        NSString * title = NSLocalizedString(@"正在加载", @"");
//        
//        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_gridView.frame), CGRectGetHeight(_gridView.frame))];
//        [label setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
//        [label setTextAlignment:UITextAlignmentCenter];
//        [label setText:title];
//        [label setTextColor:rgba(96, 103, 111, 1)];
//        [label setBackgroundColor:[_gridView backgroundColor]];
//        
//        [self.view addSubview:label];
        
        UIImageView * loading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_gridView.frame), CGRectGetHeight(_gridView.frame))];
        [loading setImage:[UIImage imageNamed:@"loading.png"]];
        [loading setContentMode:UIViewContentModeCenter];
        [loading setBackgroundColor:rgba(250, 250, 250, 1)];
        
        [self.view addSubview:loading];
        
        self.loadingView = loading;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma gridview datasource && gridview delegate

//////////////////////////////////////////////////////////////////////////////////////////////////
- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView
{
//    为保持完整的4个商品一页的布局，抛弃掉部分数据
    return ceil([self.datas count] / 4.0);
}

//////////////////////////////////////////////////////////////////////////////////////////////////
- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString * const topicViewCellID = @"TopicViewCell";
    TopicView * cell = (TopicView *)[gridView dequeueReusableCellWithIdentifier:topicViewCellID];
    
    if (!cell) {
        cell = [[TopicView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) reuseIdentifier:topicViewCellID];
        
        cell.topicViewDelegate = self;
    }
    
    NSUInteger start = index * 4;
    NSUInteger end = start + 3;
    
    [cell setLayout:index%4];
    
    [cell setGoodsData1:[self.datas objectAtIndex:start]];
    
    if (end < [self.datas count]) {
        [cell setGoodsData2:[self.datas objectAtIndex:(start+1)]];
        [cell setGoodsData3:[self.datas objectAtIndex:(start+2)]];
        [cell setGoodsData4:[self.datas objectAtIndex:(start+3)]];
    }else{
        
        if (start+1 < [self.datas count]) {
            
            [cell setGoodsData2:[self.datas objectAtIndex:(start+1)]];
        }
        
        if (start+2 < [self.datas count]) {
            
            [cell setGoodsData3:[self.datas objectAtIndex:(start+2)]];
        }

        if (start+3 < [self.datas count]) {
            
            [cell setGoodsData3:[self.datas objectAtIndex:(start+3)]];
        }

    }



    [cell setSelectionStyle:AQGridViewCellSelectionStyleNone];

    return cell;
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView
{
    return CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)gridView:(AQGridView *)gridView didDisplayCell:(AQGridViewCell *)cell forItemAtIndex:(NSUInteger)index
{
    [self.pageControl setCurrentPage:index];
}


//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didTopicItemClicked:(TopicViewItem *)item withData:(GoodsVO *)data
{
    
    GoodsVO * vo = (GoodsVO *)data;
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"宝贝详情页" forKey:@"title"];
    [params setObject:[vo id] forKey:@"goodsId"];
    [params setObject:[vo item_id] forKey:@"itemId"];
    [params setObject:[vo rect_rate] forKey:@"rect_rate"];
    [params setObject:[vo shop_id] forKey:@"shopId"];
    [params setObject:[vo pic_url] forKey:@"picUrl"];
    [params setObject:[vo short_url_key] forKey:@"shortUrlKey"];
    [params setObject:[vo price] forKey:@"price"];
    
    [params setObject:[self datas] forKey:@"listData"];
    [params setObject:[NSNumber numberWithInt:[self.datas indexOfObject:data]] forKey:@"curIndex"];
    
    [params setObject:[item.imageView image] forKey:@"pic"];
    
    [params setObject:[vo uuid] forKey:@"uuid"];
    
    GoodsDetailViewController * goodsVC = [[GoodsDetailViewController alloc] initWithURL:[NSURL URLWithString:@"tdh://goodsDetail"] query:params];
    
    [goodsVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:goodsVC animated:YES];
}

@end
