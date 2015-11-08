//
//  NewsListTVC.m
//  CorePagesView
//
//  Created by junfrost on 15/5/26.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NewsListTVC.h"
#import "NewsListModel.h"
#import "NewsListCell.h"
//#import "TopicDetailViewController.h"

@interface NewsListTVC ()
@property (nonatomic,strong) UIView *topNewView;
@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) UILabel *topTitleLabel;
@property (nonatomic,strong) UIView *titleContainerView;
@end

@implementation NewsListTVC{
    NewsListModel *topArticle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //模型配置
    //[self config];
    self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight-44;
}

-(UIView *)topNewView{
    if (!_topNewView) {
        _topNewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 169)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnTopNew)];
        [_topNewView addGestureRecognizer:tap];
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 169)];
        [_topNewView addSubview:_topImageView];
    
        _titleContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 134, mScreenWidth, 35)];
        [_titleContainerView setBackgroundColor:mRGBToColor(0x61564d)];
        _titleContainerView.alpha =0.5;
        
        [_topNewView addSubview:_titleContainerView];
    }
    return _topNewView;
}

-(UILabel *)topTitleLabel{
    if (!_topTitleLabel) {
        _topTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 134, mScreenWidth-20, 35)];
        [_topTitleLabel setTextColor:[UIColor whiteColor]];
        [_topTitleLabel setFont:[UIFont systemFontOfSize:13]];
        [_topNewView addSubview:_topTitleLabel];
    }
    return _topTitleLabel;
}

- (void)tapOnTopNew{
    if (!topArticle) {
        return;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsListModel *newsModel = self.dataList[indexPath.row];
}

-(void)dealWithResponseData:(id)obj{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *articleTopJsonStr = obj[@"data"][@"data_article_top"];
        if ([articleTopJsonStr length]>0) {
            NSData *jsonData = [articleTopJsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            topArticle = [NewsListModel objectWithKeyValues:jsonDict];
            self.tableView.tableHeaderView = self.topNewView;
            self.topTitleLabel.text = topArticle.title;
            NSLog(@"%f,%@",self.topTitleLabel.top,topArticle.title);
//            [self.topImageView sd_setImageWithURL:[NSURL URLWithString:topArticle.img] placeholderImage:kDefaultAppImage];
            
        }
    });
    
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
//    configModel.params = @{
//                           @"udid":[AppCache getServerUDID],
//                           @"sort_id":_topic.sort_id
//                           };
    //模型类
    configModel.ModelClass=[NewsListModel class];
    //cell类
    configModel.ViewForCellClass=[NewsListCell class];
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
    configModel.rowHeight=67;
    
    //移除返回顶部:(默认开启)
    configModel.removeBackToTopBtn=NO;
    
    configModel.refreshControlType = LTConfigModelRefreshControlTypeBoth;
    
    //配置完毕
    self.configModel=configModel;
}


@end
