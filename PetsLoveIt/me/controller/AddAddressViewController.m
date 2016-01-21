//
//  AddAddressViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/30.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIView *zipCodeView;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIView *mobileView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UIView *msgCodeView;
@property (weak, nonatomic) IBOutlet UIButton *msgCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNaviBarView];
    
    [self Querytheshippingaddress];
    
    
    self.addressView.width = self.zipCodeView.width = self.nameView.width = self.mobileView.width = self.msgCodeView.width = mScreenWidth-80;
    [self.addressView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.zipCodeView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.nameView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.mobileView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.msgCodeView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    
    self.okBtn.layer.cornerRadius = 25;
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(self.msgCodeBtn.left -8, 0, 1, 28)];
    [line1 setBackgroundColor:mRGBToColor(0xdcdcdc)];
    line1.center = CGPointMake(line1.center.x, self.msgCodeView.height/2) ;
    [self.msgCodeView addSubview:line1];
    
    self.scrollView.contentSize = CGSizeMake(mScreenWidth, self.okBtn.bottom + 20);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];

}
// 查询收货地址
- (void)Querytheshippingaddress{
    if (self.address) {
        self.addressTextField.text = _address.receiveAddress ;
        self.zipCodeTextField.text = _address.zipCode;
        self.nameTextField.text = _address.receiveName;
        self.mobileTextField.text = _address.receiveTel;
        self.navBarTitleLabel.text=  @"修改收货地址";
    }else{
        self.navBarTitleLabel.text = @"设置收货地址";
    }
    

       }




- (IBAction)okAction:(id)sender {
    [self.view endEditing:YES];
    NSString *clues = @"设置收货地址成功";
    NSString *address = self.addressTextField.text;
    NSString *zipcode = self.zipCodeTextField.text;
    NSString *msgcode = self.codeTextField.text;

    NSString *name = self.nameTextField.text;
    NSString *mobile = self.mobileTextField.text;
    if ([address length]==0) {
        mAlertView(@"提示", @"地址不能为空");
        return;
    }
    if ([zipcode length]==0) {
        mAlertView(@"提示", @"邮政编码不能为空");
        return;
    }
    if ([name length]==0) {
        mAlertView(@"提示", @"姓名不能为空");
        return;
    }
    if ([mobile length]==0) {
        mAlertView(@"提示", @"手机号不能为空");
        return;
    }
    if ([msgcode length]==0) {
        mAlertView(@"提示", @"验证码不能为空");
        return;
    }
    NSDictionary *params = @{
                             @"uid":@"addDeliveryaddress",
                             @"athcode":msgcode,
                             @"receiveName":name,
                             @"receiveTel":mobile,
                             @"receiveAddress":address,
                             @"zipCode":zipcode
                             };
    if (self.address) {
        params = @{
                   @"uid":@"updatedeliveryaddress",
                   @"addressId":self.address.addressId,
                   @"athcode":msgcode,
                   @"receiveName":name,
                   @"receiveTel":mobile,
                   @"receiveAddress":address,
                   @"zipCode":zipcode
                   };
        clues = @"修改收货地址成功";
    }
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeNone];
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
            [mAppUtils showHint:clues];
        }else{
            [SVProgressHUD dismiss];
            mAlertAPIErrorInfo(error);
        }
    }];
}
- (IBAction)msgAction:(id)sender {
    [self.view endEditing:YES];
    NSString  *mobile = self.mobileTextField.text;
    if ([mobile length]==0) {
        mAlertView(@"提示", @"手机号不能为空");
        return;
    }
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
