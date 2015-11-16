//
//  NewsViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/8.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "NewsViewController.h"
#import "ArticleModel.h"
#import "ArticleTableCell.h"
#import "GoodsDetailViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

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
        ArticleModel *model = [ArticleModel new];
        model.imageUrl = @"http://a.zdmimg.com/201511/07/563d7a093f6d36649.png_d320.jpg";
        model.name = @"实时心率监测：小米手环光感版将于双11上市 定价99元";
        model.title = @"京东精选";
        model.content = @"还记得去年小米发布的那款79元的智能手环一下将高高在上的智能可穿戴设备拉低到了百元以下，这一举动也让小米一举攻占智能手环市场。而从去年开始已经有不少国内厂商推出带有光学心率计的智能手环和手表，由此可以推测下一代小米手环也将会集成心率监测功能。果不其然小米今天宣布将在双11当天在小米官网和天猫旗舰店开卖全新的小米手环光感版，定价99元";
        model.commentNum = @"10";
        model.favorNum = @"80%";
        model.dateDesc = @"11-11";
        [dataArray addObject:model];
    }
    self.dataList = dataArray;
    [self.tableView reloadData];
    
    
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
    configModel.ModelClass=[ArticleModel class];
    //cell类
    configModel.ViewForCellClass=[ArticleTableCell class];
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
    configModel.rowHeight=136;
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
