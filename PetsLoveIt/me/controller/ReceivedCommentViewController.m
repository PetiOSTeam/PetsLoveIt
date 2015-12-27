//
//  ReceivedCommentViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/24.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ReceivedCommentViewController.h"
#import "CommentModel.h"
#import "MyCommentCell.h"
#import "GoodsDetailViewController.h"

@interface ReceivedCommentViewController ()<MyCommentCellDelegate,UITabBarDelegate>

@end

@implementation ReceivedCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareViewAndData];
    self.tableView.delegate = self;
}

- (void)prepareViewAndData{
    [self config];
    self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight- CorePagesBarViewH;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCommentCell * cell =(MyCommentCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = [self.dataList objectAtIndex:indexPath.row];
    CGFloat height = [MyCommentCell heightForCellWithObject:model];
    
    return height;
}

-(void)showProductVC:(NSString *)proId{
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    vc.goodsId = proId;
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
                           @"uid":@"getTomeComment",
                           @"userToken":[AppCache getToken],
                           @"userId":[AppCache getUserId]
                        
                           };
    //模型类
    configModel.ModelClass=[CommentModel class];
//    //cell类
    configModel.ViewForCellClass=[MyCommentCell class];
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
    configModel.rowHeight=110;
    
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
# pragma mark - tableview代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"1111");
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
