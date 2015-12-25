//
//  MyHistoryGradeViewController.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/6.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MyHistoryGradeViewController.h"
#import "MyGradeListView.h"
#import "UIView+MJExtension.h"
@interface MyHistoryGradeViewController ()

@property (nonatomic, strong) MyGradeListView *gradeListView;
@property (nonatomic , weak) UIView *view2;
@end

@implementation MyHistoryGradeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isFlog) {
        
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.isFlog) {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
-(void)showNaviBarView{
    
    if (!self.navigationBarView) {
        self.navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 64)];
        
        self.navigationBarView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.height-1, mScreenWidth, 1)];
        [line setBackgroundColor:mRGBToColor(0xdcdcdc)];
        [self.navigationBarView addSubview:line];
        
        UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonBack.frame = CGRectMake(0, 30, 44, 34);
        buttonBack.center = CGPointMake(buttonBack.center.x, 42);
        [buttonBack setImage:[UIImage imageNamed:@"backBarButtonIcon"] forState:UIControlStateNormal];
        [buttonBack addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBarView addSubview:buttonBack];
        
        self.navBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, mScreenWidth-60, 24)];
        self.navBarTitleLabel.center = CGPointMake(self.navBarTitleLabel.center.x, 42);
        
        [self.navBarTitleLabel setTextColor:kNaviTitleColor];
        [self.navBarTitleLabel setFont:[UIFont systemFontOfSize:18]];
        [self.navBarTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.navigationBarView addSubview:self.navBarTitleLabel];
    }
    
    [self.view addSubview:self.navigationBarView];
}
- (void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.mj_width, self.view.mj_height-64)];
    [self.view addSubview:view2];
    self.view2 = view2;
    [self gradeListView];
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"兑换记录";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - *** getter ***

- (MyGradeListView *)gradeListView
{
    if (!_gradeListView) {
        
        _gradeListView = [[MyGradeListView alloc] initWithFrame:self.view2.bounds
                                                      withStyle:GradeStyleHistory];
//        _gradeListView.mj_y = 64;
        _gradeListView.navigation = self.navigationController;
        [self.view2 addSubview:_gradeListView];
        _gradeListView.translatesAutoresizingMaskIntoConstraints = NO;
        [_gradeListView autoPinEdgesToSuperviewEdges];
    }
    return _gradeListView;
}


@end
