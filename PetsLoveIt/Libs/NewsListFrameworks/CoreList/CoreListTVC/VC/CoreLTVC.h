//
//  CoreLTVC.h
//  CoreLTVC
//
//  Created by 沐汐 on 15-3-9.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//  封装列表




#import <UIKit/UIKit.h>
#import "CoreListVC.h"

@protocol MyCollectDelegate <NSObject>

@optional
- (void) selectAllCollect:(BOOL)allSelect;

@end

@interface CoreLTVC : CoreListVC<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *seletedArray;
@property (nonatomic,assign) BOOL showSelect;

@property (nonatomic,assign) BOOL isCollect;//是否为收藏页面
@property (nonatomic,assign) BOOL isMyArticle;//是否为我的投稿
@property (nonatomic,weak) id<MyCollectDelegate> delegate;

- (void) showSelectView:(BOOL)show;
- (void) selectAllData:(BOOL)select;


/**
 *  tableView
 */
@property (nonatomic,weak) UITableView *tableView;


@end
