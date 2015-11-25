//
//  CoreLTVC.h
//  CoreLTVC
//
//  Created by 沐汐 on 15-3-9.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//  封装列表




#import <UIKit/UIKit.h>
#import "CoreListVC.h"


@interface CoreLTVC : CoreListVC<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL isCollect;//是否为收藏页面
@property (nonatomic,assign) BOOL isMyArticle;//是否为我的投稿
/**
 *  tableView
 */
@property (nonatomic,weak) UITableView *tableView;


@end
