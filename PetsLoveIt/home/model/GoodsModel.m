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
    
    return obj[@"beans"][@"beans"];
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
@end
