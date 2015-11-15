//
//  SortViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/12.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SortViewController.h"
#import "XLSlideBarView.h"
#import "ScreenStoreView.h"
#import "ScreenSoretedView.h"
#import "SearchViewController.h"
#import "BaseNavigationController.h"

@interface SortViewController ()<XLSlideBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) XLSlideBarView *slideBarView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SortViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigationUI];
    if (!_slideBarView) {
        [self setupUI];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupNavigationUI
{
    self.navigationItem.titleView = self.searchButton;
}

- (void)setupUI
{
    ScreenSoretedView *soretedView = [[ScreenSoretedView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - CGRectGetMaxY(self.slideBarView.frame))];
    [self.scrollView addSubview:soretedView];
    [soretedView addTopBorderWithColor:kLineColor andWidth:.5];
    
    ScreenStoreView *screenStoreView = [[ScreenStoreView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - CGRectGetMaxY(self.slideBarView.frame))];
    screenStoreView.left = self.view.width;
    [self.scrollView addSubview:screenStoreView];
    [screenStoreView addTopBorderWithColor:kLineColor andWidth:.5];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width * 2, 0);
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

- (void)selectedWithSorePage:(int)page
{
    [self.scrollView setContentOffset:CGPointMake(page * self.scrollView.width, 0) animated:YES];
}

#pragma mark - *** XLSlideBar Delegate ***

- (void)selectItemWithPage:(int)page withObject:(XLSlideBarView *)slideBar
{
    [self selectedWithSorePage:page];
}

#pragma mark - *** UIScrollView Delegate ***

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.slideBarView changeItemWithScale:scrollView.contentOffset.x / scrollView.contentSize.width];
}

#pragma mark - *** Push search action ***

- (void)clickSearchAction
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - *** getter ***

- (UIButton *)searchButton
{
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setBackgroundImage:[AppUtils imageFromColor:mRGBToColor(0xeeeeee)] forState:UIControlStateNormal];
        [_searchButton setBackgroundImage:[AppUtils imageFromColor:mRGBToColor(0xeeeeee)] forState:UIControlStateHighlighted];
        
        _searchButton.width = self.view.width - 20;
        _searchButton.height = 30;
        _searchButton.layer.cornerRadius = 4.f;
        _searchButton.layer.masksToBounds = YES;
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon"]];
        [searchIcon sizeToFit];
        [_searchButton addSubview:searchIcon];
        [_searchButton addTarget:self
                          action:@selector(clickSearchAction)
                forControlEvents:UIControlEventTouchUpInside];
        
        searchIcon.translatesAutoresizingMaskIntoConstraints = NO;
        [searchIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [searchIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        UILabel *searchLabel = [[UILabel alloc] initForAutoLayout];
        searchLabel.text = @"搜索";
        searchLabel.font = [UIFont systemFontOfSize:13];
        searchLabel.textColor = mRGBToColor(0x999999);
        [searchLabel sizeToFit];
        [_searchButton addSubview:searchLabel];
        [searchLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:searchIcon withOffset:5];
        [searchLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    return _searchButton;
}

- (XLSlideBarView *)slideBarView
{
    if (!_slideBarView) {
        _slideBarView = [[XLSlideBarView alloc] initWithItems:@[@"分类筛选", @"商城筛选"] withFrame:CGRectMake(0, 0, 200, 47) withDelegate:self];
        [self.view addSubview:_slideBarView];
        [_slideBarView autoSetDimensionsToSize:CGSizeMake(200, 47)];
        [_slideBarView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_slideBarView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        UIView *line = [[UIView alloc] initForAutoLayout];
        line.backgroundColor = kLineColor;
        [self.view addSubview:line];
        [line autoSetDimension:ALDimensionHeight toSize:.5];
        [line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_slideBarView];
        [line autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [line autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
    }
    return _slideBarView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initForAutoLayout];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
        [_scrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.slideBarView];
        [_scrollView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_scrollView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_scrollView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    }
    return _scrollView;
}

@end
