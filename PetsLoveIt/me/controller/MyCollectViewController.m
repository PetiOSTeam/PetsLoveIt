//
//  MyCollectViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/24.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MyCollectViewController.h"
#import "CorePagesView.h"
#import "NewsListTVC.h"
#import "CarefulSelectViewController.h"
#import "ShareOrderViewController.h"
#import "DiscountViewController.h"
#import "MassTaoViewController.h"
#import "ExperienceViewController.h"
#import "NewsViewController.h"
#import "TaoPetViewController.h"
#import "TaoPetViewController.h"

@interface MyCollectViewController ()
@property (nonatomic,strong) CorePagesView *pagesView;

@end

@implementation MyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}

- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"我的收藏";
    self.view.width = mScreenWidth;
    [self setPageViews];
}

- (void)setPageViews{
    
    NSMutableArray *pageModels = [NSMutableArray new];
    NSArray *topicArray = @[@"精选",@"优惠",@"海淘",@"淘宠",@"晒单",@"经验",@"资讯"];
    for (int i=0; i<topicArray.count; i++) {
        CoreLTVC *vc;
        if (i==0) {
            vc = [CarefulSelectViewController new];
            
        }else if (i==1){
            vc = [DiscountViewController new];
        }else if (i==2){
            vc = [MassTaoViewController new];
        }else if (i==3){
            vc = [TaoPetViewController new];
        }
        else if (i == 4) {
            vc = [ShareOrderViewController new];
        } else if (i==5){
            vc = [ExperienceViewController new];
        }else if (i==6){
            vc = [NewsViewController new];
        }
        vc.isCollect = YES;
        CorePageModel *pageModel=[CorePageModel model:vc pageBarName:topicArray[i]];
        [pageModels addObject:pageModel];
        
    }
    _pagesView=[CorePagesView viewWithOwnerVC:self pageModels:pageModels pageWidth:mScreenWidth];
    _pagesView.top = 64;
    [self.pagesView.pagesBarView setBackgroundColor:mRGBToColor(0xfeffff)];
    [self.pagesView.scrollView setBackgroundColor:mRGBToColor(0xffffff)];
    [self.view addSubview:self.pagesView];
    
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
