//
//  GradeDetailViewController.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/6.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "GradeDetailViewController.h"
#import "GradeDetailHeaderView.h"
#import "MBProgressHUD+Add.h"
#import "GradePopView.h"
#import "PetsLoveIt-swift.h"
#import "MyHistoryGradeViewController.h"
#import "UserSettingVC.h"

@interface GradeDetailViewController ()

@property (nonatomic, assign) BOOL isPushOldExchange;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *totalPagesLabel;

@property (weak, nonatomic) IBOutlet UILabel *residuePagesLabel;

@property (strong, nonatomic) GradeDetailHeaderView *headerView;

@end

@implementation GradeDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.isPushOldExchange) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    self.isPushOldExchange = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.isPushOldExchange) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的积分";
    [self.webView loadHTMLString:self.gradeModel.instructions baseURL:nil];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.headerView.height, 0, 0, 0);
    [self.webView.scrollView addSubview:self.headerView];
    
    [self.headerView.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.gradeModel.discountPic]
                          placeholderImage:[UIImage imageNamed:@"timeline_image_loading"]];
    
    self.headerView.titleLabel.text = self.gradeModel.name;
    
    [self.headerView.titleLabel sizeToFit];
    
    NSDictionary *headerAttributes = @{NSForegroundColorAttributeName: mRGBToColor(0xF52E0A),
                                 NSFontAttributeName: [UIFont systemFontOfSize:16]};
    NSString *str = [NSString stringWithFormat:@"%@ 积分", self.gradeModel.discount];
    NSMutableAttributedString *headerAttributedStr = [[NSMutableAttributedString alloc] initWithString:str
                                                                                      attributes:headerAttributes];
    NSRange range = NSMakeRange(str.length - 2, 2);
    NSDictionary *attributes1 = @{NSForegroundColorAttributeName: mRGBToColor(0x9E9E9E),
                                  NSFontAttributeName: [UIFont systemFontOfSize:12]};
    [headerAttributedStr addAttributes:attributes1 range:range];
    self.headerView.timeLabel.attributedText  = headerAttributedStr;
    
    [self.bottomView addTopBorderWithColor:kLineColor andWidth:.5];
    
    NSString *totalStr = [NSString stringWithFormat:@"总计：%@ 张", self.gradeModel.totalNum];
    NSDictionary *defaultDict = @{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                  NSForegroundColorAttributeName: mRGBToColor(0x9E9E9E)};
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: mRGBToColor(0xF52E0A),
                                 NSFontAttributeName: [UIFont systemFontOfSize:16]};

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr
                                                                                      attributes:defaultDict];
    NSRange  totalRange = NSMakeRange(3, self.gradeModel.totalNum.length);
    [attributedStr addAttributes:attributes range:totalRange];
    self.totalPagesLabel.attributedText = attributedStr;
    
    NSString *residueStr = [NSString stringWithFormat:@"剩余：%@ 张", self.gradeModel.remainingNum];
    NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc] initWithString:residueStr
                                                                                      attributes:defaultDict];
    NSRange  totalRange1 = NSMakeRange(3, self.gradeModel.remainingNum.length);
    [attributedStr1 addAttributes:attributes range:totalRange1];
    self.residuePagesLabel.attributedText = attributedStr1;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exchangeAction:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"兑换中...";
    NSDictionary *parameter = @{@"uid": @"saveUserChangeIntegral",
                                @"userdiscountId":self.gradeModel.discountId
                                };
    WEAKSELF
    [APIOperation GET:@"common.action"
           parameters:parameter
         onCompletion:^(id responseData, NSError *error) {
             [hud hide:YES];
             if (responseData) {
                 [weakSelf exchangeSucceessfulWithJsonDict:responseData];
             }else {
                 [MBProgressHUD showError:@"兑换失败，请重试" toView:weakSelf.view];
             }
         }];
}

- (void)exchangeSucceessfulWithJsonDict:(NSDictionary *)resp
{
    GradeExchangeModel *model = [[GradeExchangeModel alloc] initWithJson:resp];
    GradePopView *popView = [[NSBundle mainBundle] loadNibNamed:@"GradePopView"
                                                          owner:self
                                                        options:nil][0];
    popView.model = model;
    WEAKSELF
    XRZAlertControl *alertControl = [[XRZAlertControl alloc] initWithContentView:popView];
    alertControl.touchDismiss = YES;
    [alertControl show];
    
    popView.cellbackAction = ^(NSInteger index){
        [alertControl dismiss];
        if (index == 0) {
            weakSelf.isPushOldExchange = YES;
            MyHistoryGradeViewController *historyVC = [[MyHistoryGradeViewController alloc] init];
            historyVC.isFlog = YES;
            [weakSelf.navigationController pushViewController:historyVC animated:YES];
        }else {
            UserSettingVC *userSetVC = [[UserSettingVC alloc] initWithNibName:@"UserSettingVC" bundle:nil];
            [weakSelf.navigationController pushViewController:userSetVC animated:YES];
        }
    };
}

#pragma mark - *** getter ***

- (GradeDetailHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"GradeDetailHeaderView"
                                                    owner:self
                                                  options:nil][0];
        _headerView.width = self.view.width;
        _headerView.height = 125;
        _headerView.top = -125;
        _headerView.width = mScreenWidth;
        [_headerView addBottomBorderWithColor:kLineColor andWidth:.5];
    }
    return _headerView;
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
