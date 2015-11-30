//
//  BindMobileViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/30.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "BindMobileViewController.h"

@interface BindMobileViewController ()
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UIButton *msgCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@end

@implementation BindMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"绑定手机";
    
    self.accountView.width = self.codeView.width= mScreenWidth-80;
    [self.accountView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.codeView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    self.okBtn.layer.cornerRadius = 25;
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(self.msgCodeBtn.left -8, 0, 1, 28)];
    [line1 setBackgroundColor:mRGBToColor(0xdcdcdc)];
    line1.center = CGPointMake(line1.center.x, self.codeView.height/2) ;
    [self.codeView addSubview:line1];

}
- (IBAction)okAction:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString  *mobile = self.accountTextField.text;
    NSString  *code = self.codeTextField.text;

    
    if ([mobile length]==0) {
        mAlertView(@"提示", @"手机号不能为空");
        return;
    }
    if ([code length]==0) {
        mAlertView(@"提示", @"验证码不能为空");
        return;
    }
    NSDictionary *params = @{
                             @"uid":@"bindUserMobile",
                             @"account":mobile,
                             @"type":@"1",
                             @"athcode":code
                             };
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeNone];
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            LocalUserInfoModelClass *userInfo = [AppCache getUserInfo];
            userInfo.mobile = mobile;
            [AppCache cacheObject:userInfo forKey:HLocalUserInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"绑定手机成功"];
        }else{
            [SVProgressHUD dismiss];
            mAlertAPIErrorInfo(error);
        }
    }];
}

- (IBAction)msgAction:(id)sender {
    NSString  *mobile = self.accountTextField.text;
    if ([mobile length]==0) {
        mAlertView(@"提示", @"手机号不能为空");
        return;
    }
    [self countdownAnimation];
    NSDictionary *params = @{
                             @"uid":@"smsathcode",
                             @"mobile":mobile
                             };
    [APIOperation GET:@"smsathcode.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            
        }else{
            mAlertAPIErrorInfo(error);
        }
    }];
}

#pragma mark 按钮倒计时动画
-(void)countdownAnimation
{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_msgCodeBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
                _msgCodeBtn.userInteractionEnabled = YES;
                
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                NSLog(@"____%@",strTime);
                NSString *title = [NSString stringWithFormat:@"%@",strTime];
                [_msgCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",title] forState:UIControlStateNormal];
                _msgCodeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
