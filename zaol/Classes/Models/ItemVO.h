//
//  Items.h
//  Generated by JSON Toolbox - http://itunes.apple.com/app/json-toolbox/id525015412
//
//  Created by hark on 2月 25, 2013
//

#import <Foundation/Foundation.h>


@interface ItemVO : NSObject
{
} // End of Items

+ (NSArray*) ItemsWithArray: (NSArray*) array;
+ (ItemVO *)ItemsWithDictionary: (NSDictionary *) dictionary;
+ (ItemVO *)ItemsWithJSONString: (NSString *) jsonString usingEncoding: (NSStringEncoding) stringEncoding error: (NSError**) error;
- (id)initWithDictionary: (NSDictionary *) dictionary;
- (NSString*) description;

@property(nonatomic, retain) NSString * status;

@property(nonatomic, retain) NSString * update_time;

@property(nonatomic, retain) NSString * front_pic;

@property(nonatomic, retain) NSString * id;

@property(nonatomic, retain) NSNumber * view_order;

@property(nonatomic, retain) NSString * topic_name;

@property(nonatomic, retain) NSString * create_time;

@property(nonatomic, retain) NSString * description;

@property(nonatomic, retain) NSString * item_count;

@end
