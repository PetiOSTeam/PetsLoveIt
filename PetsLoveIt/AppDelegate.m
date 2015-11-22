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
#import <TencentOpenAPI/TencentOAuth.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "MobClick.h"
#import "MeViewController.h"

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
    //[self setupNavigationStyle];
    [self setupUmengSDK];
    
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
    
    MeViewController *c3=[[MeViewController alloc]init];
    c3.tabBarItem.title=@"我的";
    c3.tabBarItem.image=[UIImage imageNamed:@"meTabIcon"];
    c3.tabBarItem.selectedImage = [UIImage imageNamed:@"meTabIcon_highlighted"];
    BaseNavigationController *navi3 = [[BaseNavigationController alloc] initWithRootViewController:c3];
    navi3.navigationBarHidden = YES;
    
    tabVC.viewControllers = @[navi1,navi2,navi3];
  
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.window makeKeyAndVisible];
    
}

- (void)setupUmengSDK{
    [self umengTrack];
    [self registerUmengShare];
}

- (void)umengTrack {
    
    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; 
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)registerUmengShare{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMENG_APPKEY];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:@"http://www.pets.com"];
    //QQ 分享
    [UMSocialQQHandler setQQWithAppId:QQSDKAppID appKey:QQAppKey url:@"http://www.pets.com"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //由于苹果审核政策需求，建议大家对未安装客户端平台进行隐藏，在设置QQ、微信AppID之后调用下面的方法
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        result = [TencentOAuth HandleOpenURL:url];
    }
    return  result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        result = [TencentOAuth HandleOpenURL:url];
    }
    return  result;
}

@end
