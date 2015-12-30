//
//  ExperienceViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/8.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ExperienceViewController.h"
#import "ArticleModel.h"
#import "ArticleTableCell.h"
#import "GoodsDetailViewController.h"

@interface ExperienceViewController ()<GoodsCellDelegate>

@end

@implementation ExperienceViewController{
        NSMutableArray *dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareViewsAndData];
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.isCollect || self.isMyArticle) {
        self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight- CorePagesBarViewH -5 ;
    }else{
        self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight-self.tabBarController.tabBar.height - CorePagesBarViewH - 5;
    }
}

- (void)prepareViewsAndData{
    
    [self config];
    [self.view setBackgroundColor:mRGBToColor(0xf5f5f5)];
    self.tableView.top = 5;
    
    if (self.isCollect || self.isMyArticle) {
        self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight- CorePagesBarViewH - 5;
    }else{
        self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight-self.tabBarController.tabBar.height - CorePagesBarViewH - 5;
    }
    
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
    ArticleTableCell * cell =(ArticleTableCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
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
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    vc.pageType = RelatedPersonType;
    GoodsModel *model = [self.dataList objectAtIndex:indexPath.row];
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
    configModel.isTaopet = NO;
    //请求方式
    configModel.httpMethod=LTConfigModelHTTPMethodGET;
    configModel.params = @{
                           @"uid":@"getProductByType",
                           @"appType":@"m06"
                           };
    configModel.hiddenNetWorkStausManager = NO;
    if (self.isMyArticle) {
        configModel.params = @{
                               @"uid":@"getProductByType",
                               @"appType":@""
                               };
        configModel.hiddenNetWorkStausManager = NO;
        
    }
    if (self.isCollect) {
        configModel.params = @{
                               @"uid":@"getUsercollect",
                               @"appType":@"m06"
                               };
    }
    //模型类
    configModel.ModelClass=[GoodsModel class];
    //cell类
    configModel.ViewForCellClass=[ArticleTableCell class];
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
    configModel.rowHeight=136;
    
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
