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
@interface ShareOrderViewController ()<GoodsCellDelegate> {
    NSMutableArray *dataArray;
}

@end

@implementation ShareOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tableView.top = 5;
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

#pragma mark - GoodsCell delegate
-(void)selectCollect:(NSString *)proId isSelect:(BOOL)isSelect{
    if (isSelect) {
        if (![self.seletedArray containsObject:proId]) {
            [self.seletedArray addObject:proId];
        }
    }else{
        [self.seletedArray removeObject:proId];
    }
    BOOL isAllSelect = NO;
    if (self.seletedArray.count == self.dataList.count) {
        isAllSelect = YES;
    }
    if ([self.delegate respondsToSelector:@selector(selectAllCollect:)]) {
        [self.delegate selectAllCollect:isAllSelect];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShareOrderCell * cell =(ShareOrderCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell showSelectView:self.showSelect];
    GoodsModel *goods = [self.dataList objectAtIndex:indexPath.row];
    cell.delegate = self;
    if ([self.seletedArray containsObject:goods.collectId]) {
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsModel *model = [self.dataList objectAtIndex:indexPath.row];
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
   
    vc.apptypename = TypeShareOrder;
   
    
    vc.goodsId = model.prodId;
    NSLog(@"%@",model);
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealWithResponseData:(id)obj{
    
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
