//
//
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器  http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//
#import "KeywordsModel.h"

@implementation KeywordsModel


-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.ishot  = [json objectForKey:@"ishot"];
            self.name  = [json objectForKey:@"name"];
            self.order  = [json objectForKey:@"order"];
            
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ishot forKey:@"zx_ishot"];
    [aCoder encodeObject:self.name forKey:@"zx_name"];
    [aCoder encodeObject:self.order forKey:@"zx_order"];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.ishot = [aDecoder decodeObjectForKey:@"zx_ishot"];
        self.name = [aDecoder decodeObjectForKey:@"zx_name"];
        self.order = [aDecoder decodeObjectForKey:@"zx_order"];
        
    }
    return self;
}

- (NSString *) description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"ishot : %@\n",self.ishot];
    result = [result stringByAppendingFormat:@"name : %@\n",self.name];
    result = [result stringByAppendingFormat:@"order : %@\n",self.order];
    
    return result;
}

@end
