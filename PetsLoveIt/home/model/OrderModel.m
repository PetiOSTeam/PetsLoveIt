//
//  OrderModel.m
//  PetsLoveIt
//
//  Created by Joon on 15/11/8.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+ (NSArray *)modelPrepare:(id)obj {
    return obj[@"data"][@"data_article_list"];
}
- (NSString *)popularitystr
{
    if (!_popularitystr) {
        _popularitystr = [self productpopularityWithobject:self];
    }
    
    return _popularitystr;
}
// 计算产品的受喜爱度
- (NSString *)productpopularityWithobject:(OrderModel *)good
{
    float zancount = [good.likeNum floatValue];
    if (good.likeNum == nil) {
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
    if (popularityF == 0) {
        return @"0";
    }
    return [[NSString alloc]initWithFormat:@"%.0f%@",popularityF,@"%" ];
    
}
@end
