//
//  LoginViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/22.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "LoginViewController.h"
#import "RegViewController.h"
#import "ForgotPwdViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "RegViewController.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialAccountManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface LoginViewController ()

@property (retain, nonatomic) TencentOAuth *tencentOAuth;
@property (nonatomic,strong) NSString *otherType;
@property (nonatomic,strong) NSString *otherAccount;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareViewAndData];
}

- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"登录";
    self.accountTextField.text = [mUserDefaults objectForKey:HLoginAccount];
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
    if (![WXApi isWXAppInstalled]) {
        self.wxBtn.hidden = YES;
    }
    if (![QQApiInterface isQQInstalled]) {
        self.qqBtn.hidden = YES;
    }
    
}

- (IBAction)weiboAction:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            self.otherAccount = snsAccount.accessToken;
            self.otherType = @"3";
            [self bindUserAccount];
            
    }});
}
- (IBAction)wxAction:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            self.otherAccount = snsAccount.usid;
            self.otherType = @"2";
            [self bindUserAccount];
            
        }
        
    });
}
- (IBAction)qqAction:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            self.otherType = @"1";
            self.otherAccount = snsAccount.usid;
            [self bindUserAccount];
            
        }});
}

- (void)bindUserAccount{
    [SVProgressHUD showWithStatus:@"请稍后" maskType:SVProgressHUDMaskTypeNone];
    NSDictionary *params = @{
                             @"uid":@"isBindOtherUser",
                             @"othertype":self.otherType,
                             @"otheraccount":self.otherAccount                          };
    [APIOperation GET:@"isBindUser.action"  parameters:params onCompletion:^(id responseData, NSError *error) {
        [SVProgressHUD dismiss];
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
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //未绑定第三方帐号,完善信息
            [self showFillPersonInfoVC];
            mAlertAPIErrorInfo(error);
        }
    }];
}

- (void)showFillPersonInfoVC{
    RegViewController *vc = [RegViewController new];
    vc.isOtherLogin = YES;
    vc.otherType = self.otherType;
    vc.otherAccount = self.otherAccount;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        NSLog(@"用户取消登录");
        // _labelTitle.text = @"用户取消登录";
    }
    else
    {
        NSLog(@"登录失败");
        //_labelTitle.text = @"登录失败";
    }
}

- (void)tencentDidNotNetWork
{
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.accountTextField isFirstResponder] || [self.pwdTextField isFirstResponder]) {
        [self.view endEditing:YES];
    }
}

- (IBAction)forgotAction:(id)sender {
    ForgotPwdViewController *vc = [ForgotPwdViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    NSString  *mobile = self.accountTextField.text;
    NSString  *pwd = self.pwdTextField.text;
    NSString *encryptedPwd = [[_Des AES128Encrypt:[pwd appendAESKeyAndTimeStamp]] uppercaseString];
    if ([mobile length]==0) {
        mAlertView(@"提示", @"手机号不能为空");
        return;
    }
    if ([pwd length] == 0) {
        mAlertView(@"提示", @"密码不能为空");
        return;
    }
    
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeClear];
    NSDictionary *params = @{
                             @"uid":@"login",
                             @"type":@"1",
                             @"userName":mobile,
                             @"userPwd":encryptedPwd
                             };
    [APIOperation GET:@"userLogin.action" parameters:params onCompletion:^(id responseData, NSError *error) {

        if (!error) {
            NSMutableDictionary *userDict = [responseData objectForKey:@"bean"];
            LocalUserInfoModelClass *localUserInfo = [[LocalUserInfoModelClass alloc] initWithDictionary:userDict];
            localUserInfo.userToken = [responseData objectForKey:@"userToken"];
            localUserInfo.loginType = [params objectForKey:@"type"];
            localUserInfo.accountName = [params objectForKey:@"userName"];
            localUserInfo.password = encryptedPwd;
            //将userinfo记录下来
            mAppDelegate.loginUser = localUserInfo;
            [AppCache cacheObject:localUserInfo forKey:HLocalUserInfo];
            
            [mUserDefaults setObject:_accountTextField.text forKey:HLoginAccount];
            [mUserDefaults synchronize];
            
            //登录成功
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD dismiss];
            mAlertAPIErrorInfo(error);
        }
    }];
}

- (IBAction)regAction:(id)sender {
    RegViewController *vc = [RegViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
