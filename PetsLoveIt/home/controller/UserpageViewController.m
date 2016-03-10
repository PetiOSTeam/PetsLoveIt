//
//  UserpageViewController.m
//  PetsLoveIt
//
//  Created by 123 on 16/1/5.
//  Copyright © 2016年 liubingyang. All rights reserved.
//
typedef NS_ENUM(NSUInteger, Modeltype) {
    pinglun = 0,
    shaidan,
    jingyan,
    baoliao
};
#import "UserpageViewController.h"
#import "UserpageModel.h"
#import "YYText.h"
#import "GoodsDetailViewController.h"
#import "CommentModel.h"
#import "MyCommentCell.h"
#import "BaoliaoView.h"
#import "CoreRefreshEntry.h"
#import "GoodsModel.h"
#import "GoodsCell.h"
#import "ShareOrderCell.h"
#import "ArticleTableCell.h"
@interface UserpageViewController ()<MyCommentCellDelegate,GoodsCellDelegate,BaoliaoViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userIocn;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic)  YYLabel *usersex;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *BlackButton;
@property (weak,nonatomic) UIView *pinglun1;
@property (weak,nonatomic) UIView *shaidan1;
@property (weak,nonatomic) UIView *jingyan1;
@property (weak,nonatomic) UIView *baoliao1;
@property (strong,nonatomic) UIView *menuview1;
@property (weak,nonatomic) UIView *pinglun2;
@property (weak,nonatomic) UIView *shaidan2;
@property (weak,nonatomic) UIView *jingyan2;
@property (weak,nonatomic) UIView *baoliao2;
@property (weak,nonatomic) UIView *menuview2;
/**
 *  产品详情页的模型
 */
@property (assign,nonatomic) Modeltype modeltype;
/**
 *  table的顶部
 */
@property (strong,nonatomic) UIView *mainview;
/**
 *  爆料页面的子菜单
 */
@property (strong,nonatomic) BaoliaoView *baoliaoview;


- (IBAction)blackButton;

@end

@implementation UserpageViewController
{
    int pageIndex;
}
- (BaoliaoView *)baoliaoview
{
    if (!_baoliaoview) {
        _baoliaoview = [[[NSBundle mainBundle]loadNibNamed:@"BaoliaoView" owner:self options:nil]firstObject];
        NSArray *numsarray = [NSArray arrayWithObjects:self.pageModel.m02Num,self.pageModel.m03Num,self.pageModel.m04Num,nil];
        _baoliaoview.detailsNums = numsarray;
        _baoliaoview.delegate = self;
    }
    return _baoliaoview;
}
- (void)viewDidLoad {
   
    [super viewDidLoad];
   
    self.tableView.frame = [UIScreen mainScreen].bounds;
    self.tableView.tableHeaderView = self.mainview;
    
    [self showNaviBarView];
   [self.view bringSubviewToFront:self.BlackButton];
    
    NSLog(@"%@",self.mainview);
    self.navigationBarView.hidden = YES;
    if ((self.uesrId)&&(!self.pageModel)) {
        [self getuesrDataWithuesrId:self.uesrId];
        
    }else{
        [self fillintheData];
    }
    
}
- (UIView *)mainview
{
    if (!_mainview) {
         self.userIocn.layer.cornerRadius = 30;
        YYLabel *usersex = [YYLabel new];
        self.usersex =usersex;
        self.usersex.font = [UIFont systemFontOfSize:12];
        self.usersex.numberOfLines = 0;
        self.usersex.frame = CGRectMake(8, self.username.bottom+6, mScreenWidth-16    ,20);
        [self.headerView addSubview:self.usersex];
        self.headerView.frame = CGRectMake(0, 0, mScreenWidth, self.headerView.height);
        self.mainview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, self.headerView.height+50)];
        [self.mainview addSubview:self.headerView];
        [self addMenuViewButton];

    }
    return _mainview;
}

#pragma mark 通过userId获取用户数据
- (void)getuesrDataWithuesrId:(NSString *)userId
{
    NSDictionary *params = @{
                             @"uid":@"getUserInfosWithnums",
                             @"userId":userId
                             };
    [APIOperation GET:@"getCoreSv.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            NSDictionary *jsondata = responseData[@"bean"];
            NSMutableDictionary *userdata = [NSMutableDictionary dictionaryWithDictionary:jsondata];
            UserpageModel *usermodel = [[UserpageModel alloc]initWithDictionary:userdata];
            self.pageModel = usermodel;
            [self fillintheData];
            
            
        }else{
            mAlertAPIErrorInfo(error);
            
        }}];
    

}
- (void)fillintheData
{
    [self.userIocn sd_setImageWithURL:[NSURL URLWithString: self.pageModel.userIcon] placeholderImage:kDefaultHeadImage];
    self.username.text = self.pageModel.nickName;
    NSDictionary *attrsDic = @{NSForegroundColorAttributeName:[UIColor whiteColor]
                               };
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:@"等级: " attributes:attrsDic];
    UIFont *font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *attachment = nil;
    int grade = [self.pageModel.userGrade intValue];
    int kingNum = grade/64;
    int sunNum = grade%64==0?0:grade%64/16;
    int moonNum = (grade%64==0||grade%16==0)?0:grade%16/4;
    int starNum = (grade%64==0||grade%16==0||grade%4==0)?0:grade%4;
    //如果等级为0，显示一个星星
    if (starNum == 0&&grade ==0) {
        starNum = 1;
    }
    for (int i=0; i<kingNum; i++) {
        UIImage *image = [UIImage imageNamed:@"kingIcon"];
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString: attachment];
    }
    for (int i=0; i<sunNum; i++) {
        UIImage *image = [UIImage imageNamed:@"sunIcon"];
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString: attachment];
    }
    for (int i=0; i<moonNum; i++) {
        UIImage *image = [UIImage imageNamed:@"moonIcon"];
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString: attachment];
    }
    for (int i=0; i<starNum; i++) {
        // UIImage attachment
        UIImage *image = [UIImage imageNamed:@"starIcon"];
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString: attachment];
    }
    
    [self.usersex setTextAlignment:NSTextAlignmentCenter];
    self.usersex.attributedText = text;
    CGSize size = CGSizeMake(mScreenWidth-16, 20);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
    self.usersex.width = layout.textBoundingSize.width;
    self.usersex.center  = CGPointMake(mScreenWidth/2, self.usersex.center.y);
    
    
    if (self.pageModel.commentnum) {
        [self setupnumLabelWithSuperview:self.pinglun1 andNum:self.pageModel.commentnum];
        [self setupnumLabelWithSuperview:self.pinglun2 andNum:self.pageModel.commentnum];
    }
    if (self.pageModel.experienceNum) {
        [self setupnumLabelWithSuperview:self.jingyan1 andNum:self.pageModel.experienceNum];
        [self setupnumLabelWithSuperview:self.jingyan2 andNum:self.pageModel.experienceNum];
    }
    if (self.pageModel.shareNum) {
        [self setupnumLabelWithSuperview:self.shaidan1 andNum:self.pageModel.shareNum];
        [self setupnumLabelWithSuperview:self.shaidan2 andNum:self.pageModel.shareNum];
    }
    if (self.pageModel.discloseNum) {
        [self setupnumLabelWithSuperview:self.baoliao1 andNum:self.pageModel.discloseNum];
        [self setupnumLabelWithSuperview:self.baoliao2 andNum:self.pageModel.discloseNum];
    }
    UILabel *label1 = [[self.pinglun1 subviews] firstObject];
    [label1 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label2 = [[self.pinglun1 subviews] lastObject];
    [label2 setTextColor:mRGBToColor(0xff4001)];
    [self setupOtherlabelColorWith:0];
    UILabel *label3 = [[self.pinglun2 subviews] firstObject];
    [label3 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label4 = [[self.pinglun2 subviews] lastObject];
    [label4 setTextColor:mRGBToColor(0xff4001)];
    [self setupOtherlabelColorWith:0];
    [self getpinglunData];

}
#pragma mark - 添加四个导航按钮
- (void)addMenuViewButton
{
    UIView *menuview = [[UIView alloc]initWithFrame:CGRectMake(0, self.headerView.bottom, mScreenWidth, 50)];
    
    self.menuview1 = menuview;
    self.menuview1.backgroundColor = [UIColor whiteColor];
    self.menuview1.userInteractionEnabled = YES;
    [self.menuview1 addBottomBorderWithColor:mRGBToColor(0xdcdcdc) andWidth:.5];
    UIView *pinglun = [self setupButtonWithName:@"评论" andNum:@"0" andaction:@selector(clickpinglun)];
    pinglun.left = 0;
    [self addRightBorderWithView:pinglun andColor:mRGBToColor(0xdcdcdc) andWidth:.5];
    self.pinglun1 = pinglun;
    UIView *shaidan = [self setupButtonWithName:@"晒单" andNum:@"0" andaction:@selector(clickshaidan)];
    shaidan.left = pinglun.right;
    [self addRightBorderWithView:shaidan andColor:mRGBToColor(0xdcdcdc) andWidth:.5];
    self.shaidan1 = shaidan;
    UIView *jingyan = [self setupButtonWithName:@"经验" andNum:@"0" andaction:@selector(clickjingyan)];
    jingyan.left = shaidan.right;
    [self addRightBorderWithView:jingyan andColor:mRGBToColor(0xdcdcdc) andWidth:.5];
    self.jingyan1 = jingyan;
    UIView *baoliao = [self setupButtonWithName:@"爆料" andNum:@"0" andaction:@selector(clickbaoliao)];
    baoliao.left = jingyan.right;
    self.baoliao1 = baoliao;
    [self.menuview1 addSubview:pinglun];
    [self.menuview1 addSubview:shaidan];
    [self.menuview1 addSubview:jingyan];
    [self.menuview1 addSubview:baoliao];
    [self.mainview addSubview:self.menuview1];
    
}
- (void)addRightBorderWithView:(UIView *)view andColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(view.frame.size.width - borderWidth, 10, borderWidth, 30);
    [view.layer addSublayer:border];
}
- (UIView *)setupButtonWithName:(NSString *)name andNum:(NSString *)num andaction:(SEL)sel
{
    UIView *middleview = [[UIView alloc]init];
    middleview.width = mScreenWidth/4;
    middleview.height = 50;
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, mScreenWidth/4, 12)];
    topLabel.text = name;
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 28, mScreenWidth/4, 12)];
    bottomLabel.text = num;
    [topLabel setTextAlignment:NSTextAlignmentCenter];
    [topLabel setFont:[UIFont systemFontOfSize:12]];
    [topLabel setTextColor:mRGBToColor(0x333333)];
    [bottomLabel setTextAlignment:NSTextAlignmentCenter];
    [bottomLabel setFont:[UIFont systemFontOfSize:12]];
    [bottomLabel setTextColor:mRGBToColor(0x333333)];

    
    [middleview addSubview:topLabel];
    [middleview addSubview:bottomLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:sel];
    [middleview addGestureRecognizer:tap];
    return middleview;
                           
}
// 设置按钮下方显示的数字
- (void)setupnumLabelWithSuperview:(UIView *)superView andNum:(NSString *)num
{
    UILabel *numlabel = [[superView subviews]lastObject];
    numlabel.text = num;
}
#pragma mark - 添加四个导航按钮的点击事件
- (void)clickpinglun
{
    self.modeltype = pinglun;
    UILabel *label1 = [[self.pinglun1 subviews] firstObject];
    [label1 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label2 = [[self.pinglun1 subviews] lastObject];
    [label2 setTextColor:mRGBToColor(0xff4001)];
    [self setupOtherlabelColorWith:0];
    UILabel *label3 = [[self.pinglun2 subviews] firstObject];
    [label3 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label4 = [[self.pinglun2 subviews] lastObject];
    [label4 setTextColor:mRGBToColor(0xff4001)];
    [self setupOtherlabelColorWith:0];
    [self getpinglunData];
    
    [self reloadDataDerectly];

    
    }
- (void)clickshaidan
{
    self.modeltype = shaidan;
    UILabel *label1 = [[self.shaidan1 subviews] firstObject];
    [label1 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label2 = [[self.shaidan1 subviews] lastObject];
    [label2 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label3 = [[self.shaidan2 subviews] firstObject];
    [label3 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label4 = [[self.shaidan2 subviews] lastObject];
    [label4 setTextColor:mRGBToColor(0xff4001)];
    [self setupOtherlabelColorWith:1];
    [self getshaidanData];
    
    [self reloadDataDerectly];

    
}
- (void)clickjingyan
{
    self.modeltype = jingyan;
    UILabel *label1 = [[self.jingyan1 subviews] firstObject];
    [label1 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label2 = [[self.jingyan1 subviews] lastObject];
    [label2 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label3 = [[self.jingyan2 subviews] firstObject];
    [label3 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label4 = [[self.jingyan2 subviews] lastObject];
    [label4 setTextColor:mRGBToColor(0xff4001)];
    [self setupOtherlabelColorWith:2];
    [self getjingyanData];
    
    [self reloadDataDerectly];
    
}
- (void)clickbaoliao
{
    self.modeltype = baoliao;
    UILabel *label1 = [[self.baoliao1 subviews] firstObject];
    [label1 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label2 = [[self.baoliao1 subviews] lastObject];
    [label2 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label3 = [[self.baoliao2 subviews] firstObject];
    [label3 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label4 = [[self.baoliao2 subviews] lastObject];
    [label4 setTextColor:mRGBToColor(0xff4001)];
    [self setupOtherlabelColorWith:3];
    [self getbaoliaoDataWithtype:@"m02"];
    [self reloadDataDerectly];
}
- (void)setupOtherlabelColorWith:(int)num
{
    for (int i = 0; i<4; i++) {
        if (i != num) {
            UIView *typeview1 = [self.menuview1 subviews][i];
            UILabel *label1 = [[typeview1 subviews] firstObject];
            [label1 setTextColor:mRGBToColor(0x333333)];
            UILabel *label2 = [[typeview1 subviews] lastObject];
            [label2 setTextColor:mRGBToColor(0x333333)];
            UIView *typeview2 = [self.menuview2 subviews][i];
            UILabel *label3 = [[typeview2 subviews] firstObject];
            [label3 setTextColor:mRGBToColor(0x333333)];
            UILabel *label4 = [[typeview2 subviews] lastObject];
            [label4 setTextColor:mRGBToColor(0x333333)];
        }
    }
    
}
#pragma mark -
#pragma mark - TableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.modeltype == baoliao) {
       
        return self.baoliaoview;
    }
    return nil;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.modeltype == baoliao) {
        return 50;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.modeltype != pinglun) {
        
        return self.configModel.rowHeight;
    }else{
    CommentModel *model = [self.dataList objectAtIndex:indexPath.row];
    CGFloat height = [MyCommentCell heightForSentCellWithObject:model];
    
    return height;
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.modeltype == baoliao) {

        GoodsCell * cell =(GoodsCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
       
     
        return cell;
    }else if (self.modeltype == shaidan){
        ShareOrderCell * cell =(ShareOrderCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
       
       
        return cell;
    }else if (self.modeltype == jingyan){
        ArticleTableCell * cell =(ArticleTableCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
    else{
    
    MyCommentCell * cell =(MyCommentCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.userIcon = self.pageModel.userIcon;
    
    cell.isSentComment = YES;
    cell.delegate = self;
    return cell;
    }
}

#pragma mark - TableViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 136) {
        
     self.navigationBarView.hidden = NO;
    }else{
     self.navigationBarView.hidden = YES;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.modeltype == shaidan) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        GoodsModel *model = [self.dataList objectAtIndex:indexPath.row];
        GoodsDetailViewController *vc = [GoodsDetailViewController new];
        vc.apptypename = model.apptypename;
        
        vc.goodsId = model.prodId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.modeltype == jingyan){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        GoodsDetailViewController *vc = [GoodsDetailViewController new];
   
        GoodsModel *model = [self.dataList objectAtIndex:indexPath.row];
        vc.goodsId = model.prodId;
        vc.apptypename = model.apptypename;
        [self.navigationController pushViewController:vc animated:YES];

        
    }else if (self.modeltype == baoliao){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        GoodsModel *model = [self.dataList objectAtIndex:indexPath.row];
        GoodsDetailViewController *vc = [GoodsDetailViewController new];
        vc.goodsId = model.prodId;
        vc.apptypename = model.apptypename;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
-(void)showNaviBarView{
    if (!self.navigationBarView) {
        self.navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 114)];
        
        self.navigationBarView.backgroundColor = mRGBToColor(0xff4401);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.height-0.5, mScreenWidth, 0.5)];
        [line setBackgroundColor:mRGBToColor(0xdcdcdc)];
        [self.navigationBarView addSubview:line];
        
        
        self.navBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, mScreenWidth-60, 24)];
        self.navBarTitleLabel.center = CGPointMake(self.navBarTitleLabel.center.x, 42);
        self.navBarTitleLabel.text = @"Ta的个人中心";
        [self.navBarTitleLabel setTextColor:[UIColor whiteColor]];
        [self.navBarTitleLabel setFont:[UIFont systemFontOfSize:18]];
        [self.navBarTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.navigationBarView addSubview:self.navBarTitleLabel];
        self.navigationBarView.userInteractionEnabled = YES;
        UIView *menuview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, mScreenWidth, 50)];
        menuview.backgroundColor = [UIColor whiteColor];
        menuview.userInteractionEnabled = YES;
        [menuview addBottomBorderWithColor:mRGBToColor(0xdcdcdc) andWidth:.5];
        UIView *pinglun = [self setupButtonWithName:@"评论" andNum:@"0" andaction:@selector(clickpinglun)];
        pinglun.left = 0;
        [self addRightBorderWithView:pinglun andColor:mRGBToColor(0xdcdcdc) andWidth:.5];
        self.pinglun2 = pinglun;
        UIView *shaidan = [self setupButtonWithName:@"晒单" andNum:@"0" andaction:@selector(clickshaidan)];
        shaidan.left = pinglun.right;
        [self addRightBorderWithView:shaidan andColor:mRGBToColor(0xdcdcdc) andWidth:.5];
        self.shaidan2 = shaidan;
        UIView *jingyan = [self setupButtonWithName:@"经验" andNum:@"0" andaction:@selector(clickjingyan)];
        jingyan.left = shaidan.right;
        [self addRightBorderWithView:jingyan andColor:mRGBToColor(0xdcdcdc) andWidth:.5];
        self.jingyan2 = jingyan;
        UIView *baoliao = [self setupButtonWithName:@"爆料" andNum:@"0" andaction:@selector(clickbaoliao)];
        baoliao.left = jingyan.right;
        self.baoliao2 = baoliao;
        [menuview addSubview:pinglun];
        [menuview addSubview:shaidan];
        [menuview addSubview:jingyan];
        [menuview addSubview:baoliao];
        self.menuview2 = menuview;
        [self.navigationBarView addSubview:menuview];
        }
    
    [self.view addSubview:self.navigationBarView];
}

#pragma mark - 获取用户详细数据
#pragma mark 1 获取评论
- (void)getpinglunData{
    LTConfigModel *configModel=[[LTConfigModel alloc] init];
    //url,分为公告和话题
    
    configModel.url=[NSString stringWithFormat:@"%@%@",kBaseURL,@"common.action"];
    
    //请求方式
    configModel.httpMethod=LTConfigModelHTTPMethodGET;
    configModel.params = @{
                           @"uid":@"getMyComment",
                           @"userId":self.uesrId
                           
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
    
//    configModel.refreshControlType = LTConfigModelRefreshControlTypeBottomRefreshOnly;
     configModel.CoreViewNetWorkStausManagerOffsetY = mScreenHeight*3/4;
    //配置完毕
    self.configModel=configModel;
    }
#pragma mark 2 获取爆料数据
- (void)getbaoliaoDataWithtype:(NSString *)apptype
{
    LTConfigModel *configModel=[[LTConfigModel alloc] init];
    //url,分为公告和话题
    
    configModel.url=[NSString stringWithFormat:@"%@%@",kBaseURL,@"getCoreSv.action"];
    
    //请求方式
    configModel.httpMethod=LTConfigModelHTTPMethodGET;
        configModel.params = @{
                               @"uid":@"queryShareProdByUid",
                               @"appType":apptype,
                               @"shareUId":self.uesrId
    
                               };
//    configModel.params = @{
//                           @"uid":@"getProductByType",
//                           @"appType":apptype
//                           };
    //模型类
    configModel.ModelClass=[GoodsModel class];
    //    //cell类
    configModel.ViewForCellClass=[GoodsCell class];
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
    configModel.rowHeight=110;
    
    //移除返回顶部:(默认开启)
    configModel.removeBackToTopBtn=YES;
    
    //    configModel.refreshControlType = LTConfigModelRefreshControlTypeBottomRefreshOnly;
    configModel.CoreViewNetWorkStausManagerOffsetY = mScreenHeight*3/4 + 65;
    //配置完毕
    self.configModel=configModel;
    
    
}
#pragma mark 3 获取晒单数据
- (void)getshaidanData{
    LTConfigModel *configModel=[[LTConfigModel alloc] init];
    //url,分为公告和话题
    
    configModel.url=[NSString stringWithFormat:@"%@%@",kBaseURL,@"getCoreSv.action"];
    
    //请求方式
    configModel.httpMethod=LTConfigModelHTTPMethodGET;
    configModel.params = @{
                           @"uid":@"querySunProdByUid",
                           @"shareUId":self.uesrId
                           };
    //    configModel.params = @{
    //                           @"uid":@"getProductByType",
    //                           @"appType":apptype
    //                           };
   
    //模型类
    configModel.ModelClass=[GoodsModel class];
    //    //cell类
    configModel.ViewForCellClass=[ShareOrderCell class];
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
    configModel.rowHeight=255;
    
    //移除返回顶部:(默认开启)
    configModel.removeBackToTopBtn=YES;
    
    //    configModel.refreshControlType = LTConfigModelRefreshControlTypeBottomRefreshOnly;
    configModel.CoreViewNetWorkStausManagerOffsetY = mScreenHeight*3/4;
    //配置完毕
    self.configModel=configModel;

}
#pragma mark 4 获取经验数据
- (void)getjingyanData{
   
    LTConfigModel *configModel=[[LTConfigModel alloc] init];
    //url,分为公告和话题
    
    configModel.url=[NSString stringWithFormat:@"%@%@",kBaseURL,@"getCoreSv.action"];
    
    //请求方式
    configModel.httpMethod=LTConfigModelHTTPMethodGET;
    configModel.params = @{
                           @"uid":@"queryExperienceProdByUid",
                           @"shareUId":self.uesrId
                           };
    //    configModel.params = @{
    //                           @"uid":@"getProductByType",
    //                           @"appType":apptype
    //                           };
    
    //模型类
    configModel.ModelClass=[GoodsModel class];
    //    //cell类
    configModel.ViewForCellClass=[ArticleTableCell class];
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
    configModel.rowHeight=136;
    
    //移除返回顶部:(默认开启)
    configModel.removeBackToTopBtn=YES;
    
    //    configModel.refreshControlType = LTConfigModelRefreshControlTypeBottomRefreshOnly;
    configModel.CoreViewNetWorkStausManagerOffsetY = mScreenHeight*3/4;
    //配置完毕
    self.configModel=configModel;
    
}

#pragma mark - MyCommentCellDelegate
-(void)showProductVC:(NSString *)proId{
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    vc.goodsId = proId;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - baoliaoview delegate
- (void)clickButtonWithtype:(NSString *)apptype
{
    [self getbaoliaoDataWithtype:apptype];
    [self reloadDataDerectly];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)blackButton {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
