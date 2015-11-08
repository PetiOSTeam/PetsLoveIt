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

@end
