//
//
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器  http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//
#import "GradeModel.h"

@implementation GradeModel


-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.discount  = [json objectForKey:@"discount"];
            self.remainingNum  = [json objectForKey:@"remainingNum"];
            self.state  = [json objectForKey:@"state"];
            self.discountPic  = [json objectForKey:@"discountPic"];
            self.desc  = [json objectForKey:@"desc"];
            self.receiveLimit  = [json objectForKey:@"receiveLimit"];
            self.discountId  = [json objectForKey:@"discountId"];
            self.order  = [json objectForKey:@"order"];
            self.totalNum  = [json objectForKey:@"totalNum"];
            self.integral  = [json objectForKey:@"integral"];
            self.awardCode  = [json objectForKey:@"awardCode"];
            self.effectiveDate  = [json objectForKey:@"effectiveDate"];
            self.instructions  = [json objectForKey:@"instructions"];
            self.haschanged  = [json objectForKey:@"haschanged"];
            self.name  = [json objectForKey:@"name"];
            
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.discount forKey:@"zx_discount"];
    [aCoder encodeObject:self.remainingNum forKey:@"zx_remainingNum"];
    [aCoder encodeObject:self.state forKey:@"zx_state"];
    [aCoder encodeObject:self.discountPic forKey:@"zx_discountPic"];
    [aCoder encodeObject:self.desc forKey:@"zx_desc"];
    [aCoder encodeObject:self.receiveLimit forKey:@"zx_receiveLimit"];
    [aCoder encodeObject:self.discountId forKey:@"zx_discountId"];
    [aCoder encodeObject:self.order forKey:@"zx_order"];
    [aCoder encodeObject:self.totalNum forKey:@"zx_totalNum"];
    [aCoder encodeObject:self.integral forKey:@"zx_integral"];
    [aCoder encodeObject:self.awardCode forKey:@"zx_awardCode"];
    [aCoder encodeObject:self.effectiveDate forKey:@"zx_effectiveDate"];
    [aCoder encodeObject:self.instructions forKey:@"zx_instructions"];
    [aCoder encodeObject:self.haschanged forKey:@"zx_haschanged"];
    [aCoder encodeObject:self.name forKey:@"zx_name"];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.discount = [aDecoder decodeObjectForKey:@"zx_discount"];
        self.remainingNum = [aDecoder decodeObjectForKey:@"zx_remainingNum"];
        self.state = [aDecoder decodeObjectForKey:@"zx_state"];
        self.discountPic = [aDecoder decodeObjectForKey:@"zx_discountPic"];
        self.desc = [aDecoder decodeObjectForKey:@"zx_desc"];
        self.receiveLimit = [aDecoder decodeObjectForKey:@"zx_receiveLimit"];
        self.discountId = [aDecoder decodeObjectForKey:@"zx_discountId"];
        self.order = [aDecoder decodeObjectForKey:@"zx_order"];
        self.totalNum = [aDecoder decodeObjectForKey:@"zx_totalNum"];
        self.integral = [aDecoder decodeObjectForKey:@"zx_integral"];
        self.awardCode = [aDecoder decodeObjectForKey:@"zx_awardCode"];
        self.effectiveDate = [aDecoder decodeObjectForKey:@"zx_effectiveDate"];
        self.instructions = [aDecoder decodeObjectForKey:@"zx_instructions"];
        self.haschanged = [aDecoder decodeObjectForKey:@"zx_haschanged"];
        self.name = [aDecoder decodeObjectForKey:@"zx_name"];
        
    }
    return self;
}

- (NSString *) description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"discount : %@\n",self.discount];
    result = [result stringByAppendingFormat:@"remainingNum : %@\n",self.remainingNum];
    result = [result stringByAppendingFormat:@"state : %@\n",self.state];
    result = [result stringByAppendingFormat:@"discountPic : %@\n",self.discountPic];
    result = [result stringByAppendingFormat:@"desc : %@\n",self.desc];
    result = [result stringByAppendingFormat:@"receiveLimit : %@\n",self.receiveLimit];
    result = [result stringByAppendingFormat:@"discountId : %@\n",self.discountId];
    result = [result stringByAppendingFormat:@"order : %@\n",self.order];
    result = [result stringByAppendingFormat:@"totalNum : %@\n",self.totalNum];
    result = [result stringByAppendingFormat:@"integral : %@\n",self.integral];
    result = [result stringByAppendingFormat:@"awardCode : %@\n",self.awardCode];
    result = [result stringByAppendingFormat:@"effectiveDate : %@\n",self.effectiveDate];
    result = [result stringByAppendingFormat:@"instructions : %@\n",self.instructions];
    result = [result stringByAppendingFormat:@"haschanged : %@\n",self.haschanged];
    result = [result stringByAppendingFormat:@"name : %@\n",self.name];
    
    return result;
}

@end
