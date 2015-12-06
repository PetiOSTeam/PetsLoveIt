//
//  ForgotPwdViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/6.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ForgotPwdViewController.h"
#import "ChangeMobilePwdViewController.h"

@interface ForgotPwdViewController ()
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation ForgotPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}
- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"找回密码";
    
    self.accountView.width = mScreenWidth-80;
    [self.accountView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    self.okBtn.layer.cornerRadius = 25;

}

- (IBAction)okAction:(id)sender {
   
    NSString *mobile =self.accountTextField.text ;
    if ([mobile length]==0) {
        mAlertView(@"提示", @"手机号不能为空");
        return;
    }
    ChangeMobilePwdViewController *vc = [ChangeMobilePwdViewController new];
    vc.mobile = mobile;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
