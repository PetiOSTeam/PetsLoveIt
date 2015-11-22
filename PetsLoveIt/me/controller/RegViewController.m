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
}

- (IBAction)msgAction:(id)sender {
}

- (IBAction)showPwdAction:(id)sender {
    UIButton *button = sender;
    BOOL selected = button.selected;
    if (selected) {
        self.pwdTextField.secureTextEntry = NO;
    }else{
        self.pwdTextField.secureTextEntry = YES;
    }
}
- (IBAction)regAction:(id)sender {
}
- (IBAction)regEmailAction:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
