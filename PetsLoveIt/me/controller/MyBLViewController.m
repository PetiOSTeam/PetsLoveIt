//
//  MyBLViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/25.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MyBLViewController.h"
#import "BLLinkViewController.h"
#import "MyBlCell.h"
#import "BLModel.h"

@interface MyBLViewController ()
@property (nonatomic, strong)  UIButton *blBtn;

@end

@implementation MyBLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareViewAndData];
}

-(UIButton *)blBtn{
    if (!_blBtn) {
        _blBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_blBtn setBackgroundColor:mRGBToColor(0xff4401)];
        [_blBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_blBtn setTitle:@"我要爆料" forState:UIControlStateNormal];
        [_blBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _blBtn.frame = CGRectMake(50, mScreenHeight-68, mScreenWidth-100, 48);
        _blBtn.layer.cornerRadius = 25;
        [_blBtn addTarget:self action:@selector(blAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _blBtn;
}

-(void)viewWillAppear:(BOOL)animated{
    self.tableView.top = mNavBarHeight + mStatusBarHeight;
    self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight - 78;
    [self.view bringSubviewToFront:self.blBtn];

}

- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"我的爆料";
    [self.view addSubview:self.blBtn];
    [self config];
}
- (void)blAction:(id)sender {
    BLLinkViewController *vc = [BLLinkViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  模型配置
 */
-(void)config{
    
    LTConfigModel *configModel=[[LTConfigModel alloc] init];
    //url,分为公告和话题
    
    configModel.url=[NSString stringWithFormat:@"%@%@",kBaseURL,@"common.action"];
    
    //请求方式
    configModel.httpMethod=LTConfigModelHTTPMethodGET;
    configModel.params = @{
                           @"uid":@"getShareInfoList",
                           @"type":@"1",
                           @"userId":[AppCache getUserId]
                           };
    //模型类
        configModel.ModelClass=[BLModel class];
    //    //cell类
        configModel.ViewForCellClass=[MyBlCell class];
    //标识
    configModel.lid=NSStringFromClass(self.class);
    //pageName第几页的参数名
    configModel.pageName=@"pageIndex";
    
    //pageSizeName
    configModel.pageSizeName=@"pageSize";
    //pageSize
    configModel.pageSize = 10;
    //起始页码
    configModel.pageStartValue=1;
    //行高
    configModel.rowHeight=224;
    configModel.CoreViewNetWorkStausManagerOffsetY = 64;
    
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
