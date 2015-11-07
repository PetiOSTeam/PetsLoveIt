//
//  CommonViewController.h
//  TeamWork
//
//  Created by kongjun on 14-6-16.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TWBarButtonItemActionBlock)(void);

typedef NS_ENUM(NSInteger, TWBarbuttonItemStyle) {
    TWBarbuttonItemStyleNone,
    TWBarButtonItemStylePublish,
    TWBarbuttonItemStyleSendMsg,
    TWBarButtonItemStyleRecommendUser,
    TWBarbuttonItemStyleSearchUser,
    TWBarbuttonItemStyleAllRead,
    TWBarButtonItemStyleSubmit,
    TWBarbuttonItemStyleSearch,
    TWBarbuttonItemStyleShare
};

@interface CommonViewController : UIViewController

@property (nonatomic, assign) BOOL isOpenPopView;

/**
 *  统一设置背景图片
 *
 *  @param backgroundImage 目标背景图片
 */
- (void)setupBackgroundImage:(UIImage *)backgroundImage;

/**
 *  push新的控制器到导航控制器
 *
 *  @param newViewController 目标新的控制器对象
 */
- (void)pushNewViewController:(UIViewController *)newViewController;

//单个的BarbuttonItem
- (void)configureBarbuttonItemStyle:(TWBarbuttonItemStyle)style action:(TWBarButtonItemActionBlock)action;
//两个BarbuttonItem
- (void)configureBarbuttonItemStyle:(TWBarbuttonItemStyle)style action1:(TWBarButtonItemActionBlock)action1 action2:(TWBarButtonItemActionBlock)action2;
//三个BarbuttonItem
- (void)configureBarbuttonItemStyle:(TWBarbuttonItemStyle)style action1:(TWBarButtonItemActionBlock)action1 action2:(TWBarButtonItemActionBlock)action2 action3:(TWBarButtonItemActionBlock)action3;

//滑动或tap进入了当前页面
- (void)viewDidEnterCurrentView;
//适配当前view的高度
- (void)viewHeightThatFits:(CGFloat)height;
//对首页的四个VC做单独处理
- (void) TWViewWillAppear:(BOOL)animated;
- (void) TWViewWillDisappear:(BOOL)animated;
- (void) TWViewDidAppear:(BOOL)animated;

- (void)backButtonClicked:(id)sender;
@end
