//
//  AdviceViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/30.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "AdviceViewController.h"
#import "YLLabel.h"
NSString* const msg = @"如果您在使用app过程中遇到功能、内容等方面的错误或者对我们有任何建议和意见，请在此处向我们提交，期待并感谢您的宝贵意见，被采纳的建议我们有丰厚积分相送。";

@interface AdviceViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *cotentContainerView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation AdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"有奖建议";
    self.contentTextView.delegate = self;
    self.cotentContainerView.layer.borderColor = kLayerBorderColor.CGColor;
    self.cotentContainerView.layer.borderWidth = kLayerBorderWidth;
    [self.scrollView setContentSize:CGSizeMake(mScreenWidth, self.submitButton.bottom + 20)];
    self.submitButton.layer.cornerRadius = 25;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.placeholder setText:msg];
    self.placeholder.textColor = mRGBToColor(0xbdbdbd);
    self.placeholder.font = [UIFont systemFontOfSize:15.0f];
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length]==0) {
        self.placeholder.hidden = NO;
    }else
        self.placeholder.hidden = YES;
}

- (IBAction)okAction:(id)sender {
    [self.view endEditing:YES];
    NSString *content = _contentTextView.text;
    
    if ([content length]==0) {
        mAlertView(@"提示", @"建议内容不能为空");
        return;
    }
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeNone];
    NSDictionary *params =@{
                            @"uid":@"saveAdviceInfo",
                            @"type":@"1",
                            @"userId":[AppCache getUserId],
                            @"content":content
                            };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [mAppUtils showHint:@"感谢您的建议"];
        }else{
            [SVProgressHUD dismiss];
            mAlertAPIErrorInfo(error);
        }
    }];
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
