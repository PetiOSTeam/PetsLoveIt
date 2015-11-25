//
//  BLLinkViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/25.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "BLLinkViewController.h"

@interface BLLinkViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *linkView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

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
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length]==0) {
        self.placeHolderLabel.hidden = NO;
    }else
        self.placeHolderLabel.hidden = YES;
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
