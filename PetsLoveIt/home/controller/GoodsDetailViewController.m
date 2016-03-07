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
#import "CheapProductCell.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "CommentGoodsViewController.h"
#import "UserpageViewController.h"
#import "CoreViewNetWorkStausManager.h"
#define sectionHeaderHeight 47

@interface GoodsDetailViewController ()<UIWebViewDelegate,UITableViewDataSource, UITableViewDelegate,  KMNetworkLoadingViewDelegate, KMDetailsPageDelegate,BottomMenuViewDelegate,CheapProductCellDelegate>

@property (strong, nonatomic)  UIView *navigationBarView;
@property (strong, nonatomic)  UILabel *navBarTitleLabel;

@property (strong, nonatomic)  UIView *networkLoadingContainerView;

@property (nonatomic,strong) BottomMenuView *menuView;

@property (strong, nonatomic)  KMDetailsPageView * detailsPageView;
@property (assign) CGPoint scrollViewDragPoint;
@property (nonatomic, strong) KMNetworkLoadingViewController* networkLoadingViewController;

@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation GoodsDetailViewController
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
        
        self.goodsId = self.goods.prodId;
        self.navBarTitleLabel.text = [NSString stringWithFormat:@"%@详情",self.goods.typeName];
        [self loadViewAndData];
        //获取猜你喜欢数据
        [self getRelatedInfoByModel:self.goods];
    }
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void) setupLoadingView{
    [self.view addSubview:self.networkLoadingContainerView];
 
}
-(void)detailWebViewDidFinishLoad{
    //顶部的商品信息加载完后，再加载热门评论，fix热门评论先出现的bug
    [self getHotComment];
    [self hideLoadingView];
    
}

-(BottomMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[BottomMenuView alloc] initWithFrame:CGRectMake(0, mScreenHeight-49, mScreenWidth, 49) menuType:self.apptypename];
        
        _menuView.delegate = self;
    }
    return _menuView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(void)getHotComment{
    NSString *productId = self.goods.prodId==nil?self.goodsId:self.goods.prodId;
    NSDictionary *params = @{@"uid":@"getHotCommentByProduct",
                             @"productId":productId,
                             @"pageIndex":@"1",
                             @"pageSize":@"10"
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            NSArray *jsonArray = [[responseData objectForKey:@"rows"] objectForKey:@"rows"];
            if ([jsonArray count] ==0) {
                return ;
            }
            [jsonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CommentModel *model = [[CommentModel alloc] initWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
            [self.detailsPageView.tableView reloadData];

        }
    }];
}



-(void)praiseProduct:(BOOL)praiseFlag{
  
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if ([AppCache getUserInfo]) {
        [params setObject:[AppCache getUserId] forKey:@"userId"];
        
    }else{
        [mAppUtils showHint:@"您还没有登录"];
        return;
    }

    [params setObject:@"savePraiseInfo" forKey:@"uid"];
    [params setObject:self.goods.prodId forKey:@"objectId"];
    
    
            if (self.goods.isclick == NOclick) {
                if (praiseFlag ) {
                    [params setObject:@"2" forKey:@"type"];
                    
                }else
                {
                    [params setObject:@"21" forKey:@"type"];
                   
                }
                
                [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
                    if (!error) {
                        [self productpopularityWithobject:self.goods.prodId];
                        self.menuView.menuButton1.selected = YES;
                        self.goods.isclick = ISclick;
                                           }
                }];
            }else{
                [mAppUtils showHint:@"您已经点过了哦"];
                return;
            }
    
}
#pragma mark - 显示产品的喜爱度
//- (NSString *)popularitystr
//{
//    if (!_popularitystr) {
//        [self productpopularityWithobjectId:self.goods.prodId];
//    }
//    return _popularitystr;
//}
- (void)productpopularityWithobject:(NSString *)objectid
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
                    self.goods.popularitystr = [[NSString alloc]initWithString:typestr];
                    [self.menuView.menuButton1 setTitle: self.goods.popularitystr forState:UIControlStateNormal];

                }
            }];
        }
    }];
}
#pragma mark 显示用户对产品点的是赞还是踩
- (void)userlikedproductonYESorNO
{
    
    NSMutableDictionary *paremssec =[NSMutableDictionary new];
    if ([AppCache getToken]) {
        [paremssec setObject:[AppCache getToken] forKey:@"userToken"];
    }
    [paremssec setObject:@"getUserPraiseAndNoPraiseNum" forKey:@"uid"];
    if (self.goods.prodId.length > 0) {
        [paremssec setObject:self.goods.prodId forKey:@"prodId"];
    }else
    {
        return;
    }
    
    [APIOperation GET:@"common.action" parameters:paremssec onCompletion:^(id responseData, NSError *error) {
        if (!error) {
           
            NSDictionary *bean = [responseData objectForKey:@"bean"];
            
            if ([bean count]) {
                                   self.goods.isclick = ISclick;
                    self.menuView.menuButton1.selected = YES;
                
            }else{
                self.menuView.menuButton1.selected = NO;
                self.goods.isclick = NOclick;
            }
            
        }
    }];
}

-(void)collectProduct:(BOOL)collectFlag{
    NSString *productId = self.goods.prodId==nil?self.goodsId:self.goods.prodId;

    NSDictionary *params ;
    if (collectFlag) {
        params = @{
                   @"uid":@"saveUsercollect",
                   @"productId":productId,
                   @"productSort":self.goods.appType
                   };
        self.goods.collectnum = [NSString stringWithFormat:@"%ld",[self.goods.collectnum integerValue]+1];
        NSLog(@"%@",params);
    }else{
        params = @{
                   @"uid":@"delcollectByUserId",
                   @"productId":self.goodsId
                   };
        self.goods.collectnum = [NSString stringWithFormat:@"%ld",[self.goods.collectnum integerValue]-1];
    }
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            [self.menuView.menuButton2 setTitle:self.goods.collectnum forState:UIControlStateNormal];
            if (collectFlag){
                
                [mAppUtils showHint:@"收藏成功"];
            }else{
                

                [mAppUtils showHint:@"取消收藏成功"];
            }
            
        }else{
                    }
    }];
}
#pragma mark - BottomMenuViewDelegate
-(void)showLoginVC{
    LoginViewController *vc = [LoginViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showCommentVC{
    CommentGoodsViewController *vc = [CommentGoodsViewController new];
    if (self.goodsId) {
        vc.goodsId = self.goodsId;
    }else
        vc.goodsId = self.goods.prodId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)lastMenuAction:(Menutype)type{
    switch (type) {
        case TypeDiscount:
        case TypeMassTao:
        case TypeTaoPet:
        case TypeCheap:
        {
            PetWebViewController *vc = [PetWebViewController new];
//            vc.isProduct = YES;
            vc.htmlUrl = self.goods.goUrl;
            if(vc.htmlUrl.length == 0){
                return;
            }
            BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navi animated:YES completion:NULL];
        }
            break;
        case TypeShareOrder:
        case TypeExperience:{
            
            break;
        }
        case TypeNews:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        default:
            break;
    }
}
 #warning  点击头像跳转到他人主页功能，暂时注释掉后期需要用。
-(void)ClickShaidanauthor
{
//     if((![self.goods.userId isEqualToString:@"0"])&&(self.goods.userId))  {
//        UserpageViewController *vc = [[UserpageViewController alloc]init];
//        vc.uesrId = self.goods.userId;
//        
//        [self.navigationController pushViewController:vc animated:YES];
//    }
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

- (void) getRelatedInfoByModel:(GoodsModel *)good{
   

    if (good.appType == nil) {
       [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    self.apptypename = good.apptypename;
    NSDictionary *params = @{
                             @"uid":@"getProductByType",
                             @"appType":good.appType,
                             @"startNum":@"0",
                             @"limit":@"5",
                             @"order":@"4"
                             };

    if ((self.apptypename == TypeDiscount)||(self.apptypename == TypeMassTao)) {
        
                  params = @{
                                 @"uid":@"getProductsBySort",
                                 @"minSortId":good.appSort,
                                 @"startNum":@"0",
                                 @"limit":@"5",
                                @"order":@"4"
                                 };

    }else if (self.apptypename == TypeCheap) {
        
        params = @{@"uid":@"getCheapProductList",
                   @"startNum":@"1",
                   @"limit":@"11",
                   };
    
    //如果是白菜价，则猜你喜欢取白菜价列表接口
    
    }
    [APIOperation GET:@"getCoreSv.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            NSLog(@"%@",responseData);
            NSMutableArray *jsonArray = [[responseData objectForKey:@"beans"] objectForKey:@"beans"];
            if (jsonArray.count == 0) {
                [CoreViewNetWorkStausManager show:self.detailsPageView.tableView2 type:CMTypeError msg:kNoContentTip  subMsg:kNoContentSubTip offsetY:0 failClickBlock:^{
                    
                }];
                return ;
            }
            
            [jsonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                GoodsModel *tempgoods = [[GoodsModel alloc] initWithDictionary:obj];
                if ((tempgoods.prodId != good.prodId)&&(idx < 10)) {
                    [self.detailsPageView.tableView2.dataArray1 addObject:tempgoods];
                }
                if (self.detailsPageView.tableView2.dataArray1.count == 0) {
                    [CoreViewNetWorkStausManager show:self.detailsPageView.tableView2 type:CMTypeError msg:kNoContentTip  subMsg:kNoContentSubTip offsetY:0 failClickBlock:^{
                        
                    }];
                    return ;
                }
                
            }];
            
            [self.detailsPageView.tableView2 reloadData];
        }else{
           
        }
    }];
}

- (void) getProductDetailById:(NSString *)proId{
    NSDictionary *params = @{
                             @"uid":@"getProductByNodeId",
                             @"prodId":proId
                             };
    [APIOperation GET:@"getCoreSv.action" parameters:params onCompletion:^(id responseData, NSError *error) {
       
        if (!error) {
           
            self.goods = [[GoodsModel alloc] initWithDictionary:[responseData objectForKey:@"data"]] ;
             
            self.navBarTitleLabel.text = [NSString stringWithFormat:@"%@详情",self.goods.typeName];
            [self loadViewAndData];
            //获取猜你喜欢数据
            [self getRelatedInfoByModel:self.goods];
            
        }else{
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
                    [mAppUtils showHint:kNetWorkUnReachableDesc];
                
                 [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}
#pragma mark - 加载HTML页面数据，并进行图文混排
-(void) loadViewAndData{
    [self.detailsPageView loadGoodsInfo:self.goods];
    NSString *html = self.goods.prodDetail;
   
    CGFloat viewwidth = [UIScreen mainScreen].bounds.size.width - 24;
    NSString *css = [NSString stringWithFormat:@"<html><meta name=\"viewport\" content=\" initial-scale=1, maximum-scale=1\" /><body width=%f !important;style=\"word-wrap:break-word !important; font-family:Arial\"><style>img{max-width:%f !important; height:auto !important;}</style>",viewwidth,viewwidth -16];
    
    NSMutableString *desc = [NSMutableString stringWithFormat:@"%@%@%@",
                             css,
                             html,
                             @"</body></html>"];
    [self.detailsPageView loadHtmlString:desc];
    
    if ((self.apptypename == TypeExperience)||(self.apptypename == TypeShareOrder)) {
        [_menuView loadAvatarImage:self.goods.publisherIcon];
    }
    [self.menuView.menuButton1 setTitle:self.goods.popularitystr forState:UIControlStateNormal];
    [self userlikedproductonYESorNO];

    
    [self.menuView.menuButton2 setTitle:self.goods.collectnum forState:UIControlStateNormal];
    [self.menuView.menuButton4 setTitle:self.goods.commentNum forState:UIControlStateNormal];
   
    if ([self.goods.usercollectnum isEqualToString:@"1"]) {
       
        self.menuView.menuButton2.selected = YES;
    }
    
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
        _detailsPageView = [[KMDetailsPageView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight) Withtype:self.apptypename andAuthor:self.goodsuid];
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
    [self addbuttonBackintheSubView:self.view];
    
}



#pragma mark - 白菜TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *comment = self.dataArray[indexPath.row];
    static NSString *cellIdentifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] firstObject];
    }
    cell.floorLabel.hidden = YES;
    cell.isHotcomment = YES;
    cell.Hotcomenindex = indexPath.row;
    cell.model = comment;
//    [cell loadViewWithModel:comment];
//    [cell setupHotcommentCellFrameWith:indexPath.row andpraiseNum:comment.praiseNum];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat height = [CommentCell heightForCellWithObject:model];
    
    return height;
}

- (void)tableView:(UITableView*)tableView
  willDisplayCell:(UITableViewCell*)cell
forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, sectionHeaderHeight)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, sectionHeaderHeight-0.5, mScreenWidth, 0.5)];
    [lineView setBackgroundColor:kCellSeparatorColor];
    [headerView addSubview:lineView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, mScreenWidth-30, sectionHeaderHeight)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [titleLabel setTextColor:mRGBToColor(0x333333)];
    [titleLabel setText:@"热门评论"];
    [headerView addSubview:titleLabel];
    
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, sectionHeaderHeight)];
    subTitleLabel.right = mScreenWidth - 20;
    [subTitleLabel setTextAlignment:NSTextAlignmentRight];
    [subTitleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [subTitleLabel setTextColor:mRGBToColor(0x666666)];
    [subTitleLabel setText:@"查看全部评论"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAllCommentVC)];
    subTitleLabel.userInteractionEnabled = YES;
    [subTitleLabel addGestureRecognizer:tap];

    [headerView addSubview:subTitleLabel];
  

    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.dataArray.count>0? sectionHeaderHeight:0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommentGoodsViewController *vc = [CommentGoodsViewController new];
    vc.goodsId = self.goodsId==nil?self.goods.prodId:self.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) showAllCommentVC{
    CommentGoodsViewController *vc = [CommentGoodsViewController new];
    vc.goodsId = self.goodsId==nil?self.goods.prodId:self.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
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
    if (self.ispresent == YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
      [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
