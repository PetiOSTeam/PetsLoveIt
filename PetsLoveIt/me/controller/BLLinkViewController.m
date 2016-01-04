//
//  BLLinkViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/25.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "BLLinkViewController.h"
#import "FillBLViewController.h"

@interface BLLinkViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *linkView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UILabel *BLinstructions;

@end

@implementation BLLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}

- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"我的爆料";
    self.linkView.width = mScreenWidth - 40;
    [self.linkView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    self.textView.delegate = self;
    self.okButton.layer.borderColor = mRGBToColor(0xc2c2c2).CGColor;
    self.okButton.layer.borderWidth = 1;
    self.okButton.layer.cornerRadius = 23;
    
    NSString *labelText = self.BLinstructions.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:2.5];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.BLinstructions.attributedText = attributedString;
    
    [self.BLinstructions sizeToFit];
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length]==0) {
        self.placeHolderLabel.hidden = NO;
    }else
        self.placeHolderLabel.hidden = YES;
}
- (IBAction)okAction:(id)sender {
    [self.view endEditing:YES];
    NSString *sourceLink = self.textView.text;
    if ([sourceLink length]==0) {
        mAlertView(@"提示", @"链接不能为空");
        return;
    }else{
        
        NSString * tempStr1 = @"http://";
        NSString * tempStr2 = @"https://";
        NSString * tempStr3 = @"HTTP://";
        NSString * tempStr4 = @"HTTPS://";
        
        
        
        NSRange range1 = [sourceLink rangeOfString:tempStr1];//判断字符串是否包含
        
        NSRange range2 = [sourceLink rangeOfString:tempStr2];
        NSRange range3 = [sourceLink rangeOfString:tempStr3];//判断字符串是否包含
        NSRange range4 = [sourceLink rangeOfString:tempStr4];

        
        //if (range.location ==NSNotFound)//不包含
        
        if ((range1.length >0)||(range2.length >0)||(range3.length >0)||(range4.length >0))//包含
        {
        }
        
        else//不包含
            
        {
            mAlertView(@"提示", @"请填写带有http://或者https://的网址");
            return;
            
        }
    }
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeNone];
    NSDictionary *params = @{@"uid":@"getShareInfo",
                             @"sourceLink":sourceLink
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            FillBLViewController *vc = [FillBLViewController new];
            BLModel *model = [[BLModel alloc] initWithDictionary:[responseData objectForKey:@"bean"]];
            model.sourceLink = sourceLink;
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            int rtnCode = [[responseData objectForKey:@"rtnCode"] intValue];
            if (rtnCode == 0 ) {
                mAlertAPIErrorInfo(error);
            }
        }
    }];
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
