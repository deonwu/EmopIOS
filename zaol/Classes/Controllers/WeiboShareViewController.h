//
//  WeiboShareViewController.h
//  zaol
//
//  Created by hark2046 on 13-3-8.
//
//

#import "BaseTableViewController.h"
#import "SinaWeibo.h"

@interface WeiboShareViewController : BaseTableViewController<UITableViewDataSource, UITableViewDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,UITextViewDelegate>

@end
