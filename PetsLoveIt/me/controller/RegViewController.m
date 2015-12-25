//
//  RegViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/22.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "RegViewController.h"
#import <CoreText/CoreText.h>
#import "AwardRulesViewController.h"
#import "MeViewController.h"

@interface RegViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UIButton *msgCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UITextField *nickTextField;

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *nickNameView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;
@property (weak, nonatomic) IBOutlet UIButton *regWithEmailBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong,nonatomic) NSString *token;
@property (assign,nonatomic) BOOL mobileExist;

@end

@implementation RegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}

- (void)prepareViewAndData{
    [self showNaviBarView];
    if (self.isOtherLogin) {
        self.navBarTitleLabel.text = @"完善个人信息";
        [self.regBtn setTitle:@"确定" forState:UIControlStateNormal];
    }else{
        self.navBarTitleLabel.text = @"手机号注册";
    }
    self.token = @"";
    self.accountView.width = self.pwdView.width =self.codeView.width=self.nickNameView.width = mScreenWidth-80;
    [self.accountView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.codeView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.nickNameView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.pwdView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(self.msgCodeBtn.left -8, 0, 1, 28)];
    [line1 setBackgroundColor:mRGBToColor(0xdcdcdc)];
    line1.center = CGPointMake(line1.center.x, self.codeView.height/2) ;
    [self.codeView addSubview:line1];
    
    self.regBtn.layer.cornerRadius = 25;
    [self.scrollView setContentSize:CGSizeMake(mScreenWidth, self.tipLabel.bottom + 10)];
    
    [self createTextViewInputAccessoryView];
    
    self.tipLabel1.frame = CGRectMake(0, mScreenHeight-35, mScreenWidth/2, 14);
    self.tipLabel.frame = CGRectMake(self.tipLabel1.right +3, mScreenHeight-35, mScreenWidth/2, 14);

    NSString *agreeString = @"宠物爱这个协议";
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:agreeString];
    [attriString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                        value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                        range:NSMakeRange(0, [agreeString length])];
    self.tipLabel.attributedText = attriString;
    self.tipLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureOnAgree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAgreeVC)];
    [self.tipLabel addGestureRecognizer:tapGestureOnAgree];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)showAgreeVC{
    AwardRulesViewController *vc = [AwardRulesViewController new];
    vc.navTitle = @"用户协议";
    NSString *agreeStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"agree" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    vc.desc = agreeStr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createTextViewInputAccessoryView
{
    //键盘
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 35)];
    keyboardDoneButtonView.backgroundColor = mRGBColor(240, 240, 240);
    keyboardDoneButtonView.barStyle = UIBarButtonItemStylePlain;
    keyboardDoneButtonView.translucent = NO;
    keyboardDoneButtonView.tintColor = mRGBToColor(0xff4401);
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(resignTextViewFirstResponse)];
    
    [doneButton setImage:[UIImage imageNamed:@"Image_keyboardToolIcon"]];
    //[doneButton setTitle:@"完成"];
    
    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
    
    self.accountTextField.inputAccessoryView = keyboardDoneButtonView;
    self.codeTextField.inputAccessoryView = keyboardDoneButtonView;
    self.nickTextField.inputAccessoryView = keyboardDoneButtonView;
    self.pwdTextField.inputAccessoryView = keyboardDoneButtonView;

}

-(void)resignTextViewFirstResponse{
    [self.view endEditing:YES];
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

- (IBAction)msgAction:(id)sender {
    NSString  *mobile = self.accountTextField.text;
    if ([mobile length]==0) {
        mAlertView(@"提示", @"手机号不能为空");
        return;
    }
    [self countdownAnimation];
    //第三方登录的完善信息
    if (self.isOtherLogin) {
        [self mobileExist:mobile];
    }else{
        [self sendSMSCode:mobile];
    }
    
    
}

- (void) mobileExist:(NSString *)mobile{
    NSDictionary *params = @{
                             @"uid":@"mobileExists",
                             @"mobile":mobile
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        int rtnCode = [[responseData objectForKey:@"rtnCode"] intValue];
        if (rtnCode == 1) {
            //手机号已经注册过
            self.pwdView.hidden = YES;
            self.nickNameView.hidden = YES;
            self.mobileExist = YES;
        }else if(rtnCode == 0){
            self.pwdView.hidden = NO;
            self.nickNameView.hidden = NO;
            self.mobileExist = NO;
        }
        [self sendSMSCode:mobile];
    }];
}
- (void) sendSMSCode:(NSString *)mobile{
    if ([mobile isPhoneNumber]==0) {
        mAlertView(@"提示", @"请填写正确格式的手机号");
        return;
    }
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

- (IBAction)showPwdAction:(id)sender {
    UIButton *button = sender;
    button.selected = !button.selected;
    BOOL selected = button.selected;
    if (selected) {
        self.pwdTextField.secureTextEntry = NO;
    }else{
        self.pwdTextField.secureTextEntry = YES;
    }
}
- (IBAction)regAction:(id)sender {
    [self.view endEditing:YES];
    
    NSString  *mobile = self.accountTextField.text;
    NSString  *code = self.codeTextField.text;
    NSString  *nickName = self.nickTextField.text;
    NSString  *pwd = self.pwdTextField.text;
    NSString *encryptedPwd = [[_Des AES128Encrypt:[pwd appendAESKeyAndTimeStamp]] uppercaseString];
    
    if ([self.token length] ==0) {
        mAlertView(@"提示", @"您还没有点击发送验证码");
        return;
    }
    if ([mobile length]==0) {
        mAlertView(@"提示", @"手机号不能为空");
        return;
    }
    if (!self.mobileExist) {
        if ([code length]==0) {
            mAlertView(@"提示", @"验证码不能为空");
            return;
        }
        if (![nickName isValidateName]) {
            mAlertView(@"提示", @"昵称应该是1-12位数字字母下划线汉字的组合");
            return;
            
        }
        if (![pwd isValidatePassword]&&!self.mobileExist) {
            mAlertView(@"提示", @"密码应该是6－18位的字母数字下划线组合");
            return;
        }

    }
       //userToken=userToken_f94d719172d44810b401962948bafa79&otheraccount=&othertype=&athcode=&account=15921438852
   // &type=1&userName=testr1&nickName=testRegist1&userPwd=1EE996B5BDFBFBED595B5AAB355BE1A8A73B023B670114F
   // 20A7A870281046F385333405B765CE98E876D5C69455E1D6E
    NSDictionary *params = @{
                             @"uid":@"userRegist",
                             @"type":@"1",
                             @"account":mobile,
                             @"athcode":code,
                             @"userName":nickName,
                             @"nickName":nickName,
                             @"userPwd":encryptedPwd,
                             @"userToken":self.token
                             };

    if (self.isOtherLogin) {
        params = @{
                   @"uid":@"userRegist",
                   @"type":@"1",
                   @"account":mobile,
                   @"athcode":code,
                   @"nickName":nickName,
                   @"userPwd":encryptedPwd,
                   @"userToken":self.token,
                   @"othertype":self.otherType,
                   @"otheraccount":self.otherAccount
                   };
        
        if (self.mobileExist) {
            params = @{
                       @"uid":@"userRegist",
                       @"type":@"1",
                       @"account":mobile,
                       @"athcode":code,
                       @"userToken":self.token,
                       @"othertype":self.otherType,
                       @"otheraccount":self.otherAccount
                       };
        }
        

    }
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeClear];
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];

            NSLog(@"%@",responseData);
            [mAppUtils showHint:[responseData objectForKey:@"rtnMsg"]];
            if (self.isOtherLogin) {
                //用绑定帐号的接口自动登录
                [self bindUserAccount];
            }else{
                [mUserDefaults setObject:self.accountTextField.text forKey:HLoginAccount];
                [mUserDefaults synchronize];
                //登录接口
                LocalUserInfoModelClass *userInfo = [LocalUserInfoModelClass new];
                userInfo.loginType = @"1";
                userInfo.accountName = mobile;
                userInfo.password = encryptedPwd;
                [self loginByAccount:userInfo];
            }
            
        }else{
            [SVProgressHUD dismiss];

            mAlertAPIErrorInfo(error);
//            MeViewController *me = [[MeViewController alloc]init];
//            [self pushNewViewController:me];
        }
    }];
    
    
}

- (void)loginByAccount:(LocalUserInfoModelClass *)userInfo{
    NSDictionary *params = @{
                             @"uid":@"login",
                             @"type":userInfo.loginType,
                             @"userName":userInfo.accountName,
                             @"userPwd":userInfo.password
                             };
    [APIOperation GET:@"userLogin.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        [SVProgressHUD dismiss];

        if (!error) {
            NSMutableDictionary *userDict = [responseData objectForKey:@"bean"];
            LocalUserInfoModelClass *localUserInfo = [[LocalUserInfoModelClass alloc] initWithDictionary:userDict];
            localUserInfo.userToken = [responseData objectForKey:@"userToken"];
            localUserInfo.loginType = userInfo.loginType;
            localUserInfo.accountName = userInfo.accountName;
            localUserInfo.password = userInfo.password;
            //将userinfo记录下来
            mAppDelegate.loginUser = localUserInfo;
            [AppCache cacheObject:localUserInfo forKey:HLocalUserInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];

            
        }
    }];
}

- (void)bindUserAccount{
    [SVProgressHUD showWithStatus:@"请稍后" maskType:SVProgressHUDMaskTypeClear];
    NSDictionary *params = @{
                             @"uid":@"isBindOtherUser",
                             @"othertype":self.otherType,
                             @"otheraccount":self.otherAccount,
                             @"userToken":self.token
                             };
    [APIOperation GET:@"isBindUser.action"  parameters:params onCompletion:^(id responseData, NSError *error) {
        [SVProgressHUD dismiss];
        [mAppUtils hideHint];
        if (!error) {
            //绑定过三方帐号，直接登录
            NSMutableDictionary *userDict = [responseData objectForKey:@"bean"];
            LocalUserInfoModelClass *localUserInfo = [[LocalUserInfoModelClass alloc] initWithDictionary:userDict];
            localUserInfo.userToken = [responseData objectForKey:@"userToken"];
            localUserInfo.otherType = self.otherType;
            localUserInfo.otherAccount = self.otherAccount;
            //将userinfo记录下来
            mAppDelegate.loginUser = localUserInfo;
            [AppCache cacheObject:localUserInfo forKey:HLocalUserInfo];
            
            [mUserDefaults setObject:_accountTextField.text forKey:HLoginAccount];
            [mUserDefaults synchronize];
            
            //登录成功
            [mAppUtils showHint:@"登录成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            mAlertAPIErrorInfo(error);
        }
    }];
}



- (IBAction)regEmailAction:(id)sender {
    
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
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
