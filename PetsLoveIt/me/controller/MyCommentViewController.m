//
//  MyCommentViewController.m
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/24.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "MyCommentViewController.h"
#import "CorePagesView.h"
#import "ReceivedCommentViewController.h"
#import "SentCommentViewController.h"

@interface MyCommentViewController ()
@property (nonatomic,strong) CorePagesView *pagesView;

@end

@implementation MyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}

- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"我的评论";
    
    [self setPageViews];
    
}

- (void)setPageViews{
    
    NSMutableArray *pageModels = [NSMutableArray new];
    NSArray *topicArray = @[@"收到的评论",@"发出的评论"];
    for (int i=0; i<topicArray.count; i++) {
        id vc ;
        if (i==0) {
            vc = [ReceivedCommentViewController new];
            
        }else if (i==1){
            vc = [SentCommentViewController new];
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


@end
