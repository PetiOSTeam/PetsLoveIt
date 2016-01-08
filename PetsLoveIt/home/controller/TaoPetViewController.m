//
//  TaoPetViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/9.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "TaoPetViewController.h"
#import "GoodsModel.h"
#import "GoodsCell.h"
#import "GoodsDetailViewController.h"

@interface TaoPetViewController ()<GoodsCellDelegate>
@property (nonatomic,strong) UIView *tableHeaderView;
@property (nonatomic,strong) UIButton *cityButton;
@property (nonatomic,strong) UIButton *regionButton;
@end

@implementation TaoPetViewController
{
    NSMutableArray *dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareViewsAndData];
     self.tableView.top = 5;
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.isCollect) {
        self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight- CorePagesBarViewH;
        

    }else{
        self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight-self.tabBarController.tabBar.height - CorePagesBarViewH - 5;
        
    }
    
}

- (void)prepareViewsAndData{
    
    [self config];
    [self.view setBackgroundColor:mRGBToColor(0xf5f5f5)];
    if (!self.isCollect) {
        self.tableView.tableHeaderView = self.tableHeaderView;
    }
//
    self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight-self.tabBarController.tabBar.height - CorePagesBarViewH - 5;
    
}


-(UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 31)];
        _tableHeaderView.backgroundColor = mRGBToColor(0xffffff);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 31)];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setTextColor:mRGBToColor(0xff4401)];
        [label setText:@"目前仅支持上海地区"];
        _tableHeaderView.layer.borderColor = kLayerBorderColor.CGColor;
        _tableHeaderView.layer.borderWidth = kLayerBorderWidth;
        [_tableHeaderView addSubview:label];
    }
    return _tableHeaderView;
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
    GoodsCell * cell =(GoodsCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
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
                           @"appType":@"m04"
                           };
    if (self.isCollect) {
        configModel.params = @{
                               @"uid":@"getUsercollect",
                               @"appType":@"m04"
                               };
    }
    //模型类
    configModel.ModelClass=[GoodsModel class];
    //cell类
    configModel.ViewForCellClass=[GoodsCell class];
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
    configModel.rowHeight=110;
    configModel.hiddenNetWorkStausManager = NO;
    
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
