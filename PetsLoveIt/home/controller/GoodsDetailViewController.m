//
//  GoodsDetailViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "KMDetailsPageView.h"
#import "KMNetworkLoadingViewController.h"
#import "StoryBoardUtilities.h"

@interface GoodsDetailViewController ()<UITableViewDataSource, UITableViewDelegate,  KMNetworkLoadingViewDelegate, KMDetailsPageDelegate>
@property (strong, nonatomic)  UIView *navigationBarView;
@property (strong, nonatomic)  UIView *networkLoadingContainerView;
@property (strong, nonatomic)  KMDetailsPageView* detailsPageView;
@property (strong, nonatomic)  UILabel *navBarTitleLabel;

@property (assign) CGPoint scrollViewDragPoint;
@property (nonatomic, strong) KMNetworkLoadingViewController* networkLoadingViewController;
@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareViewsAndData];
}

-(void)prepareViewsAndData{
    
    NSString *html = @"<!DOCTYPE html>\r\n<html>\r\n<head lang=\"en\">\r\n    <meta charset=\"UTF-8\">\r\n    <title>app_detail</title>\r\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\" />\r\n    <link rel=\"stylesheet\" href=\"http://res.smzdm.com/phone/app_details_6_0.css\" type=\"text/css\"/>\r\n        <script type=\"text/javascript\">\r\n    if (/iP(hone|od|ad)/.test(navigator.userAgent)) {\r\n        var v = (navigator.appVersion).match(/OS (\\d+)_(\\d+)_?(\\d+)?/),\r\n            version = parseInt(v[1], 10);\r\n        if(version >= 8){\r\n            document.documentElement.classList.add('hairlines')\r\n        }\r\n    }\r\n    </script>\r\n</head>\r\n<body>\r\n\n<article>\n \n\n<p>天猫精选 16:10</p> \r\n<h1 class=\"title-box\">SNOW FLYING 雪中飞  中长款女士羽绒服 XR9102</h1> \n<h1 class=\"title-box\" style='color:#ff0000'>79元包邮</h1>  <h2 class=\"title-box\">优惠力度</h2>\n    <p><p><a href=\"http://www.smzdm.com/URL/AC/YH/F06FAC9B51EDC3EB\" target=\"_blank\" cls_link=\"lianjie\" link=\"http://www.smzdm.com/URL/AC/YH/F06FAC9B51EDC3EB\" link_type=\"other\" sub_type=\"tmall\" link_val=\"AAEJlb-tABqcX7XqkVgWXrXs\" link_title=\"\" b2c=\"tmall\"  product_id=\"AAEJlb-tABqcX7XqkVgWXrXs\" >天猫精选</a>目前报价89元，可使用<a href=\"http://www.smzdm.com/URL/AC/YH/17408A480F0726E8\" target=\"_blank\" cls_link=\"lianjie\" link=\"http://www.smzdm.com/URL/AC/YH/17408A480F0726E8\" link_type=\"other\" sub_type=\"\" link_val=\"\" link_title=\"\">10元无门槛优惠券</a>，实际下单79元包邮，两色可选，尺码较为齐全，有需要的朋友可以入手。</p></p>\n        <blockquote>\n        <p>领取10元优惠券后，79元包邮，价格还可以。</p>    </blockquote>\n    \n        <!--author-box-->\n    <div class=\"author-box clearfix\">\n        <div>\n        <span class=\"nickname\">\n            maoleigepu        </span>\n        </div>\n        \n            <em>来自爆料人：</em>\n        </div>\n    <!--author-box end-->\n    \n    \n        <h2 class=\"title-box\">商品详情</h2>\n    <!-- card-wrap -->\n    <div class=\"card-wrap\">\n        \n                                      <div class=\"card-info\">\n                          此款女士羽绒服，中长款设计，含绒量90%，亮面材质，易于搭配。                      </div>\n                      </div>\n    <!-- card-wrap end-->\n    </article>\n\n<h2 class=\"title-box\">相关标签</h2>\r\n<div class=\"tags-box\">\r\n                    <a href=\"javascript:void(0);\" cls=\"dingyue_tag\" data=\"category_1029_女士羽绒服\">分类：女士羽绒服</a>\r\n                            <a href=\"javascript:void(0);\" cls=\"dingyue_tag\" data=\"mall_247_天猫精选_0\">商城：天猫精选</a>\r\n                            <a href=\"javascript:void(0);\" cls=\"dingyue_tag\" data=\"brand_10537_SNOW FLYING/雪中飞\">品牌：SNOW FLYING/雪中飞</a>\r\n            </div>\r\n\r\n<script type=\"text/javascript\">\r\nvar _article = document.getElementsByTagName(\"article\"),\r\n    _img = _article[0].getElementsByTagName(\"img\"),\r\n    _length = _img.length,\r\n    winWidth = document.body.offsetWidth,\r\n    width;\r\n\r\nif(_length){\r\n    for(var j=0;j<_length;j++){\r\n        var parent_class = _img[j].parentNode.getAttribute(\"class\"),\r\n            img_class = _img[j].getAttribute(\"class\");\r\n        if( img_class==null && parent_class==null ){//排除商品卡片、视频默认图片\r\n            _img[j].onload = function () {\r\n                width = this.width;\r\n                if(width<winWidth){\r\n                    this.setAttribute(\"class\",\"small-img\");\r\n                }\r\n            }\r\n        }\r\n    }\r\n}\r\n</script>\r\n</body>\r\n</html>";
    
    [self setupDetailsPageView];
    [self setupNavbarButtons];
    [self setupLoadingView];
    [self.detailsPageView loadHtmlString:html];
    
    [self addExchangeWithTopScrollView:self.detailsPageView.tableView BottomScrollView:self.detailsPageView.tableView2];
    
}

- (void) setupLoadingView{
    [self.view addSubview:self.networkLoadingContainerView];
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:1];
 
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self removeZJExchangeObserver];

}

-(UIView *)navigationBarView{
    if (!_navigationBarView) {
        _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 64)];
        [_navigationBarView blur];
        [_navigationBarView setBackgroundColor:[UIColor whiteColor]];
        _navBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, mScreenWidth-60, 24)];
        [_navBarTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [_navigationBarView addSubview:_navBarTitleLabel];
    }
    return _navigationBarView;
}

-(UIView *)networkLoadingContainerView{
    if (!_networkLoadingContainerView) {
        _networkLoadingContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        self.networkLoadingViewController = (KMNetworkLoadingViewController*)[StoryBoardUtilities viewControllerForStoryboardName:@"NetworkLoadingStoryboard" class:[KMNetworkLoadingViewController class]];
        self.networkLoadingViewController.delegate = self;
        [self addChildViewController:self.networkLoadingViewController];
        [_networkLoadingContainerView setBackgroundColor:[UIColor whiteColor]];
        [_networkLoadingContainerView addSubview:self.networkLoadingViewController.view];
        self.networkLoadingViewController.view.top = 20;
    }
    return _networkLoadingContainerView;
}

-(KMDetailsPageView *)detailsPageView{
    if (!_detailsPageView) {
        _detailsPageView = [[KMDetailsPageView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    }
    return _detailsPageView;
}

- (void)setupDetailsPageView
{
    self.detailsPageView.tableViewDataSource = self;
    self.detailsPageView.tableViewDelegate = self;
    self.detailsPageView.delegate = self;
    self.detailsPageView.tableViewSeparatorColor = [UIColor clearColor];
    self.detailsPageView.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.detailsPageView];
    [self.detailsPageView reloadData];

}


- (void)setupNavbarButtons
{
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(0, 30, 44, 34);
    [buttonBack setImage:[UIImage imageNamed:@"backBarButtonIcon"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.navigationBarView];
    [self.view addSubview:buttonBack];
    self.navBarTitleLabel.text = @"优惠详情";
}

#pragma mark -
#pragma mark UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodsdetailcell"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


#pragma mark -
#pragma mark KMDetailsPageDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scrollViewDragPoint = scrollView.contentOffset;
}

- (CGPoint)detailsPage:(KMDetailsPageView *)detailsPageView tableViewWillBeginDragging:(UITableView *)tableView;
{
    return self.scrollViewDragPoint;
}

- (UIViewContentMode)contentModeForImage:(UIImageView *)imageView
{
    return UIViewContentModeTop;
}

- (UIImageView*)detailsPage:(KMDetailsPageView*)detailsPageView imageDataForImageView:(UIImageView*)imageView;
{
    __block UIImageView* blockImageView = imageView;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://am.zdmimg.com/201511/08/563e2c80d55dd.jpg_c640.jpg"] completed:^ (UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if ([detailsPageView.delegate respondsToSelector:@selector(headerImageViewFinishedLoading:)])
            [detailsPageView.delegate headerImageViewFinishedLoading:blockImageView];
    }];
    
    return imageView;
}

- (void)detailsPage:(KMDetailsPageView *)detailsPageView tableViewDidLoad:(UITableView *)tableView
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)detailsPage:(KMDetailsPageView *)detailsPageView headerViewDidLoad:(UIView *)headerView
{
    [headerView setAlpha:0.0];
    [headerView setHidden:YES];
}

#pragma mark -
#pragma mark KMNetworkLoadingViewController Methods

- (void)hideLoadingView
{
    [UIView transitionWithView:self.view duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void)
     {
         [self.networkLoadingContainerView removeFromSuperview];
     } completion:^(BOOL finished) {
         [self.networkLoadingViewController removeFromParentViewController];
         self.networkLoadingContainerView = nil;
     }];
    self.detailsPageView.navBarView = self.navigationBarView;
}

#pragma mark -
#pragma mark KMNetworkLoadingViewDelegate

-(void)retryRequest;
{
    
}

- (void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
