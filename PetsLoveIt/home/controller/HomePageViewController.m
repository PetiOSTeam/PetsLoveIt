//
//  HomePageViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/6.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "HomePageViewController.h"
#import "CorePagesView.h"
#import "NewsListTVC.h"
#import "CarefulSelectViewController.h"
#import "DiscountViewController.h"
#import "MassTaoViewController.h"
#import "ExperienceViewController.h"
#import "NewsViewController.h"

@interface HomePageViewController ()
@property (nonatomic,strong) CorePagesView *pagesView;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadViewsAndData];
}

- (void)loadViewsAndData{
    self.title = @"宠物爱这个";
    [self setPageViews];
}


- (void)setPageViews{
    
    NSMutableArray *pageModels = [NSMutableArray new];
    NSArray *topicArray = @[@"精选",@"优惠",@"海淘",@"淘宠",@"晒单",@"经验",@"资讯"];
    for (int i=0; i<topicArray.count; i++) {
        id vc ;
        if (i==0) {
            vc = [CarefulSelectViewController new];
            
        }else if (i==1){
            vc = [DiscountViewController new];
        }else if (i==2){
            vc = [MassTaoViewController new];
        }else if (i==5){
            vc = [ExperienceViewController new];
        }else if (i==6){
            vc = [NewsViewController new];
        }
        else{
            vc = [NewsListTVC new];
        }
        CorePageModel *pageModel=[CorePageModel model:vc pageBarName:topicArray[i]];
        [pageModels addObject:pageModel];
        
    }
    _pagesView=[CorePagesView viewWithOwnerVC:self pageModels:pageModels];
    [self.pagesView.pagesBarView setBackgroundColor:mRGBToColor(0xfeffff)];
    [self.pagesView.scrollView setBackgroundColor:mRGBToColor(0xffffff)];
    [self.view addSubview:self.pagesView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
