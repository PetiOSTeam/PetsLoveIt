//
//  BindEmailViewController.m
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/30.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "BindEmailViewController.h"

@interface BindEmailViewController ()
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation BindEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"绑定邮箱";
    
    self.emailView.width = mScreenWidth-80;
    [self.emailView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    self.okBtn.layer.cornerRadius = 25;

}
- (IBAction)okAction:(id)sender {
    NSString *email = self.emailTextField.text;
    
    if ([email length] == 0) {
        mAlertView(@"提示", @"邮箱不能为空");
        return;
    }
    if (![email isValidateEmail]) {
        mAlertView(@"提示", @"邮箱格式不正确");
        return;
    }
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeNone];
    NSDictionary *params = @{
                             @"uid":@"bindUserEmail",
                             @"type":@"2",
                             @"account":email
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            LocalUserInfoModelClass *userInfo = [AppCache getUserInfo];
            userInfo.email = email;
            [AppCache cacheObject:userInfo forKey:HLocalUserInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"绑定邮箱成功"];

        }else{
            [SVProgressHUD dismiss];
            mAlertAPIErrorInfo(error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
