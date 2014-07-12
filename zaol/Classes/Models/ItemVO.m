//
//  Items.m
//  Generated by JSON Toolbox - http://itunes.apple.com/app/json-toolbox/id525015412
//
//  Created by hark on 2月 25, 2013
//

#import "ItemVO.h"

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@implementation ItemVO

@synthesize status, update_time, front_pic, id, view_order, topic_name, create_time, description, item_count;

+ (NSArray*) ItemsWithArray: (NSArray*) array
{
    NSMutableArray * resultsArray = [[NSMutableArray alloc] init];

    for(id entry in array)
    {
        if(![entry isKindOfClass: [NSDictionary class]]) continue;

        [resultsArray addObject: [ItemVO ItemsWithDictionary: entry]];
    }

    return JSONAutoRelease(resultsArray);
} // End of ItemsWithArray

+ (ItemVO *)ItemsWithDictionary:(NSDictionary *)dictionary
{
    ItemVO *instance = [[ItemVO alloc] initWithDictionary: dictionary];
    return JSONAutoRelease(instance);
} // End of ItemsWithDictionary

+ (ItemVO *)ItemsWithJSONString: (NSString *) jsonString usingEncoding: (NSStringEncoding) stringEncoding error: (NSError**) error
{
    NSData * jsonData = [jsonString dataUsingEncoding: stringEncoding];

    NSDictionary * jsonDictionary = [NSJSONSerialization JSONObjectWithData: jsonData
                                                                    options: 0
                                                                      error: error];

    if(nil != error && nil != jsonDictionary)
    {
        return [ItemVO ItemsWithDictionary: jsonDictionary];
    }

    return nil;
} // End of ItemsWithJSONString

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        if(nil != [dictionary objectForKey: @"status"])
            
        {
            
            self.status = [dictionary objectForKey: @"status"];
            
        }
        
        
        
        if(nil != [dictionary objectForKey: @"update_time"])
            
        {
            
            self.update_time = [dictionary objectForKey: @"update_time"];
            
        }
        
        
        
        if(nil != [dictionary objectForKey: @"front_pic"])
            
        {
            
            self.front_pic = [dictionary objectForKey: @"front_pic"];
            
        }
        
        
        
        if(nil != [dictionary objectForKey: @"id"])
            
        {
            
            self.id = [dictionary objectForKey: @"id"];
            
        }
        
        
        
        if(nil != [dictionary objectForKey: @"view_order"])
            
        {
            
            self.view_order = [NSNumber numberWithInt:[[dictionary objectForKey: @"view_order"] intValue]];
            
        }
        
        
        
        if(nil != [dictionary objectForKey: @"topic_name"])
            
        {
            
            self.topic_name = [dictionary objectForKey: @"topic_name"];
            
        }
        
        
        
        if(nil != [dictionary objectForKey: @"create_time"])
            
        {
            
            self.create_time = [dictionary objectForKey: @"create_time"];
            
        }
        
        
        
        if(nil != [dictionary objectForKey: @"description"])
            
        {
            
            self.description = [dictionary objectForKey: @"description"];
            
        }
        
        
        
        if(nil != [dictionary objectForKey: @"item_count"])
            
        {
            
            self.item_count = [dictionary objectForKey: @"item_count"];
            
        }

    }

    return self;
} // End of initWithDictionary

- (NSString*) description
{
    NSMutableString * descriptionOutput = [[NSMutableString alloc] init];
    [descriptionOutput appendFormat: @"status = \"%@\"\r\n", status];
    
    [descriptionOutput appendFormat: @"update_time = \"%@\"\r\n", update_time];
    
    [descriptionOutput appendFormat: @"front_pic = \"%@\"\r\n", front_pic];
    
    [descriptionOutput appendFormat: @"id = \"%@\"\r\n", id];
    
    [descriptionOutput appendFormat: @"view_order = \"%@\"\r\n", view_order];
    
    [descriptionOutput appendFormat: @"topic_name = \"%@\"\r\n", topic_name];
    
    [descriptionOutput appendFormat: @"create_time = \"%@\"\r\n", create_time];
    
    [descriptionOutput appendFormat: @"description = \"%@\"\r\n", description];
    
    [descriptionOutput appendFormat: @"item_count = \"%@\"\r\n", item_count];

    return JSONAutoRelease(descriptionOutput);
} // End of description

- (void)dealloc
{
#if ! __has_feature(objc_arc)
	[status release];
    
	[update_time release];
    
	[front_pic release];
    
	[id release];
    
	[view_order release];
    
	[topic_name release];
    
	[create_time release];
    
	[description release];
    
	[item_count release];

    [super dealloc];
#endif
} // End of dealloc

@end