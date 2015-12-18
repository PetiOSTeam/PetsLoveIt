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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsModel *model = [self.dataList objectAtIndex:indexPath.row];
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    vc.pageType = RelatedPersonType;
    vc.goodsId = model.prodId;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  模型配置
 */
-(void)config{
    
    LTConfigModel *configModel=[[LTConfigModel alloc] init];
    //url,分为公告和话题
    
    configModel.url=[NSString stringWithFormat:@"%@%@",kBaseURL,@"getCoreSv.action"];
    
    //请求方式
    configModel.httpMethod=LTConfigModelHTTPMethodGET;
    configModel.params = @{
                           @"uid":@"getProductByType",
                           @"appType":@"m05"
                           };
    if (self.isCollect) {
        configModel.params = @{
                               @"uid":@"getUsercollect",
                               @"appType":@"m05"
                               };
    }
    configModel.hiddenNetWorkStausManager = NO;

    if (self.isMyArticle) {
        configModel.params = @{
                               @"uid":@"getProductByType",
                               @"appType":@""
                               };
        configModel.hiddenNetWorkStausManager = NO;

    }
    
    //模型类
    configModel.ModelClass=[GoodsModel class];
    //cell类
    configModel.ViewForCellClass=[ShareOrderCell class];
    //标识
    configModel.lid=NSStringFromClass(self.class);
    //pageName第几页的参数名
    configModel.pageName=@"startNum";
    
    //pageSizeName
    configModel.pageSizeName=@"limit";
    //pageSize
    configModel.pageSize = 10;
    //起始页码
    configModel.pageStartValue=0;
    //行高
    configModel.rowHeight=255;
    
    //移除返回顶部:(默认开启)
    configModel.removeBackToTopBtn=YES;
    
    configModel.refreshControlType = LTConfigModelRefreshControlTypeBoth;
    
    //配置完毕
    self.configModel=configModel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
