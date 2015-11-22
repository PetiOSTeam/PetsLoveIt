//
//  LoginViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/22.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "LoginViewController.h"
#import "RegViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareViewAndData];
}

- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"登录";

    self.accountView.width = self.pwdView.width = mScreenWidth-80;
    [self.accountView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.pwdView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(self.forgotBtn.left - 3, 0, 1, 28)];
    [line1 setBackgroundColor:mRGBToColor(0xdcdcdc)];
    line1.center = CGPointMake(line1.center.x, self.pwdView.height/2) ;
    [self.pwdView addSubview:line1];
    
    
    self.tipLabel.center = CGPointMake(mScreenWidth/2, _tipLabel.center.y);
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(self.tipLabel.left - 58 , 10, 58, 1)];
    [line2 setBackgroundColor:mRGBToColor(0x999999)];

    [self.opView addSubview:line2];

    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(self.tipLabel.right , 10, 58, 1)];
    [line3 setBackgroundColor:mRGBToColor(0x999999)];

    [self.opView addSubview:line3];
    
    self.loginBtn.layer.cornerRadius = 25;
    self.wxBtn.top = self.tipLabel.bottom + 8;
    self.wxBtn.center = CGPointMake(mScreenWidth/2, _weiboBtn.center.y);
    self.weiboBtn.right = self.wxBtn.left;
    self.qqBtn.left = self.wxBtn.right;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.accountTextField isFirstResponder] || [self.pwdTextField isFirstResponder]) {
        [self.view endEditing:YES];
    }
}

- (IBAction)forgotAction:(id)sender {
}
- (IBAction)loginAction:(id)sender {
}
- (IBAction)regAction:(id)sender {
    RegViewController *vc = [RegViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)weiboAction:(id)sender {
}
- (IBAction)wxAction:(id)sender {
}
- (IBAction)qqAction:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
