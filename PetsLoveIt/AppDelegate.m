//
//  AppDelegate.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/4.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarViewController.h"
#import "HomePageViewController.h"
#import "BaseNavigationController.h"
#import "SortViewController.h"
#import "MLTransition.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)setupNavigationStyle
{
    UIApplication *application = [UIApplication sharedApplication];
    [[UINavigationBar appearance] setBackgroundImage:[AppUtils imageFromColor:[UIColor whiteColor]]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];  //定制返回按钮的颜色
//    [application setStatusBarHidden:NO];  //tabbar不隐藏
    
    [[UINavigationBar appearance] setShadowImage:[AppUtils imageFromColor:kLineColor]];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];  //tabbar线条
    
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self loadMainViews];
    [self setupNavigationStyle];
    
    return YES;
}

- (void)loadMainViews{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //左滑手势开启
    [MLTransition validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
    
    BaseTabBarViewController *tabVC = [BaseTabBarViewController new];
    [[UITabBar appearance] setTintColor:mRGBToColor(0xfa6532)];//字体选中的颜色
    tabVC.tabBar.selectedImageTintColor = mRGBToColor(0xfc441f);//icon选中后的颜色
    [tabVC.tabBar setBackgroundImage:[UIImage imageNamed:@"statusBarBgImage"]];
    self.window.rootViewController = tabVC;
    
    
    HomePageViewController *c1=[[HomePageViewController alloc]init];
    c1.view.backgroundColor=[UIColor whiteColor];
    c1.tabBarItem.title=@"首页";
    c1.tabBarItem.image=[UIImage imageNamed:@"homeIndexIcon"];
    c1.tabBarItem.selectedImage = [UIImage imageNamed:@"homeIndexIcon_highlighted"];
    BaseNavigationController *navi1 = [[BaseNavigationController alloc] initWithRootViewController:c1];
    [navi1.navigationBar setHidden:YES];
    
    
    SortViewController *c2=[[SortViewController alloc]init];
    c2.tabBarItem.title=@"分类";
    c2.tabBarItem.image=[UIImage imageNamed:@"sortTabIcon"];
    c2.tabBarItem.selectedImage = [UIImage imageNamed:@"sortTabIcon_highlighted"];
    BaseNavigationController *navi2 = [[BaseNavigationController alloc] initWithRootViewController:c2];
    
    UIViewController *c3=[[UIViewController alloc]init];
    c3.view.backgroundColor=[UIColor whiteColor];
    c3.tabBarItem.title=@"我的";
    c3.tabBarItem.image=[UIImage imageNamed:@"meTabIcon"];
    c3.tabBarItem.selectedImage = [UIImage imageNamed:@"meTabIcon_highlighted"];
    
    tabVC.viewControllers = @[navi1,navi2,c3];
  
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.window makeKeyAndVisible];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
