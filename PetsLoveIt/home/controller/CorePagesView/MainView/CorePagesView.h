//
//  CoreTabsView.h
//  CoreTabsVC
//
//  Created by junfrost on 15/3/19.
//  Copyright (c) 2015年 junfrost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePageModel.h"
#import "CorePagesBarView.h"

@interface CorePagesView : UIView
@property (nonatomic,assign) BOOL useAutoResizeWidth;//自动计算顶部按钮宽度
@property (nonatomic,assign) BOOL homePageWidth;//首页显示6个btn

@property (strong, nonatomic) IBOutlet CorePagesBarView *pagesBarView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

/**
 *  分页模型数组
 */
@property (nonatomic,strong) NSArray *pageModels;

@property (nonatomic,weak) id currentVC;//当前选中的vc

/**
 *  快速实例化对象
 *
 *  @param ownerVC    本视图所属的控制器
 *  @param pageModels 模型数组
 *
 *  @return 实例
 */
+(instancetype)viewWithOwnerVC:(UIViewController *)ownerVC pageModels:(NSArray *)pageModels;

+(instancetype)viewWithOwnerVC:(UIViewController *)ownerVC pageModels:(NSArray *)pageModels pageWidth:(CGFloat)width  isHomePage:(BOOL) isHomePage;

+(instancetype)viewWithOwnerVC:(UIViewController *)ownerVC pageModels:(NSArray *)pageModels useAutoResizeWidth:(BOOL) useAutoResizeWidth;

+(instancetype)viewWithOwnerVC:(UIViewController *)ownerVC pageModels:(NSArray *)pageModels isHomePage:(BOOL) isHomePage;


@end
