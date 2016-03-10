//
//  MoreViewController.m
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/23.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "MoreViewController.h"
#import <CoreText/CoreText.h>
#import "AwardRulesViewController.h"

@interface MoreViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *appIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UIView *gradeView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreementLabel;


@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self prepareViewAndData];
}

- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"更多";

    self.appIconImageView.center = CGPointMake(mScreenWidth/2, _appIconImageView.center.y);
    self.appNameLabel.center = CGPointMake(mScreenWidth/2, _appNameLabel.center.y);
    self.logoutBtn.layer.cornerRadius = 25;
    self.gradeView.layer.borderColor = kLayerBorderColor.CGColor;
    self.gradeView.layer.borderWidth = kLayerBorderWidth;
    self.gradeView.userInteractionEnabled = YES;
    
    if (![AppCache getUserInfo]) {
        self.logoutBtn.hidden = YES;
    }else{
        self.logoutBtn.hidden = NO;
    }
    NSString *agreeString = @"用户协议";
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:agreeString];
    [attriString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                        value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                        range:NSMakeRange(0, [agreeString length])];
    self.agreementLabel.attributedText = attriString;
    self.agreementLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureOnAgree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAgreeVC)];
    [self.agreementLabel addGestureRecognizer:tapGestureOnAgree];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGrade)];
    [self.gradeView addGestureRecognizer:tapGesture];
}

- (void)showAgreeVC{
    AwardRulesViewController *vc = [AwardRulesViewController new];
    vc.navTitle = @"用户协议";
    NSString *agreeStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"agree" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    vc.desc = agreeStr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) showGrade{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iVersioniOSAppStoreURLFormat]];
}
- (IBAction)logoutAction:(id)sender {
    
    [mAppUtils appLogoutAction];
    [self.navigationController popViewControllerAnimated:YES];
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
