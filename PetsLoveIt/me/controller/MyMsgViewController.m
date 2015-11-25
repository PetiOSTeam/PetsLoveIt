//
//  MyMsgViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/25.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MyMsgViewController.h"
#import "CorePagesView.h"
#import "SysMsgViewController.h"
#import "MsgViewController.h"

@interface MyMsgViewController ()
@property (nonatomic,strong) CorePagesView *pagesView;

@end

@implementation MyMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}

- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"我的消息";
    
    [self setPageViews];
    
}
- (void)setPageViews{
    
    NSMutableArray *pageModels = [NSMutableArray new];
    NSArray *topicArray = @[@"系统消息",@"我的消息"];
    for (int i=0; i<topicArray.count; i++) {
        id vc ;
        if (i==0) {
            vc = [SysMsgViewController new];
            
        }else if (i==1){
            vc = [MsgViewController new];
        }
        CorePageModel *pageModel=[CorePageModel model:vc pageBarName:topicArray[i]];
        [pageModels addObject:pageModel];
        
    }
    _pagesView=[CorePagesView viewWithOwnerVC:self pageModels:pageModels useAutoResizeWidth:YES];
    _pagesView.top = 64;
    [self.pagesView.pagesBarView setBackgroundColor:mRGBToColor(0xfeffff)];
    [self.pagesView.scrollView setBackgroundColor:mRGBToColor(0xffffff)];
    [self.view addSubview:self.pagesView];
    
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
