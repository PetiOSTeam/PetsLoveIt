//
//  ArticleModel.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/8.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel
+(NSArray *)modelPrepare:(id)obj{
    
    return obj[@"data"][@"data_article_list"];
}
@end
