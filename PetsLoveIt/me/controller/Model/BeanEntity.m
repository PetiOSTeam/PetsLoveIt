//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器  http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//
#import "BeanEntity.h"

@implementation BeanEntity


-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
    if(json != nil)
    {
       self.changeIntegral  = [json objectForKey:@"changeIntegral"];
 self.discountId  = [json objectForKey:@"discountId"];
 
    }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.changeIntegral forKey:@"zx_changeIntegral"];
[aCoder encodeObject:self.discountId forKey:@"zx_discountId"];

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.changeIntegral = [aDecoder decodeObjectForKey:@"zx_changeIntegral"];
 self.discountId = [aDecoder decodeObjectForKey:@"zx_discountId"];
 
    }
    return self;
}

- (NSString *) description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"changeIntegral : %@\n",self.changeIntegral];
result = [result stringByAppendingFormat:@"discountId : %@\n",self.discountId];

    return result;
}

@end
