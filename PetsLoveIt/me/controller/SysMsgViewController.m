//
//  SysMsgViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/25.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SysMsgViewController.h"
#import "SysMsgCell.h"

@interface SysMsgViewController ()

@end

@implementation SysMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self setMsgRead];
}

- (void)setMsgRead{
    NSDictionary *params = @{@"uid":@"saveUserReadMsg",
                             @"msgType":@"1"
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SysMsgModel *model = [self.dataList objectAtIndex:indexPath.row];
    CGFloat height = [SysMsgCell heightForCell:model.msgcontent];
    
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (IOS_VERSION_8_OR_ABOVE) {
        tableView.layoutMargins = UIEdgeInsetsZero;
    }
    tableView.separatorInset = UIEdgeInsetsZero;
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
                           @"uid":@"getUserSystemMsg",
                           @"msgType":@"1"
                           };
    //模型类
        configModel.ModelClass=[SysMsgModel class];
    //    //cell类
        configModel.ViewForCellClass=[SysMsgCell class];
    //标识
    configModel.lid=NSStringFromClass(self.class);
    //pageName第几页的参数名
    configModel.pageName=@"startNum";
    
    //pageSizeName
    configModel.pageSizeName=@"limit";
    //pageSize
    configModel.pageSize = 15;
    //起始页码
    configModel.pageStartValue=0;
    //行高
    configModel.rowHeight=84;
    
    //移除返回顶部:(默认开启)
    configModel.removeBackToTopBtn=YES;
    
    configModel.refreshControlType = LTConfigModelRefreshControlTypeBoth;
//     NSLog(@"😊😊😊😊😊😊😊😊😊😊😊😊😊😊%@");
    //配置完毕
    self.configModel=configModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - delegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
