//
//  selectGoodModel.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/8.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel
+(NSArray *)modelPrepare:(id)obj{
    
    if (obj[@"beans"][@"beans"]) {
        return obj[@"beans"][@"beans"];
    }else
    {
        return obj[@"data"];
    }

}
- (NSString *)popularitystr
{
    if (!_popularitystr) {
        _popularitystr = [self productpopularityWithobject:self];
    }
    
    return _popularitystr;
}
- (NSString *)commentNum
{
//    _commentNum = @"2000";
    _commentNum = [self stringAbidebytherules:_commentNum];
    return _commentNum;
}
- (NSString *)collectnum
{
//    _collectnum = @"2000";
    _collectnum = [self stringAbidebytherules:_collectnum];
    return _collectnum;
}
- (NSString *)stringAbidebytherules:(NSString *)str
{
    float num = [str floatValue];
    if (num > 10000){
        return [NSString stringWithFormat:@"%.1fw",(num/10000)];
    }else
    {
        return [NSString stringWithFormat:@"%.0f",num];
    }
}
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"commentNum":@"commentnum",
             @"favorNum":@"praisenum",
             @"hostID":@"prodId"
             };
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"commentnum"]){
        self.commentNum = value;
    }
    else if ([key isEqualToString:@"praisenum"]){
        self.favorNum = value;
    }
    else
        [super setValue:value forKey:key];

}

#pragma mark 显示用户对产品点的是赞还是踩

// 计算产品的受喜爱度
- (NSString *)productpopularityWithobject:(GoodsModel *)good
{
    float zancount = [good.favorNum floatValue];
    if (good.favorNum == nil) {
        zancount = 0;
    }


    float caicount = [good.notworthnum floatValue];
    if (good.notworthnum == nil) {
        caicount = 0;
    }
    float popularityF = zancount/(caicount+zancount)*100;
    if (zancount == 0) {
        popularityF =0;
    }

    return [[NSString alloc]initWithFormat:@"%.0f%@",popularityF,@"%" ];

}
@end
