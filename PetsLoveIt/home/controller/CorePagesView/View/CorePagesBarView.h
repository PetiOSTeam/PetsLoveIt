//
//  TabsBarView.h
//  CoreTabsVC
//
//  Created by junfrost on 15/3/19.
//  Copyright (c) 2015年 junfrost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePagesBarBtn.h"

@interface CorePagesBarView : UIScrollView



@property (nonatomic,assign) BOOL useAutoResizeWidth;//自动计算顶部按钮宽度
/**
 *  分页模型数组
 */
@property (nonatomic,strong) NSArray *pageModels;



/**
 *  页码
 */
@property (nonatomic,assign) NSUInteger page;




/**
 *  btn操作block
 */
@property (nonatomic,copy) void (^btnActionBlock)(CorePagesBarBtn *btn,NSUInteger selectedIndex);



@end
