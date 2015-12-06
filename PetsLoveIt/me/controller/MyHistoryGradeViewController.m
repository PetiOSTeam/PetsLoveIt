//
//  MyHistoryGradeViewController.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/6.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MyHistoryGradeViewController.h"
#import "MyGradeListView.h"

@interface MyHistoryGradeViewController ()

@property (nonatomic, strong) MyGradeListView *gradeListView;

@end

@implementation MyHistoryGradeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换记录";
    [self gradeListView];
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
        _gradeListView = [[MyGradeListView alloc] initWithFrame:self.view.bounds
                                                      withStyle:GradeStyleHistory];
        _gradeListView.navigation = self.navigationController;
        [self.view addSubview:_gradeListView];
        _gradeListView.translatesAutoresizingMaskIntoConstraints = NO;
        [_gradeListView autoPinEdgesToSuperviewEdges];
    }
    return _gradeListView;
}


@end
