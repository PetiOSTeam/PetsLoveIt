//
//  AwardRulesViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/29.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "AwardRulesViewController.h"

@interface AwardRulesViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AwardRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"规则说明";
    self.textView.scrollEnabled = NO;
    [self.scrollView setContentSize:CGSizeMake(mScreenWidth, self.textView.contentSize.height + self.textView.top+20)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
