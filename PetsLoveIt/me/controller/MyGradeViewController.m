//
//  MyGradeViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/24.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MyGradeViewController.h"
#import "MyGradeListView.h"
#import "MyHistoryGradeViewController.h"

@interface MyGradeViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

@property (nonatomic, strong) MyGradeListView *gradeListView;

@end

@implementation MyGradeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}

- (void)prepareViewAndData
{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"我的积分";
    [self gradeListView];
}

- (IBAction)historyAction:(id)sender
{
    MyHistoryGradeViewController *myHistoryVC = [[MyHistoryGradeViewController alloc] init];
    [self.navigationController pushViewController:myHistoryVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - *** getter ***

- (MyGradeListView *)gradeListView
{
    if (!_gradeListView) {
        _gradeListView = [[MyGradeListView alloc] initWithFrame:CGRectMake(0,
                                                                           CGRectGetMaxY(self.headerView.frame),
                                                                           self.view.width,
                                                                           self.view.height - CGRectGetMaxY(self.headerView.frame))
                                                      withStyle:GradeStyleNew];
        _gradeListView.navigation = self.navigationController;
        [self.view addSubview:_gradeListView];
        _gradeListView.translatesAutoresizingMaskIntoConstraints = NO;
        [_gradeListView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headerView];
        [_gradeListView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_gradeListView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_gradeListView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    }
    return _gradeListView;
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
