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
#import "ShareOrderViewController.h"
#import "DiscountViewController.h"
#import "MassTaoViewController.h"
#import "ExperienceViewController.h"
#import "NewsViewController.h"
#import "TaoPetViewController.h"
#import "TaoPetViewController.h"
#import "ShakeViewController.h"
#import "SearchViewController.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"

@interface HomePageViewController ()
@property (nonatomic,strong) CorePagesView *pagesView;
@property (nonatomic,strong) UIView *headerView;
@property (strong, nonatomic)  UILabel *navBarTitleLabel;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadViewsAndData];
}


- (void)loadViewsAndData{
    [self.view addSubview:self.headerView];
    [self setupNaviButton];
    [self setPageViews];
}

-(void)setupNaviButton{
    UIButton *shakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shakeButton.frame = CGRectMake(10, 30, 64, 34);
    [shakeButton setImage:[UIImage imageNamed:@"shakeIcon"] forState:UIControlStateNormal];
    [shakeButton addTarget:self action:@selector(showShakeVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(mScreenWidth-64-10, 30, 64, 34);
    [searchButton setImage:[UIImage imageNamed:@"searchGoodsIcon"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(showSearchVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView addSubview:shakeButton];
    [self.headerView addSubview:searchButton];
}



- (void)showShakeVC{
    
    ShakeViewController *vc = [ShakeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showSearchVC{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView.userInteractionEnabled = YES;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 64)];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        _navBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, mScreenWidth, 44)];
        [_navBarTitleLabel setText:@"宠物爱这个"];
        [_navBarTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [_navBarTitleLabel setFont:[UIFont systemFontOfSize:18]];
        [_navBarTitleLabel setTextColor:kNaviTitleColor];
        [_headerView addSubview:_navBarTitleLabel];
        
    }
    return _headerView;
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
        else{
            vc = [NewsListTVC new];
        }
        CorePageModel *pageModel=[CorePageModel model:vc pageBarName:topicArray[i]];
        [pageModels addObject:pageModel];
        
    }
    _pagesView=[CorePagesView viewWithOwnerVC:self pageModels:pageModels];
    _pagesView.top = 64;
    [self.pagesView.pagesBarView setBackgroundColor:mRGBToColor(0xfeffff)];
    [self.pagesView.scrollView setBackgroundColor:mRGBToColor(0xffffff)];
    [self.view addSubview:self.pagesView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
