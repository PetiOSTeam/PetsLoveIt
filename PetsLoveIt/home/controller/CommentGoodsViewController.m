//
//  CommentGoodsViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CommentGoodsViewController.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "RichEditView.h"


@interface CommentGoodsViewController ()<RichEditViewDelegate,DXMessageToolBarDelegate>
@property (nonatomic,strong) RichEditToolBar *editToolBar;

@end

@implementation CommentGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"所有评论";
    self.tableView.top = 64;
    
    self.tableView.height = mScreenHeight -mStatusBarHeight-mNavBarHeight- [RichEditToolBar defaultHeight];
    [self config];

    _editToolBar =[[RichEditToolBar alloc] initWithFrame:CGRectMake(0, mScreenHeight -mStatusBarHeight-mNavBarHeight- [RichEditToolBar defaultHeight], mScreenWidth, [RichEditToolBar defaultHeight]) hideInputView:NO];
    _editToolBar.top = self.tableView.bottom;
    _editToolBar.userInteractionEnabled = YES;
    _editToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    _editToolBar.delegate = self;
    _editToolBar.inputTextView.placeHolder = @"请输入评论内容";
    [self.view addSubview:_editToolBar];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = [self.dataList objectAtIndex:indexPath.row];
    CGFloat height = [CommentCell heightForCellWithObject:model];
    
    return height;
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
                           @"uid":@"getCommentByProduct",
                           @"productId":self.goodsId,
                           @"userId":[AppCache getUserId]
                           };
    //模型类
    configModel.ModelClass=[CommentModel class];
    //cell类
    configModel.ViewForCellClass=[CommentCell class];
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
    configModel.rowHeight=210;
    configModel.hiddenNetWorkStausManager = YES;
    
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
