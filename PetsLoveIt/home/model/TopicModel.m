//
//  TopicModel.m
//  youbibuluo
//
//  Created by kongjun on 15/7/13.
//  Copyright (c) 2015年 kongjun. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel

-(void) setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]){
        self.topicId = value;
    }
    else
        [super setValue:value forKey:key];
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.topicId forKey:@"topicId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.sort_id forKey:@"sort_id"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.topicId = [decoder decodeObjectForKey:@"topicId"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.sort_id = [decoder decodeObjectForKey:@"sort_id"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setTopicId:[self.topicId copy]];
    [theCopy setName:[self.name copy]];
    [theCopy setSort_id:[self.sort_id copy]];
    
    return theCopy;
}
@end
