//  BaseNavigationControllerViewController.m
//  TeamWork
//
//  Created by kongjun on 14-6-20.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Life cycle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setNaviBarAttrs];
    
}

- (void)setNaviBarAttrs{
    //设置title
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           kNaviTitleColor, NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];
    //The tint color to apply to the navigation items and bar button items.
    [[UINavigationBar appearance] setTintColor:kNaviTitleColor];
    
    if (mIos7) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"image_navi_bg_iOS7_or_greater"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"image_navi_bg"] forBarMetrics:UIBarMetricsDefault];
    }
    
    if ([[UINavigationBar class] instancesRespondToSelector:@selector(setBackIndicatorImage:)]) {
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"Image_backIndicator"]];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
    // 添加返回
    if ([self.viewControllers count] > 1){
        if (viewController.navigationItem.leftBarButtonItem == nil){
            
            UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            leftBtn.width = 35;
            leftBtn.height = 40;
            [leftBtn setImage:[UIImage imageNamed:@"backBarButtonIcon"] forState:UIControlStateNormal];
            [leftBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
            UIBarButtonItem *leftSpacer        =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                          target:nil action:nil];
            leftSpacer.width = -8;
            viewController.navigationItem.leftBarButtonItems = @[leftSpacer, leftBarButtonItem];
        }
    }
}

- (void)popViewController
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - View rotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
