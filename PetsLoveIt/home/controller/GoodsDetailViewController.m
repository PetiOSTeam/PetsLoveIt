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
#import "BottomMenuView.h"
#import "BaseNavigationController.h"
#import "PetWebViewController.h"
#import "LoginViewController.h"
#import "CommentGoodsViewController.h"

@interface GoodsDetailViewController ()<UIWebViewDelegate,UITableViewDataSource, UITableViewDelegate,  KMNetworkLoadingViewDelegate, KMDetailsPageDelegate,BottomMenuViewDelegate>

@property (strong, nonatomic)  UIView *navigationBarView;
@property (strong, nonatomic)  UILabel *navBarTitleLabel;

@property (strong, nonatomic)  UIView *networkLoadingContainerView;

@property (nonatomic,strong) BottomMenuView *menuView;


@property (assign) CGPoint scrollViewDragPoint;
@property (nonatomic, strong) KMNetworkLoadingViewController* networkLoadingViewController;
/**产品的喜爱度 */
@property (nonatomic, copy) NSString* popularitystr;
@end

@implementation GoodsDetailViewController{
    BOOL isLiked;
    BOOL isDisliked;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareViewsAndData];
}

-(void)prepareViewsAndData{
    
    [self setupDetailsPageView];
    [self setupNavbarButtons];
    [self setupLoadingView];
    
    [self addExchangeWithTopScrollView:self.detailsPageView.tableView BottomScrollView:self.detailsPageView.tableView2];
    
    if (self.goodsId) {
        [self getProductDetailById:self.goodsId];

    }else if (self.goods){
        [self hideLoadingView];
        [self loadViewAndData];
        //获取猜你喜欢数据
        [self getRelatedInfoById:self.goods.appSort];
    }
    
}

- (void) setupLoadingView{
    [self.view addSubview:self.networkLoadingContainerView];
 
}
-(void)detailWebViewDidFinishLoad{
    [self hideLoadingView];
}




-(BottomMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[BottomMenuView alloc] initWithFrame:CGRectMake(0, mScreenHeight-49, mScreenWidth, 49) menuType:self.pageType];
        
        _menuView.delegate = self;
    }
    return _menuView;
}

-(void)praiseProduct:(BOOL)praiseFlag{
  
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSMutableDictionary *paremssec =[NSMutableDictionary new];
    if ([AppCache getUserInfo]) {
        [params setObject:[AppCache getUserId] forKey:@"userId"];
        
    }
    if ([AppCache getToken]) {
        [paremssec setObject:[AppCache getToken] forKey:@"userToken"];
    }
    [params setObject:@"savePraiseInfo" forKey:@"uid"];
    [params setObject:self.goods.prodId forKey:@"objectId"];
    
    [paremssec setObject:@"getUserPraiseAndNoPraiseNum" forKey:@"uid"];
    [paremssec setObject:self.goods.prodId forKey:@"prodId"];
        [APIOperation GET:@"common.action" parameters:paremssec onCompletion:^(id responseData, NSError *error) {
        NSLog(@"%@1231289312    %@******%@",responseData,self.goods.prodId,[AppCache getToken]);
        
        if (!error) {
            NSDictionary *bean = [responseData objectForKey:@"bean"];
          
            if (![bean count]) {
                if (praiseFlag ) {
                    [params setObject:@"2" forKey:@"type"];
                }else
                {
                    [params setObject:@"21" forKey:@"type"];
                   
                }
                
                [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
                    if (!error) {
                        [self productpopularityWithobjectId:self.goods.prodId];
                                           }
                }];
            }else{
                [mAppUtils showHint:@"您已经点过了哦"];
                return;
            }
            
        }
    }];
}
#pragma mark - 显示产品的喜爱度
- (void)productpopularityWithobjectId:(NSString *)objectid
{
    
    NSDictionary *paramszan = @{@"uid":@"getPraiseInfo",@"type":@"2",@"objectId":objectid};
    NSDictionary *paramscai = @{@"uid":@"getPraiseInfo",@"type":@"21",@"objectId":objectid};
    [APIOperation GET:@"common.action" parameters:paramszan onCompletion:^(id responseData, NSError *error) {
        
        if (!error) {
            float zancount = [[responseData objectForKey:@"bean"][@"praiseNum"]floatValue];
            [APIOperation GET:@"common.action" parameters:paramscai onCompletion:^(id responseData, NSError *error) {
                
                float caicount = [[responseData objectForKey:@"bean"][@"praiseNum"]floatValue];
                
                if (!error) {
                    float popularityF = zancount/(caicount+zancount)*100;
                    if (zancount == 0) {
                        popularityF =0;
                    }
                    NSString *typestr = [[NSString alloc]initWithFormat:@"%.0f%@",popularityF,@"%" ];
                    _popularitystr = [[NSString alloc]initWithString:typestr];
                    [self.menuView.menuButton1 setTitle:_popularitystr forState:UIControlStateNormal];

                }
            }];
        }
    }];

    
}
- (NSString *)popularitystr
{
    if (!_popularitystr) {
        [self productpopularityWithobjectId:self.goods.prodId];
    }
    return _popularitystr;
}
-(void)collectProduct:(BOOL)collectFlag{
    NSDictionary *params ;
    if (collectFlag) {
        params = @{
                   @"uid":@"saveUsercollect",
                   @"productId":self.goodsId,
                   @"productSort":self.goods.appType
                   };
        self.goods.collectnum = [NSString stringWithFormat:@"%ld",[self.goods.collectnum integerValue]+1];
    }else{
        params = @{
                   @"uid":@"delcollectByUserId",
                   @"productId":self.goodsId
                   };
        self.goods.collectnum = [NSString stringWithFormat:@"%ld",[self.goods.collectnum integerValue]-1];
    }
    [self.menuView.menuButton2 setTitle:self.goods.collectnum forState:UIControlStateNormal];
    
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            
        }else{
            mAlertAPIErrorInfo(error);
        }
    }];
}

-(void)showLoginVC{
    LoginViewController *vc = [LoginViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showCommentVC{
    CommentGoodsViewController *vc = [CommentGoodsViewController new];
    vc.goodsId = self.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)lastMenuAction:(DetailPageType)type{
    switch (type) {
        case GoodsType:
        {
            PetWebViewController *vc = [PetWebViewController new];
            vc.htmlUrl = self.goods.goUrl;
            BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navi animated:YES completion:NULL];
        }
            break;
        case RelatedPersonType:{
            
            break;
        }
        case NewsType:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        default:
            break;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

-(void)dealloc{
    [self removeZJExchangeObserver];

}

- (void) getRelatedInfoById:(NSString *)proId{
    
    NSDictionary *params = @{
                             @"uid":@"getProductsBySort",
                             @"minSortId":proId,
                             @"startNum":@"0",
                             @"limit":@"5"
                             };
    [APIOperation GET:@"getCoreSv.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            NSArray *jsonArray = [[responseData objectForKey:@"beans"] objectForKey:@"beans"];
            [jsonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GoodsModel *goods = [[GoodsModel alloc] initWithDictionary:obj];
                [self.detailsPageView.tableView2.dataArray1 addObject:goods];
            }];
            [self.detailsPageView.tableView2 reloadData];
        }else{
            //mAlertAPIErrorInfo(error);
        }
    }];
}

- (void) getProductDetailById:(NSString *)proId{
    NSDictionary *params = @{
                             @"uid":@"getProductByNodeId",
                             @"prodId":proId
                             };
    [APIOperation GET:@"getCoreSv.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        //[self hideLoadingView];
        if (!error) {
            self.goods = [[GoodsModel alloc] initWithDictionary:[responseData objectForKey:@"data"]] ;
            [self loadViewAndData];
            //获取猜你喜欢数据
            [self getRelatedInfoById:self.goods.appSort];
        }else{
            [self hideLoadingView];
            mAlertAPIErrorInfo(error);
        }
    }];
}
#pragma mark - 加载HTML页面数据，并进行图文混排
-(void) loadViewAndData{
    NSString *html = self.goods.prodDetail;
    CGFloat viewwidth = [UIScreen mainScreen].bounds.size.width - 32;
    NSString *css = [NSString stringWithFormat:@"<html><meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no\" /><body width=%f style=\"word-wrap:break-word;ext-align: justify; font-family:Arial\"><style>img{max-width:%f;height:auto;}</style>",viewwidth,viewwidth];
    
    NSMutableString *desc = [NSMutableString stringWithFormat:@"%@%@%@",
                             css,
                             html,
                             @"</body></html>"];
    [self.detailsPageView loadHtmlString:desc];
    
    if (self.pageType == RelatedPersonType) {
        [_menuView loadAvatarImage:self.goods.publisherIcon];
    }
    [self.menuView.menuButton1 setTitle:self.popularitystr forState:UIControlStateNormal];
    [self.menuView.menuButton2 setTitle:self.goods.collectnum forState:UIControlStateNormal];
    [self.menuView.menuButton4 setTitle:self.goods.commentNum forState:UIControlStateNormal];
    if ([self.goods.usercollectnum isEqualToString:@"1"]) {
        self.menuView.menuButton2.selected = YES;
    }
    [self.detailsPageView loadGoodsInfo:self.goods];
    [self.detailsPageView reloadData];

}

-(UIView *)navigationBarView{
    if (!_navigationBarView) {
        _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 64)];
        
        if (CURRENT_SYS_VERSION >= 8.0) {
            UIImageView *blurImageView = [[UIImageView alloc] initWithFrame:_navigationBarView.bounds];
            
            UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            
            visualEffectView.frame = blurImageView.bounds;
            
            [blurImageView addSubview:visualEffectView];
            [_navigationBarView addSubview:blurImageView];
        }
        
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
         [self addbuttonBackintheSubView:_networkLoadingContainerView];
        self.networkLoadingViewController.view.top = 20;
    }
    return _networkLoadingContainerView;
}
#pragma mark - 在等待页面和详情页面均添加返回按钮
- (void)addbuttonBackintheSubView:(UIView *)subview
{
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(0, 30 , 44, 34);
    buttonBack.center = CGPointMake(buttonBack.center.x, self.navBarTitleLabel.center.y) ;
    [buttonBack setImage:[UIImage imageNamed:@"backBarButtonIcon"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    [subview addSubview:buttonBack];
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
    [self.view addSubview:self.menuView];
    [self.detailsPageView reloadData];

}


- (void)setupNavbarButtons
{
    [self.view addSubview:self.navigationBarView];
    self.navBarTitleLabel.text = @"优惠详情";
    [self addbuttonBackintheSubView:self.view];
    
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
    return UIViewContentModeScaleToFill;
}

- (UIImageView*)detailsPage:(KMDetailsPageView*)detailsPageView imageDataForImageView:(UIImageView*)imageView;
{
    __block UIImageView* blockImageView = imageView;
    
    [imageView  sd_setImageWithURL:[NSURL URLWithString:self.goods.appPic] placeholderImage:[UIImage imageNamed:@"goodsDetail_default_load"] completed:^ (UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
