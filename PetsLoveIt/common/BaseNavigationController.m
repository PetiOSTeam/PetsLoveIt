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
        [[UINavigationBar appearance] setBackgroundColor:mRGBColor(202, 0, 11)];
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
