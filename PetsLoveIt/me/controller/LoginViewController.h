//
//  LoginViewController.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/22.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CommonViewController.h"

@interface LoginViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIView *opView;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;




@end
