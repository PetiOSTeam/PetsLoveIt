//
//  BaseTabBarViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "GoodsDetailViewController.h"
@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presentview:) name:@"presentview" object:nil];
    
}

- (void)presentview:(NSNotification *)notification{
    NSString *productid = notification.userInfo[productID];
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]init];
    vc.goodsId = productid;
    vc.ispresent = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
