//
//  ReceivedCommentViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/24.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ReceivedCommentViewController.h"

@interface ReceivedCommentViewController ()

@end

@implementation ReceivedCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareViewAndData];
    
}

- (void)prepareViewAndData{
    [self config];
    self.view.width = mScreenWidth;
    self.tableView.width = mScreenWidth;
}

/**
 *  模型配置
 */
-(void)config{
    
    LTConfigModel *configModel=[[LTConfigModel alloc] init];
    //url,分为公告和话题
    
    configModel.url=[NSString stringWithFormat:@"%@%@",kBaseURL,testUrl];
    
    //请求方式
    configModel.httpMethod=LTConfigModelHTTPMethodGET;
    configModel.params = @{
                           @"udid":@"403",
                           @"sort_id":@"1"
                           };
    //模型类
//    configModel.ModelClass=[GoodsModel class];
//    //cell类
//    configModel.ViewForCellClass=[GoodsCell class];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
