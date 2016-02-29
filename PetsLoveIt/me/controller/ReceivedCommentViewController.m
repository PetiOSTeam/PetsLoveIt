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
#import "MoreMenuView.h"
#import "RichEditView.h"
#import "DXPopover.h"
#import "MoreMenuView.h"
#define kPlaceHolderTip @"请输入评论内容"

@interface ReceivedCommentViewController ()<MyCommentCellDelegate,UITabBarDelegate,RichEditViewDelegate,DXMessageToolBarDelegate>
@property (nonatomic,strong) RichEditToolBar *editToolBar;
@property (nonatomic,strong) MoreMenuView *menuview;

@end

@implementation ReceivedCommentViewController{
    CommentModel *selectedComment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareViewAndData];
    self.tableView.delegate = self;
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        [self setCommentRead];
    }
    
}
- (void)setCommentRead{
    NSDictionary *params = @{@"uid":@"saveUserReadComment",
                            };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            
        }
    }];
}
- (void)prepareViewAndData{
    [self config];
    self.tableView.top = 5;
     self.view.backgroundColor = mRGBColor(245, 245, 245);
    self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight- CorePagesBarViewH - 5 ;

    
    _editToolBar =[[RichEditToolBar alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, mScreenWidth, [RichEditToolBar defaultHeight]) hideFaceBtn:NO];
    _editToolBar.top = self.tableView.bottom;
    _editToolBar.userInteractionEnabled = YES;
    _editToolBar.delegate = self;
    _editToolBar.inputTextView.placeHolder = kPlaceHolderTip;
    [self.view addSubview:_editToolBar];
    _editToolBar.inputTextView.placeHolder = kPlaceHolderTip;
     _menuview = [[MoreMenuView alloc]init];
    _menuview.editToolBar = _editToolBar;
//    _menuview.hidden = YES;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        _editToolBar.top = self.tableView.bottom;
    } completion:^(BOOL finished) {
    }];

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
   

//    MoreMenuView *tempmenuview = self.menuview;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        _editToolBar.top = self.tableView.bottom;
    } completion:^(BOOL finished) {
    }];

    [self.editToolBar.inputTextView resignFirstResponder];
    self.editToolBar.inputTextView.placeHolder = kPlaceHolderTip;
    MyCommentCell *cell =(MyCommentCell *) [tableView cellForRowAtIndexPath:indexPath];
    selectedComment = [self.dataList objectAtIndex:indexPath.row];
    _menuview.selectedComment = selectedComment;
    [DXPopover showAtView:cell  atViewOffsetX:cell.center.x atViewOffsetY:cell.top+cell.otherCommentLabel.top popoverPostion:DXPopoverPositionDown withContentView:_menuview inView:self.tableView ];
    
}
#pragma mark - 发表评论,该页面只有回复
-(void)didSendText:(NSString *)text{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        _editToolBar.top = self.tableView.bottom;
    } completion:^(BOOL finished) {
    }];

    [self.editToolBar.inputTextView resignFirstResponder];
    self.editToolBar.inputTextView.placeHolder = kPlaceHolderTip;
    
    if ([text length]==0) {
        mAlertView(@"提示", @"评论内容不能为空");
        return;
    }
    if (self.menuview.isAt == YES) {
        text = [NSString stringWithFormat:@"@%@ %@",selectedComment.nickName==nil?selectedComment.otherNickName:selectedComment.nickName,text];
    }
     
    NSDictionary *params = @{
                   @"uid": @"saveCommentInfo",
                   @"productId":selectedComment.productId,
                   @"parentId":selectedComment.commentId,
                   @"userId":[AppCache getUserId],
                   @"content":text
                   };
    
    [APIOperation POST:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
       self.menuview.isReply = NO;
        self.menuview.isAt = NO;
        if (!error) {
            self.page = 1;
            
            [self reloadDataWithheaderViewStateRefresh];
        }else{
            self.menuview.isAt = NO;
//            mAlertAPIErrorInfo(error);
        }
    }];
    
}

#pragma mark editToolBarDelegate
- (void)didChangeFrameToHeight:(CGFloat)toHeight keyboardInfo:(NSDictionary *)userInfo{
    NSInteger cuver = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationCurve:cuver];
    [UIView setAnimationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    self.editToolBar.top = self.tableView.bottom - toHeight ;

//    NSLog(@"toHeight%f",toHeight);
    [UIView commitAnimations];

}
-(void)dealWithResponseData:(id)obj{
    if ([[[obj objectForKey:@"rows"] objectForKey:@"rows"] count]>0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.scrollView addTopBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
        });
        
    }
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
