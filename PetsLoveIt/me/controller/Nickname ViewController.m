//
//  Nickname ViewController.m
//  PetsLoveIt
//
//  Created by 123 on 16/3/9.
//  Copyright © 2016年 liubingyang. All rights reserved.
//

#import "Nickname ViewController.h"

@interface Nickname_ViewController ()
@property (strong,nonatomic) UITextField *nickTextField;
@end

@implementation Nickname_ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"修改昵称";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addrightNaviButton];
    [self addnickTextField];
}
- (void)addrightNaviButton
{
    UIButton *rightNaviButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightNaviButton.frame = CGRectMake(mScreenWidth-52, 30, 44, 34);
    rightNaviButton.center = CGPointMake(rightNaviButton.center.x, 42);
    [rightNaviButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightNaviButton setTitleColor:mRGBToColor(0xff4401) forState:UIControlStateNormal];
 
    [rightNaviButton addTarget:self action:@selector(clickrightNaviButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:rightNaviButton];
}
- (void)addnickTextField
{
    _nickTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, self.navigationBarView.bottom , self.view.width , 40)];
    _nickTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 35)];
    _nickTextField.text = [AppCache getUserName];
    _nickTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nickTextField.leftViewMode = UITextFieldViewModeAlways;
    _nickTextField.font = [UIFont systemFontOfSize:15];
    //    [nickTextField addTopBorderWithColor:mRGBToColor(0xcccccc) andWidth:0.5];
    [_nickTextField addBottomBorderWithColor:mRGBToColor(0xcccccc) andWidth:0.5];
    [self.view addSubview:_nickTextField];

}
- (void)clickrightNaviButton
{
    [self.view endEditing:YES];
//    if ([_nickTextField.text isEqualToString:[AppCache getUserName]]) {
//        return;
//    }
    
    
    if ((![_nickTextField.text isValidateName])&&(_nickTextField.text.length <= 0)) {
        mAlertView(@"提示", @"昵称应该是1-12位数字字母下划线汉字的组合");
        return;
    }
    
    
    NSDictionary *params = @{
                             @"uid":@"updateUsernickName",
                             @"nickName":_nickTextField.text
                             };
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeNone];
    [APIOperation GET:@"getCoreSv.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            NSLog(@"responseData%@",responseData);
            [mAppUtils showHint:@"修改成功"];
            LocalUserInfoModelClass *localUserInfo = [AppCache getUserInfo];
            localUserInfo.nickName = _nickTextField.text;
            localUserInfo.uName = _nickTextField.text;//getCoreSv.action?uid=updateUsernickName
            [AppCache cacheObject:localUserInfo forKey:HLocalUserInfo];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD dismiss];
            mAlertAPIErrorInfo(error);
        }
    }];
    
    NSLog(@"%@",_nickTextField.text);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
