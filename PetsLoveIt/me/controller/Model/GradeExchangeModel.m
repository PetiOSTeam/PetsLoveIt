//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器  http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//
#import "GradeExchangeModel.h"

@implementation GradeExchangeModel


-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
    if(json != nil)
    {
       self.rtnCode  = [json objectForKey:@"rtnCode"];
 self.rtnMsg  = [json objectForKey:@"rtnMsg"];
 self.bean  = [[BeanEntity alloc] initWithJson:[json objectForKey:@"bean"]];
 self.userToken  = [json objectForKey:@"userToken"];
 
    }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.rtnCode forKey:@"zx_rtnCode"];
[aCoder encodeObject:self.rtnMsg forKey:@"zx_rtnMsg"];
[aCoder encodeObject:self.bean forKey:@"zx_bean"];
[aCoder encodeObject:self.userToken forKey:@"zx_userToken"];

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.rtnCode = [aDecoder decodeObjectForKey:@"zx_rtnCode"];
 self.rtnMsg = [aDecoder decodeObjectForKey:@"zx_rtnMsg"];
 self.bean = [aDecoder decodeObjectForKey:@"zx_bean"];
 self.userToken = [aDecoder decodeObjectForKey:@"zx_userToken"];
 
    }
    return self;
}

- (NSString *) description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"rtnCode : %@\n",self.rtnCode];
result = [result stringByAppendingFormat:@"rtnMsg : %@\n",self.rtnMsg];
result = [result stringByAppendingFormat:@"bean : %@\n",self.bean];
result = [result stringByAppendingFormat:@"userToken : %@\n",self.userToken];

    return result;
}

@end
