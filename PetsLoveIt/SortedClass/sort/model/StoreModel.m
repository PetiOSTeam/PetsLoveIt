//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器  http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//
#import "StoreModel.h"

@implementation StoreModel


-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
    if(json != nil)
    {
       self.mallId  = [json objectForKey:@"mallId"];
 self.isChian  = [json objectForKey:@"isChian"];
 self.order  = [json objectForKey:@"order"];
 self.mallIcon  = [json objectForKey:@"mallIcon"];
 self.nodeUid  = [json objectForKey:@"nodeUid"];
 self.name  = [json objectForKey:@"name"];
 self.state  = [json objectForKey:@"state"];
 
    }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mallId forKey:@"zx_mallId"];
[aCoder encodeObject:self.isChian forKey:@"zx_isChian"];
[aCoder encodeObject:self.order forKey:@"zx_order"];
[aCoder encodeObject:self.mallIcon forKey:@"zx_mallIcon"];
[aCoder encodeObject:self.nodeUid forKey:@"zx_nodeUid"];
[aCoder encodeObject:self.name forKey:@"zx_name"];
[aCoder encodeObject:self.state forKey:@"zx_state"];

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.mallId = [aDecoder decodeObjectForKey:@"zx_mallId"];
 self.isChian = [aDecoder decodeObjectForKey:@"zx_isChian"];
 self.order = [aDecoder decodeObjectForKey:@"zx_order"];
 self.mallIcon = [aDecoder decodeObjectForKey:@"zx_mallIcon"];
 self.nodeUid = [aDecoder decodeObjectForKey:@"zx_nodeUid"];
 self.name = [aDecoder decodeObjectForKey:@"zx_name"];
 self.state = [aDecoder decodeObjectForKey:@"zx_state"];
 
    }
    return self;
}

- (NSString *) description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"mallId : %@\n",self.mallId];
result = [result stringByAppendingFormat:@"isChian : %@\n",self.isChian];
result = [result stringByAppendingFormat:@"order : %@\n",self.order];
result = [result stringByAppendingFormat:@"mallIcon : %@\n",self.mallIcon];
result = [result stringByAppendingFormat:@"nodeUid : %@\n",self.nodeUid];
result = [result stringByAppendingFormat:@"name : %@\n",self.name];
result = [result stringByAppendingFormat:@"state : %@\n",self.state];

    return result;
}

@end
