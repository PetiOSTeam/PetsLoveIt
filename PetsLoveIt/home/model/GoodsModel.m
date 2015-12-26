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
//- (void)userlikedproductonYESorNO
//{
//    
//    NSMutableDictionary *paremssec =[NSMutableDictionary new];
//    if ([AppCache getToken]) {
//        [paremssec setObject:[AppCache getToken] forKey:@"userToken"];
//    }
//    [paremssec setObject:@"getUserPraiseAndNoPraiseNum" forKey:@"uid"];
//    [paremssec setObject:self.prodId forKey:@"prodId"];
//    [APIOperation GET:@"common.action" parameters:paremssec onCompletion:^(id responseData, NSError *error) {
//        if (!error) {
//            NSLog(@"%@1231289312    %@******%@",responseData,self.prodId,[AppCache getToken]);
//            NSDictionary *bean = [responseData objectForKey:@"bean"];
//            
//            if ([bean count]) {
//                //                bean =     {
//                //                    nopraisenum = 1;
//                //                    praisenum = 0;
//                //                    prodId = 151224015;
//                //                    userId = 107;
//                //                };
//                int praisenum = [bean[@"praisenum"]intValue];
//                int nopraisenum = [bean[@"nopraisenum"]intValue];
//                if (praisenum > nopraisenum) {
//                    _isLiked = ISliked;
//                    
//                }else{
//                    _isLiked = NOliked;
//                }
//                
//                
//                
//            }else{
//                _isLiked = NOclick;
//            }
//            
//        }
//    }];
//}

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
