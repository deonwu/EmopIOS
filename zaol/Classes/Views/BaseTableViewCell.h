//
//  BaseTableViewCell.h
//  zaol
//
//  Created by li bin on 13-2-22.
//
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property (strong, nonatomic) id object;

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object;

@end
