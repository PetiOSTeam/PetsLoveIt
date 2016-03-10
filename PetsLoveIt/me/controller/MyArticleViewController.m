//
//  MyArticleViewController.m
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/25.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "MyArticleViewController.h"
#import "ShareOrderViewController.h"
#import "ExperienceViewController.h"
#import "CorePagesView.h"

@interface MyArticleViewController ()
@property (nonatomic,strong) CorePagesView *pagesView;

@end

@implementation MyArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}

- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"我的投稿";
    
    [self setPageViews];
    
}
- (void)setPageViews{
    
    NSMutableArray *pageModels = [NSMutableArray new];
    NSArray *topicArray = @[@"晒单",@"经验"];
    for (int i=0; i<topicArray.count; i++) {
        CoreLTVC *vc ;
        if (i==0) {
            vc = [ShareOrderViewController new];
            
        }else if (i==1){
            vc = [ExperienceViewController new];
        }
        vc.isMyArticle = YES;
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
