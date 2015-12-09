//
//  FillBLViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/9.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "FillBLViewController.h"

@interface FillBLViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet UITextField *sortTextField;
@property (weak, nonatomic) IBOutlet UIView *reasonView;
@property (weak, nonatomic) IBOutlet UITextField *reasonTextField;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation FillBLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"我的爆料";
    
    if (self.model.title ) {
        self.titleTextField.text = self.model.title;
    }
    if (_model.source ) {
        self.nameTextField.text = _model.source;
    }
    if (_model.price ) {
        self.priceTextField.text = _model.price;
    }
    if (_model.productType) {
        self.sortTextField.text = _model.productType;
    }
    if (_model.shareReason) {
        self.reasonTextField.text = _model.shareReason;
    }
    
    self.titleView.width = self.nameView.width = self.priceView.width = self.sortView.width  = self.reasonView.width = mScreenWidth-40;
    
    [self.titleView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.nameView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.priceView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.sortView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.reasonView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    
    self.okBtn.layer.cornerRadius = 25;
    [self.scrollView setContentSize:CGSizeMake(mScreenWidth, self.okBtn.bottom + 20)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (IBAction)okAction:(id)sender {
    NSString *title = self.titleTextField.text;
    NSString *name = self.nameTextField.text;
    NSString *price = self.priceTextField.text;
    NSString *sort = self.sortTextField.text;
    NSString *reason = self.reasonTextField.text;
    
    if ([title length]==0) {
        mAlertView(@"提示", @"商品标题不能为空");
        return;
    }
    if ([name length]==0) {
        mAlertView(@"提示", @"商城名称不能为空");
        return;
    }
    if ([price length]==0) {
        mAlertView(@"提示", @"价格不能为空");
        return;
    }
    if ([sort length]==0) {
        mAlertView(@"提示", @"分类不能为空");
        return;
    }
    if ([reason length]==0) {
        mAlertView(@"提示", @"推荐理由不能为空");
        return;
    }
    NSDictionary *params = @{
                             @"uid":@"saveShareInfo",
                             @"userId":[AppCache getUserId],
                             @"type":@"1",
                             @"productType":sort,
                             @"title":title,
                             @"price":price,
                             @"source":name,
                             @"sourceLink":_model.sourceLink,
                             @"sharePic":_model.sharePic,
                             @"shareReason":reason
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            [mAppUtils showHint:@"爆料成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            mAlertAPIErrorInfo(error);
        }
    }];

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
