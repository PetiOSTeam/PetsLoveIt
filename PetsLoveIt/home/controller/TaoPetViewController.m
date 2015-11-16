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

@interface TaoPetViewController ()
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
}

-(void)viewWillAppear:(BOOL)animated{
    self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight-self.tabBarController.tabBar.height - CorePagesBarViewH - 5;
}

- (void)prepareViewsAndData{
    
    [self config];
    [self.view setBackgroundColor:mRGBToColor(0xf5f5f5)];
    self.tableView.top = 5;
    self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight-self.tabBarController.tabBar.height - CorePagesBarViewH - 5;
    dataArray = [NSMutableArray new];
    for (int i =0 ; i<20; i++) {
        GoodsModel *good = [GoodsModel new];
        good.imageUrl = @"http://y.zdmimg.com/201510/19/5624cb70a9728.jpeg_d320.jpg";
        good.name = @"天猫狗粮优惠活动开始了";
        good.desc = @"双十一天猫优惠活动开始了，小样儿快行动吧...";
        good.prodDetail = @"100元包邮";
        good.commentNum = @"10";
        good.favorNum = @"80%";
        good.dateDesc = @"11-11";
        [dataArray addObject:good];
    }
    self.dataList = dataArray;
    [self.tableView reloadData];
    
    
}


-(UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 31)];
    }
    return _tableHeaderView;
}


-(void)testdealWithResponseData:(id)obj{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
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
    configModel.ModelClass=[GoodsModel class];
    //cell类
    configModel.ViewForCellClass=[GoodsCell class];
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
    configModel.rowHeight=110;
    configModel.hiddenNetWorkStausManager = YES;
    
    //移除返回顶部:(默认开启)
    configModel.removeBackToTopBtn=NO;
    
    configModel.refreshControlType = LTConfigModelRefreshControlTypeBoth;
    
    //配置完毕
    self.configModel=configModel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
