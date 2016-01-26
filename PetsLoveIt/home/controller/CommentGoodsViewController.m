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
#import "DXPopover.h"
#import "LoginViewController.h"

#define kPlaceHolderTip @"请输入评论内容"

@interface CommentGoodsViewController ()<RichEditViewDelegate,DXMessageToolBarDelegate>
@property (nonatomic,strong) RichEditToolBar *editToolBar;
@end

@implementation CommentGoodsViewController{
    BOOL isReply;//纪录是回复评论
    UIView *moreMenuContainerView;
    UIButton *popButton1;
    UIButton *popButton2;
    UIButton *popButton3;
    UIButton *popButton4;
    UIButton *popButton5;
    UIButton *popButton6;
    
    CommentModel *selectedComment;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNaviBarView];
    
    // Do any additional setup after loading the view from its nib.
    self.navBarTitleLabel.text = @"所有评论";
    self.tableView.top = 64;
    
    [self prepareViewAndData];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshcommentcell) name:@"refreshcommentcell" object:nil];

}
- (void)refreshcommentcell
{
    [self.tableView reloadData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)refreshcommentcell:(NSNotificationCenter *)NotificationCenter
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)prepareViewAndData{
    
    
    [self config];
    self.tableView.height = mScreenHeight -mStatusBarHeight-mNavBarHeight- [RichEditToolBar defaultHeight];
    
    _editToolBar =[[RichEditToolBar alloc] initWithFrame:CGRectMake(0, mScreenHeight -mStatusBarHeight-mNavBarHeight- [RichEditToolBar defaultHeight], mScreenWidth, [RichEditToolBar defaultHeight]) hideFaceBtn:YES];
    _editToolBar.top = self.tableView.bottom;
    _editToolBar.userInteractionEnabled = YES;
    _editToolBar.delegate = self;
    _editToolBar.inputTextView.placeHolder = kPlaceHolderTip;
    [self.view addSubview:_editToolBar];
    _editToolBar.inputTextView.placeHolder = kPlaceHolderTip;
    
    
    moreMenuContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth-40+10, 50)];
    CGFloat popBtnWidth = (mScreenWidth-40)/6;
    popButton1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, popBtnWidth, 30)];
    [popButton1 addRightBorderWithColor:mRGBToColor(0x505050) andWidth:2];
    [popButton1 setTitle:@"回复" forState:UIControlStateNormal];
    [popButton1 addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
    [popButton1.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    popButton2 = [[UIButton alloc] initWithFrame:CGRectMake(popButton1.right, 10, popBtnWidth, 30)];
    [popButton2 addRightBorderWithColor:mRGBToColor(0x505050) andWidth:2];
    [popButton2 setTitle:@"@Ta" forState:UIControlStateNormal];
    [popButton2.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [popButton2 addTarget:self action:@selector(atAction) forControlEvents:UIControlEventTouchUpInside];
    
    popButton3 = [[UIButton alloc] initWithFrame:CGRectMake(popButton2.right, 10, popBtnWidth, 30)];
    [popButton3 addRightBorderWithColor:mRGBToColor(0x505050) andWidth:2];

    [popButton3 setTitle:@"复制" forState:UIControlStateNormal];
    [popButton3.titleLabel setFont:[UIFont systemFontOfSize:14]];

    [popButton3 addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    
    popButton4 = [[UIButton alloc] initWithFrame:CGRectMake(popButton3.right, 10, popBtnWidth, 30)];
    NSString *zancount = [[NSString alloc]initWithFormat:@"赞(%@)",selectedComment.praiseNum?selectedComment.praiseNum:@"0" ];
    [popButton4 setTitle:zancount forState:UIControlStateNormal];
    [popButton4 addRightBorderWithColor:mRGBToColor(0x505050) andWidth:2];

    [popButton4 addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
    [popButton4.titleLabel setFont:[UIFont systemFontOfSize:14]];

    popButton5 = [[UIButton alloc] initWithFrame:CGRectMake(popButton4.right, 10, popBtnWidth, 30)];
    NSString *caicount = [[NSString alloc]initWithFormat:@"踩(%@)",selectedComment.stepNum?selectedComment.stepNum:@"0"];
    [popButton5 setTitle:caicount forState:UIControlStateNormal];
    [popButton5.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [popButton5 addRightBorderWithColor:mRGBToColor(0x505050) andWidth:2];

    [popButton5 addTarget:self action:@selector(unlikeAction) forControlEvents:UIControlEventTouchUpInside];
    
    popButton6 = [[UIButton alloc] initWithFrame:CGRectMake(popButton5.right, 10, popBtnWidth, 30)];
    [popButton6 setTitle:@"举报" forState:UIControlStateNormal];
    [popButton6.titleLabel setFont:[UIFont systemFontOfSize:14]];

    [popButton6 addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
    
    [moreMenuContainerView addSubview:popButton1];
    [moreMenuContainerView addSubview:popButton2];
    [moreMenuContainerView addSubview:popButton3];
    [moreMenuContainerView addSubview:popButton4];
    [moreMenuContainerView addSubview:popButton5];
    [moreMenuContainerView addSubview:popButton6];
}
-(void)showLoginVC{
    LoginViewController *vc = [LoginViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)replyAction{
    isReply = YES;
    [[DXPopover sharedView] dismiss];
    self.editToolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"回复 \"%@\"",selectedComment.nickName];
    [self.editToolBar.inputTextView becomeFirstResponder];
    
}

-(void)atAction{
    
    [[DXPopover sharedView] dismiss];
    isReply = YES;
    [[DXPopover sharedView] dismiss];
    self.editToolBar.inputTextView.text = [NSString stringWithFormat:@"@%@ ",selectedComment.nickName];
    [self.editToolBar.inputTextView becomeFirstResponder];
}
-(void)copyAction{
    [[DXPopover sharedView] dismiss];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (selectedComment) {
        pasteboard.string = selectedComment.content;
    }
    [mAppUtils showHint:@"复制成功"];
}
-(void)likeAction{
    [[DXPopover sharedView] dismiss];
    if (![AppCache getUserInfo]) {
        //        if ([self.delegate respondsToSelector:@selector(showLoginVC)]) {
        //            [self.delegate showLoginVC];
        //        }
        [mAppUtils showHint:@"您还没有登陆"];
        return;
    }
    if( ([selectedComment.praiseFlag intValue] == 0)&&([selectedComment.stepFlag intValue] == 0) ){
        NSDictionary *params = @{
                                 @"uid": @"savePraiseInfo",
                                 @"objectId":selectedComment.commentId,
                                 @"type":@"1"
                                 };
        [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
            if (!error) {
                NSLog(@"点赞成功%@",responseData);
                [mAppUtils showHint:@"点赞成功"];
                selectedComment.praiseNum = [NSString stringWithFormat:@"%i",([selectedComment.praiseNum intValue]+1)];
                selectedComment.praiseFlag = @"1";
            }
        }];

        
    }else{
        [mAppUtils showHint:@"亲！您已经评价过了哦"];
        return;
       }
}
- (void)getUserISpraiseandnopraisenum
{
 
//    LocalUserInfoModelClass *userInfo = [AppCache getUserId];
    
    NSDictionary *params = @{
                             @"uid": @"getPraiseInfo",
                              @"objectId":selectedComment.commentId,
                             @"nowDay":@"1",
                             @"type":@"1",
                             @"userId":[AppCache getUserId]
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            NSDictionary *bean = responseData[@"bean"];
            NSLog(@"赞的数量  %@",bean);
            if (!bean.count){
                selectedComment.praiseFlag = @"0";
                           }else{
                selectedComment.praiseFlag = @"1";
                
                
            }
            
        }
    }];
    NSDictionary *paramscai = @{
                             @"uid": @"getPraiseInfo",
                             @"objectId":selectedComment.commentId,
                             @"nowDay":@"1",
                             @"type":@"11",
                             @"userId":[AppCache getUserId]
                             };
    [APIOperation GET:@"common.action" parameters:paramscai onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            NSDictionary *beancai = responseData[@"bean"];
             NSLog(@"踩的数量  %@",beancai);
            if (!beancai.count){
                selectedComment.stepFlag = @"0";
                
                
            }else{
                selectedComment.stepFlag = @"1";
                
            }
            
        }
    }];

    
    
}
-(void)unlikeAction{
    [[DXPopover sharedView] dismiss];
    if (![AppCache getUserInfo]) {
        //        if ([self.delegate respondsToSelector:@selector(showLoginVC)]) {
        //            [self.delegate showLoginVC];
        //        }
        [mAppUtils showHint:@"您还没有登陆"];
        return;
    }
    if (([selectedComment.praiseFlag intValue] == 0)&&([selectedComment.stepFlag intValue] == 0)) {
        NSDictionary *params = @{
                                 @"uid": @"savePraiseInfo",
                                 @"objectId":selectedComment.commentId,
                                 @"type":@"11"
                                 };
        [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
            if (!error) {
                [mAppUtils showHint:@"点踩成功"];
                selectedComment.stepNum = [NSString stringWithFormat:@"%i",([selectedComment.stepNum intValue]+1)];
                selectedComment.stepFlag = @"1";
            }
        }];

        
    }else{
        [mAppUtils showHint:@"亲！您已经评价过了哦"];
        return;
        }
}
-(void)reportAction{
    [[DXPopover sharedView] dismiss];
    [mAppUtils showHint:@"举报成功"];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    self.DidScrollNum++;
//    if (self.DidScrollNum >=2) {
//        self.editToolBar.userInteractionEnabled = YES;
//        [self.view endEditing:YES];
//    }
//    
//}
#pragma mark - 发表评论
-(void)didSendText:(NSString *)text{
    if (![AppCache getUserInfo]) {
        [self showLoginVC];
        return;
    }
    [self.view endEditing:YES];
    [self.editToolBar.inputTextView resignFirstResponder];
    self.editToolBar.inputTextView.placeHolder = kPlaceHolderTip;
    if ([text length]==0) {
        mAlertView(@"提示", @"评论内容不能为空");
        return;
    }
    
    NSDictionary *params = @{
                             @"uid": @"saveCommentInfo",
                             @"productId":self.goodsId,
                             @"userId":[AppCache getUserId],
                             @"content":text
                             };
    
    if (isReply && selectedComment) {
        params = @{
                   @"uid": @"saveCommentInfo",
                   @"productId":self.goodsId,
                   @"parentId":selectedComment.commentId,
                   @"userId":[AppCache getUserId],
                   @"content":text
                   };
    }
    [APIOperation POST:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        isReply = NO;
        if (!error) {
            self.page = 1;
            self.dataList = nil;
           // [self reloadData];
            [self reloadDataWithheaderViewStateRefresh];
        }else{
            mAlertAPIErrorInfo(error);
        }
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    [self.editToolBar.inputTextView resignFirstResponder];
    self.editToolBar.inputTextView.placeHolder = kPlaceHolderTip;
    CommentCell *cell =(CommentCell *) [tableView cellForRowAtIndexPath:indexPath];
    selectedComment = [self.dataList objectAtIndex:indexPath.row];
    [DXPopover showAtView:cell  atViewOffsetX:cell.center.x atViewOffsetY:cell.top+cell.commentLabel.top popoverPostion:DXPopoverPositionDown withContentView:moreMenuContainerView inView:self.tableView ];
    [self getUserISpraiseandnopraisenum];
    NSString *zancount = [[NSString alloc]initWithFormat:@"赞(%@)",selectedComment.praiseNum?selectedComment.praiseNum:@"0" ];
    [popButton4 setTitle:zancount forState:UIControlStateNormal];
    NSString *caicount = [[NSString alloc]initWithFormat:@"踩(%@)",selectedComment.stepNum?selectedComment.stepNum:@"0"];
    [popButton5 setTitle:caicount forState:UIControlStateNormal];

    
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
   //http:61.155.210.60:9090/petweb/actions/common.action?uid=getCommentByProductNew&limit=5&productId=&startNum=0
    //请求方式
    configModel.httpMethod=LTConfigModelHTTPMethodGET;
    configModel.params = @{
                           @"uid":@"getCommentByProductNew",
                           @"productId":self.goodsId,
                          };
    //模型类
    configModel.ModelClass=[CommentModel class];
    //cell类
    configModel.ViewForCellClass=[CommentCell class];
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
    configModel.rowHeight=103;
    configModel.hiddenNetWorkStausManager = NO;
    
  
    
    //移除返回顶部:(默认开启)
    configModel.removeBackToTopBtn=YES;
    
    configModel.refreshControlType = LTConfigModelRefreshControlTypeBoth;
    
    //配置完毕
    self.configModel=configModel;
}

#pragma mark editToolBarDelegate
- (void)didChangeFrameToHeight:(CGFloat)toHeight keyboardInfo:(NSDictionary *)userInfo
{
    NSInteger cuver = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationCurve:cuver];
    [UIView setAnimationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    CGRect rect = self.tableView.frame;
    rect.size.height = self.view.frame.size.height - toHeight-mNavBarHeight-mStatusBarHeight;
    self.tableView.frame = rect;
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
