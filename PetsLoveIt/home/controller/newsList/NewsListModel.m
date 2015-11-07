//
//  NewsListModel.m
//  CorePagesView
//
//  Created by junfrost on 15/5/26.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NewsListModel.h"

@implementation NewsListModel

+(NSArray *)modelPrepare:(id)obj{

    return obj[@"data"][@"data_article_list"];
}

@end
