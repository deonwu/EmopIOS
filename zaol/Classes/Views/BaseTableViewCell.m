//
//  BaseTableViewCell.m
//  zaol
//
//  Created by li bin on 13-2-22.
//
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object
{
    return 44.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)object
{
    return nil;
}

- (void)setObject:(id)obj
{
    
}

@end
