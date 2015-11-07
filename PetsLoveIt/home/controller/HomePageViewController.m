//
//  HomePageViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/6.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "HomePageViewController.h"
#import "CorePagesView.h"
#import "NewsListTVC.h"
#import "TopicModel.h"

@interface HomePageViewController ()
@property (nonatomic,strong) CorePagesView *pagesView;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadViewsAndData];
}

- (void)loadViewsAndData{
    self.title = @"宠物爱这个";
    [self setPageViews];
}

- (void)setPageViews{
    
    
    
    NSMutableArray *pageModels = [NSMutableArray new];
    NSArray *topicArray = @[@"精选",@"优惠",@"海淘",@"淘宠",@"晒单",@"经验",@"资讯"];
    for (int i=0; i<topicArray.count; i++) {
        NewsListTVC *vc = [NewsListTVC new];
        
        TopicModel *topic = [TopicModel new];
        vc.topic = topic;
        topic.name = [topicArray objectAtIndex:i];
        CorePageModel *pageModel=[CorePageModel model:vc pageBarName:topic.name];
        [pageModels addObject:pageModel];
    }
    _pagesView=[CorePagesView viewWithOwnerVC:self pageModels:pageModels];
    [self.pagesView.pagesBarView setBackgroundColor:mRGBToColor(0xfeffff)];
    [self.pagesView.scrollView setBackgroundColor:mRGBToColor(0xffffff)];
    [self.view addSubview:self.pagesView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
