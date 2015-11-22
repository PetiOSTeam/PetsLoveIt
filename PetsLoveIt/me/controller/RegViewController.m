//
//  RegViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/22.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "RegViewController.h"

@interface RegViewController ()

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

@end

@implementation RegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}

- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"手机号注册";
    
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
    self.tipLabel.top = mScreenHeight-25;
    [self.scrollView setContentSize:CGSizeMake(mScreenWidth, self.tipLabel.bottom + 10)];
    
    [self createTextViewInputAccessoryView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
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
    NSString *encryptedPwd = [_Des AES128Encrypt:pwd];
    //encryptedPwd = @"VtuUXet2AyaNHqdohWCn4g==";
    NSLog(@"%@",encryptedPwd);
    //return;
    if ([mobile length]==0) {
        mAlertView(@"提示", @"手机号不能为空");
        return;
    }
    if ([code length]==0) {
        mAlertView(@"提示", @"验证码不能为空");
        return;
    }
    if (![nickName isValidateName]) {
        mAlertView(@"提示", @"昵称应该是数字字母下划线汉字的组合");
        return;

    }
    if (![pwd isValidatePassword]) {
        mAlertView(@"提示", @"密码应该是6－18位的字母数字下划线组合");
        return;
    }
    
    
    NSDictionary *params = @{
                             @"uid":@"userRegist",
                             @"type":@"1",
                             @"account":mobile,
                             @"athcode":code,
                             @"nickName":nickName,
                             @"userPwd":encryptedPwd
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            NSLog(@"%@",responseData);
        }else{
            mAlertAPIErrorInfo(error);
        }
    }];
    
    
}

- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
