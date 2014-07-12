//
//  DetailVO.h
//  Generated by JSON Toolbox - http://itunes.apple.com/app/json-toolbox/id525015412
//
//  Created by hark on 3月 5, 2013
//

#import <Foundation/Foundation.h>


@interface DetailVO : NSObject
{
} // End of Data

+ (NSArray*) DataWithArray: (NSArray*) array;
+ (DetailVO *)DataWithDictionary: (NSDictionary *) dictionary;
+ (DetailVO *)DataWithJSONString: (NSString *) jsonString usingEncoding: (NSStringEncoding) stringEncoding error: (NSError**) error;
- (id)initWithDictionary: (NSDictionary *) dictionary;
- (NSString*) description;

@property(nonatomic, retain) NSString * lib_id;

@property(nonatomic, retain) NSString * volume;

@property(nonatomic, retain) NSNumber * is_fav;

@property(nonatomic, retain) NSString * fav_count;

@property(nonatomic, retain) NSString * num_iid;

@property(nonatomic, retain) NSString * pic_url;

@property(nonatomic, retain) NSString * message;

@property(nonatomic, retain) NSString * price;

@property(nonatomic, retain) NSString * short_url_key;


@end