//
//
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器  http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//
#import "ProductModel.h"

@implementation ProductModel


-(id)initWithJson:(NSDictionary *)json;
{
//    NSLog(@"json😄😄55%@",json);
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.province  = [json objectForKey:@"province"];
            self.appType  = [json objectForKey:@"appType"];
            self.usercollectnum  = [json objectForKey:@"usercollectnum"];
            self.appMall  = [json objectForKey:@"appMall"];
            self.mallName  = [json objectForKey:@"mallName"];
            self.isLimitedTime  = [json objectForKey:@"isLimitedTime"];
            self.cheapPeriods  = [json objectForKey:@"cheapPeriods"];
            self.city  = [json objectForKey:@"city"];
            self.dateTime  = [json objectForKey:@"dateTime"];
            self.appPic  = [json objectForKey:@"appPic"];
            self.name  = [json objectForKey:@"name"];
            self.prodId  = [json objectForKey:@"prodId"];
            self.state  = [json objectForKey:@"state"];
            self.isTop  = [json objectForKey:@"isTop"];
            self.praisenum  = [json objectForKey:@"praisenum"];
            self.commentnum  = [json objectForKey:@"commentnum"];
            self.prodDetail  = [json objectForKey:@"prodDetail"];
            self.appSort  = [json objectForKey:@"appSort"];
            self.isShake  = [json objectForKey:@"isShake"];
            self.area  = [json objectForKey:@"area"];
            self.isGoods  = [json objectForKey:@"isGoods"];
            self.nodeUid  = [json objectForKey:@"nodeUid"];
            self.desc  = [json objectForKey:@"desc"];
            self.order  = [json objectForKey:@"order"];
            self.appMinpic  = [json objectForKey:@"appMinpic"];
            self.price  = [json objectForKey:@"price"];
            self.collectnum  = [json objectForKey:@"collectnum"];
            self.typeName = [json objectForKey:@"typeName"];
            self.notworthnum = [json objectForKey:@"notworthnum"];
            
        }
    }
    return self;
}
- (NSString *)popularitystr
{
    if (!_popularitystr) {
        _popularitystr = [self productpopularityWithobject:self];
    }
    
    return _popularitystr;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.province forKey:@"zx_province"];
    [aCoder encodeObject:self.appType forKey:@"zx_appType"];
    [aCoder encodeObject:self.usercollectnum forKey:@"zx_usercollectnum"];
    [aCoder encodeObject:self.appMall forKey:@"zx_appMall"];
    [aCoder encodeObject:self.mallName forKey:@"zx_mallName"];
    [aCoder encodeObject:self.isLimitedTime forKey:@"zx_isLimitedTime"];
    [aCoder encodeObject:self.cheapPeriods forKey:@"zx_cheapPeriods"];
    [aCoder encodeObject:self.city forKey:@"zx_city"];
    [aCoder encodeObject:self.dateTime forKey:@"zx_dateTime"];
    [aCoder encodeObject:self.appPic forKey:@"zx_appPic"];
    [aCoder encodeObject:self.name forKey:@"zx_name"];
    [aCoder encodeObject:self.prodId forKey:@"zx_prodId"];
    [aCoder encodeObject:self.state forKey:@"zx_state"];
    [aCoder encodeObject:self.isTop forKey:@"zx_isTop"];
    [aCoder encodeObject:self.praisenum forKey:@"zx_praisenum"];
    [aCoder encodeObject:self.commentnum forKey:@"zx_commentnum"];
    [aCoder encodeObject:self.prodDetail forKey:@"zx_prodDetail"];
    [aCoder encodeObject:self.appSort forKey:@"zx_appSort"];
    [aCoder encodeObject:self.isShake forKey:@"zx_isShake"];
    [aCoder encodeObject:self.area forKey:@"zx_area"];
    [aCoder encodeObject:self.isGoods forKey:@"zx_isGoods"];
    [aCoder encodeObject:self.nodeUid forKey:@"zx_nodeUid"];
    [aCoder encodeObject:self.desc forKey:@"zx_desc"];
    [aCoder encodeObject:self.order forKey:@"zx_order"];
    [aCoder encodeObject:self.appMinpic forKey:@"zx_appMinpic"];
    [aCoder encodeObject:self.price forKey:@"zx_price"];
    [aCoder encodeObject:self.collectnum forKey:@"zx_collectnum"];
    [aCoder encodeObject:self.typeName forKey:@"zx_typeName"];
    [aCoder encodeObject:self.notworthnum forKey:@"notworthnum"];
    

    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.province = [aDecoder decodeObjectForKey:@"zx_province"];
        self.appType = [aDecoder decodeObjectForKey:@"zx_appType"];
        self.usercollectnum = [aDecoder decodeObjectForKey:@"zx_usercollectnum"];
        self.appMall = [aDecoder decodeObjectForKey:@"zx_appMall"];
        self.mallName = [aDecoder decodeObjectForKey:@"zx_mallName"];
        self.isLimitedTime = [aDecoder decodeObjectForKey:@"zx_isLimitedTime"];
        self.cheapPeriods = [aDecoder decodeObjectForKey:@"zx_cheapPeriods"];
        self.city = [aDecoder decodeObjectForKey:@"zx_city"];
        self.dateTime = [aDecoder decodeObjectForKey:@"zx_dateTime"];
        self.appPic = [aDecoder decodeObjectForKey:@"zx_appPic"];
        self.name = [aDecoder decodeObjectForKey:@"zx_name"];
        self.prodId = [aDecoder decodeObjectForKey:@"zx_prodId"];
        self.state = [aDecoder decodeObjectForKey:@"zx_state"];
        self.isTop = [aDecoder decodeObjectForKey:@"zx_isTop"];
        self.praisenum = [aDecoder decodeObjectForKey:@"zx_praisenum"];
        self.commentnum = [aDecoder decodeObjectForKey:@"zx_commentnum"];
        self.prodDetail = [aDecoder decodeObjectForKey:@"zx_prodDetail"];
        self.appSort = [aDecoder decodeObjectForKey:@"zx_appSort"];
        self.isShake = [aDecoder decodeObjectForKey:@"zx_isShake"];
        self.area = [aDecoder decodeObjectForKey:@"zx_area"];
        self.isGoods = [aDecoder decodeObjectForKey:@"zx_isGoods"];
        self.nodeUid = [aDecoder decodeObjectForKey:@"zx_nodeUid"];
        self.desc = [aDecoder decodeObjectForKey:@"zx_desc"];
        self.order = [aDecoder decodeObjectForKey:@"zx_order"];
        self.appMinpic = [aDecoder decodeObjectForKey:@"zx_appMinpic"];
        self.price = [aDecoder decodeObjectForKey:@"zx_price"];
        self.collectnum = [aDecoder decodeObjectForKey:@"zx_collectnum"];
        self.typeName = [aDecoder decodeObjectForKey:@"zx_typeName"];
        self.notworthnum = [aDecoder decodeObjectForKey:@"zx_notworthnum"];
    }
    return self;
}

- (NSString *) description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"province : %@\n",self.province];
    result = [result stringByAppendingFormat:@"appType : %@\n",self.appType];
    result = [result stringByAppendingFormat:@"usercollectnum : %@\n",self.usercollectnum];
    result = [result stringByAppendingFormat:@"appMall : %@\n",self.appMall];
    result = [result stringByAppendingFormat:@"mallName : %@\n",self.mallName];
    result = [result stringByAppendingFormat:@"isLimitedTime : %@\n",self.isLimitedTime];
    result = [result stringByAppendingFormat:@"cheapPeriods : %@\n",self.cheapPeriods];
    result = [result stringByAppendingFormat:@"city : %@\n",self.city];
    result = [result stringByAppendingFormat:@"dateTime : %@\n",self.dateTime];
    result = [result stringByAppendingFormat:@"appPic : %@\n",self.appPic];
    result = [result stringByAppendingFormat:@"name : %@\n",self.name];
    result = [result stringByAppendingFormat:@"prodId : %@\n",self.prodId];
    result = [result stringByAppendingFormat:@"state : %@\n",self.state];
    result = [result stringByAppendingFormat:@"isTop : %@\n",self.isTop];
    result = [result stringByAppendingFormat:@"praisenum : %@\n",self.praisenum];
    result = [result stringByAppendingFormat:@"commentnum : %@\n",self.commentnum];
    result = [result stringByAppendingFormat:@"prodDetail : %@\n",self.prodDetail];
    result = [result stringByAppendingFormat:@"appSort : %@\n",self.appSort];
    result = [result stringByAppendingFormat:@"isShake : %@\n",self.isShake];
    result = [result stringByAppendingFormat:@"area : %@\n",self.area];
    result = [result stringByAppendingFormat:@"isGoods : %@\n",self.isGoods];
    result = [result stringByAppendingFormat:@"nodeUid : %@\n",self.nodeUid];
    result = [result stringByAppendingFormat:@"desc : %@\n",self.desc];
    result = [result stringByAppendingFormat:@"order : %@\n",self.order];
    result = [result stringByAppendingFormat:@"appMinpic : %@\n",self.appMinpic];
    result = [result stringByAppendingFormat:@"price : %@\n",self.price];
    result = [result stringByAppendingFormat:@"collectnum : %@\n",self.collectnum];
    result = [result stringByAppendingFormat:@"typeName : %@\n",self.typeName];
    result = [result stringByAppendingFormat:@"notworthnum : %@\n",self.notworthnum];
    return result;
}
// 计算产品的受喜爱度
- (NSString *)productpopularityWithobject:(ProductModel *)productmodel
{
    float zancount = [productmodel.praisenum floatValue];
    if (productmodel.praisenum == nil) {
        zancount = 0;
    }
    
    
    float caicount = [productmodel.notworthnum floatValue];
    if (productmodel.notworthnum == nil) {
        caicount = 0;
    }
    float popularityF = zancount/(caicount+zancount)*100;
    if (zancount == 0) {
        popularityF =0;
    }
    if (popularityF == 0) {
        return @"0";
    }
    return [[NSString alloc]initWithFormat:@"%.0f%@",popularityF,@"%" ];
    
}
@end
