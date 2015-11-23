//
//  MoreViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/23.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *appIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UIView *gradeView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreementLabel;


@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}

- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"更多";

    self.appIconImageView.center = CGPointMake(mScreenWidth/2, _appIconImageView.center.y);
    self.appNameLabel.center = CGPointMake(mScreenWidth/2, _appNameLabel.center.y);
    self.logoutBtn.layer.cornerRadius = 25;
    self.gradeView.layer.borderColor = kLayerBorderColor.CGColor;
    self.gradeView.layer.borderWidth = kLayerBorderWidth;
    self.gradeView.userInteractionEnabled = YES;
    
    if (![AppCache getUserInfo]) {
        self.logoutBtn.hidden = YES;
    }else{
        self.logoutBtn.hidden = NO;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGrade)];
    [self.gradeView addGestureRecognizer:tapGesture];
}

- (void) showGrade{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iVersioniOSAppStoreURLFormat]];
}
- (IBAction)logoutAction:(id)sender {
    
    [mAppUtils appLogoutAction];
    [self.navigationController popViewControllerAnimated:YES];
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
