//
//  ShareOrderViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/8.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ShareOrderViewController.h"
#import "CoreViewNetWorkStausManager.h"
#import "CorePagesView/Config/CorePagesViewConst.h"
#import "OrderModel.h"
#import "ShareOrderCell.h"
#import "GoodsDetailViewController.h"

@interface ShareOrderViewController () {
    NSMutableArray *dataArray;
}

@end

@implementation ShareOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareViewsAndData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isCollect || self.isMyArticle) {
        self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight- CorePagesBarViewH;
    }else{
        self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight-self.tabBarController.tabBar.height - CorePagesBarViewH ;
    }
}

- (void)prepareViewsAndData{

    if (self.isCollect || self.isMyArticle) {
        self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight- CorePagesBarViewH;
    }else{
        self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight-self.tabBarController.tabBar.height - CorePagesBarViewH ;
    }
    [self.view setBackgroundColor:mRGBToColor(0xf5f5f5)];
    [self config];
    dataArray = [NSMutableArray new];
    for (int i =0 ; i<20; i++) {
        OrderModel *order = [OrderModel new];
        order.orderPictureUrl = @"http://am.zdmimg.com/201511/01/56362f724a9535919.jpg_d320.jpg";
        order.orderTitle = @"天猫双11预热汽车活动凯迪拉克汽车半价攻略";
        order.userIconUrl = @"http://am.zdmimg.com/201511/01/56362f724a9535919.jpg_d320.jpg";
        order.userName = @"驼驼酱酱";
        order.shareTime = @"20分钟前";
        order.commentNum = @"1563";
        order.likeNum = @"80";
        [dataArray addObject:order];
    }
    self.dataList = dataArray;
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    vc.pageType = RelatedPersonType;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  模型配置
 */
-(void)config{
    
    LTConfigModel *configModel=[[LTConfigModel alloc] init];
    //url,分为公告和话题
    
    configModel.url=[NSString stringWithFormat:@"%@%@",kBaseURL,FeaturedTopicsList];
    
    //请求方式
    configModel.httpMethod=LTConfigModelHTTPMethodGET;
    configModel.params = @{
                           @"udid":@"403",
                           @"sort_id":@"1"
                           };
    //模型类
    configModel.ModelClass=[OrderModel class];
    //cell类
    configModel.ViewForCellClass=[ShareOrderCell class];
    //标识
    configModel.lid=NSStringFromClass(self.class);
    //pageName第几页的参数名
    configModel.pageName=@"page_flag";
    
    //pageSizeName
    configModel.pageSizeName=@"req_num";
    //pageSize
    configModel.pageSize = 10;
    //起始页码
    configModel.pageStartValue=1;
    //行高
    configModel.rowHeight=255;
    configModel.hiddenNetWorkStausManager = YES;
    
    //移除返回顶部:(默认开启)
    configModel.removeBackToTopBtn=YES;
    
    configModel.refreshControlType = LTConfigModelRefreshControlTypeBoth;
    
    //配置完毕
    self.configModel=configModel;
}
-(void)testdealWithResponseData:(id)obj{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
