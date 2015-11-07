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

@property (strong, nonatomic) IBOutlet CorePagesBarView *pagesBarView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

/**
 *  分页模型数组
 */
@property (nonatomic,strong) NSArray *pageModels;


/**
 *  快速实例化对象
 *
 *  @param ownerVC    本视图所属的控制器
 *  @param pageModels 模型数组
 *
 *  @return 实例
 */
+(instancetype)viewWithOwnerVC:(UIViewController *)ownerVC pageModels:(NSArray *)pageModels;






@end
