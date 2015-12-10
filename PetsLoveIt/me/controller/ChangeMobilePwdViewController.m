//
//  ChangeMobilePwdViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/6.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ChangeMobilePwdViewController.h"

@interface ChangeMobilePwdViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *msgCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIView *confirmPwdView;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (strong,nonatomic) NSString *token;


@end

@implementation ChangeMobilePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}

- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"修改密码";
    self.token = @"";
    self.codeView.width = self.pwdView.width =self.confirmPwdView.width =mScreenWidth-80;
    [self.codeView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.pwdView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.confirmPwdView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(self.msgCodeBtn.left -8, 0, 1, 28)];
    [line1 setBackgroundColor:mRGBToColor(0xdcdcdc)];
    line1.center = CGPointMake(line1.center.x, self.codeView.height/2) ;
    [self.codeView addSubview:line1];
    
    self.okBtn.layer.cornerRadius = 25;
    [self.scrollView setContentSize:CGSizeMake(mScreenWidth, self.okBtn.bottom + 20)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
}




- (IBAction)okAction:(id)sender {
    NSString  *code = self.codeTextField.text;
    NSString  *pwd = self.pwdTextField.text;
    NSString  *confirmPwd = self.confirmPwdTextField.text;
    
    NSString *encryptedPwd = [[_Des AES128Encrypt:[pwd appendAESKeyAndTimeStamp]] uppercaseString];
    if ([code length]==0) {
        mAlertView(@"提示", @"验证码不能为空");
        return;
    }
    if (![pwd isValidatePassword]) {
        mAlertView(@"提示", @"密码应该是6－18位的字母数字下划线组合");
        return;
    }
    if (![confirmPwd isEqualToString:pwd]) {
        mAlertView(@"提示", @"输入密码不一致");
        return;
    }
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeNone];
    NSDictionary *params = @{
                             @"uid":@"savePwdByMobile",
                             @"athcode":code,
                             @"pwd":encryptedPwd,
                             @"mobile":self.mobile,
                             @"userToken":self.token
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [mAppUtils showHint:@"修改密码成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            mAlertAPIErrorInfo(error);
        }
    }];
}

- (IBAction)msgAction:(id)sender {
    NSString  *mobile = self.mobile;
    if ([mobile isPhoneNumber]==0) {
        mAlertView(@"提示", @"请填写正确格式的手机号");
        return;
    }
    [self countdownAnimation];
    NSDictionary *params = @{
                             @"uid":@"smsathcode",
                             @"mobile":mobile
                             };
    [APIOperation GET:@"smsathcode.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            self.token = [responseData objectForKey:@"userToken"];

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

#pragma mark - Keyboard status

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    
    // Orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // User Info
    NSDictionary *info = notification.userInfo;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // Keyboard Size
    //Checks if IOS8, gets correct keyboard height
    CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.000000) ? keyboardEnd.size.height : keyboardEnd.size.width : keyboardEnd.size.height;
    // Correct Curve
    UIViewAnimationOptions animationOptions = curve << 16;
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            
            //scrollView高度
            self.scrollView.height = self.view.frame.size.height - keyboardHeight;
            
        } completion:nil];
        
    } else {
        
        //scrollView高度
        self.scrollView.height = self.view.frame.size.height ;
        
    }//end
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
