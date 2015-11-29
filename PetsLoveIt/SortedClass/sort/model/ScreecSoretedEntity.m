//
//
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器  http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//
#import "ScreecSoretedEntity.h"

@implementation ScreecSoretedEntity


-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.beans = [NSMutableArray array];
            for(NSDictionary *item in [json objectForKey:@"beans"])
            {
                [self.beans addObject:[[BeansEntity alloc] initWithJson:item]];
            }
            self.rtnCode  = [json objectForKey:@"rtnCode"];
            self.rtnMsg  = [json objectForKey:@"rtnMsg"];
            self.userToken  = [json objectForKey:@"userToken"];
            
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.beans forKey:@"zx_beans"];
    [aCoder encodeObject:self.rtnCode forKey:@"zx_rtnCode"];
    [aCoder encodeObject:self.rtnMsg forKey:@"zx_rtnMsg"];
    [aCoder encodeObject:self.userToken forKey:@"zx_userToken"];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.beans = [aDecoder decodeObjectForKey:@"zx_beans"];
        self.rtnCode = [aDecoder decodeObjectForKey:@"zx_rtnCode"];
        self.rtnMsg = [aDecoder decodeObjectForKey:@"zx_rtnMsg"];
        self.userToken = [aDecoder decodeObjectForKey:@"zx_userToken"];
        
    }
    return self;
}

- (NSString *) description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"beans : %@\n",self.beans];
    result = [result stringByAppendingFormat:@"rtnCode : %@\n",self.rtnCode];
    result = [result stringByAppendingFormat:@"rtnMsg : %@\n",self.rtnMsg];
    result = [result stringByAppendingFormat:@"userToken : %@\n",self.userToken];
    
    return result;
}

@end
