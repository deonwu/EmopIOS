//
//  LoadMoreCell.m
//  zaol
//
//  Created by hark2046 on 13-2-28.
//
//

#import "LoadMoreCell.h"
#import "CommonDef.h"

const CGFloat kLoadMoreCellHeight = 60.0f;
const CGFloat kActivityIndicatorViewRadius = 24.0;

@implementation LoadMoreCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object
{
    return kLoadMoreCellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        文字
        [self.textLabel setText:NSLocalizedString(@"正在加载", @"")];
        [self.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.textLabel setTextColor:rgba(160.0f, 160.0f, 160.0f, 1)];
        [self.textLabel setTextAlignment:UITextAlignmentCenter];
        
//        滚动
        UIActivityIndicatorView * loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [loading setFrame:CGRectMake(kActivityIndicatorViewRadius, (kLoadMoreCellHeight - kActivityIndicatorViewRadius) / 2.0, kActivityIndicatorViewRadius, kActivityIndicatorViewRadius)];
        
        [self.contentView addSubview:loading];
        
        [loading startAnimating];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
