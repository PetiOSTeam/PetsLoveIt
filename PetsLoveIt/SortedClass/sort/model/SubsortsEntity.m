//
//
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器  http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//
#import "SubsortsEntity.h"

@implementation SubsortsEntity


-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.sortIcon  = [json objectForKey:@"sortIcon"];
            self.sortId  = [json objectForKey:@"sortId"];
            self.order  = [json objectForKey:@"order"];
            self.name  = [json objectForKey:@"name"];
            self.sort  = [json objectForKey:@"sort"];
            
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.sortIcon forKey:@"zx_sortIcon"];
    [aCoder encodeObject:self.sortId forKey:@"zx_sortId"];
    [aCoder encodeObject:self.order forKey:@"zx_order"];
    [aCoder encodeObject:self.name forKey:@"zx_name"];
    [aCoder encodeObject:self.sort forKey:@"zx_sort"];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.sortIcon = [aDecoder decodeObjectForKey:@"zx_sortIcon"];
        self.sortId = [aDecoder decodeObjectForKey:@"zx_sortId"];
        self.order = [aDecoder decodeObjectForKey:@"zx_order"];
        self.name = [aDecoder decodeObjectForKey:@"zx_name"];
        self.sort = [aDecoder decodeObjectForKey:@"zx_sort"];
        
    }
    return self;
}

- (NSString *) description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"sortIcon : %@\n",self.sortIcon];
    result = [result stringByAppendingFormat:@"sortId : %@\n",self.sortId];
    result = [result stringByAppendingFormat:@"order : %@\n",self.order];
    result = [result stringByAppendingFormat:@"name : %@\n",self.name];
    result = [result stringByAppendingFormat:@"sort : %@\n",self.sort];
    
    return result;
}

@end
