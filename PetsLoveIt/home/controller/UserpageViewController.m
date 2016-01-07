//
//  UserpageViewController.m
//  PetsLoveIt
//
//  Created by 123 on 16/1/5.
//  Copyright © 2016年 kongjun. All rights reserved.
//
typedef NS_ENUM(NSUInteger, Modeltype) {
    pinglun = 1,
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
#import "BaoliaoTableViewCell.h"
#import "MJRefresh.h"
@interface UserpageViewController ()<UITableViewDataSource,UITableViewDelegate,MyCommentCellDelegate>
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
@property (weak,nonatomic) UITableView *tableview;
@property (assign,nonatomic) Modeltype modeltype;
@property (strong,nonatomic) NSObject *DataModel;
@property (strong,nonatomic) NSMutableArray *DataModelArray;
@property (strong,nonatomic) UserpageModel *pageModel;




- (IBAction)blackButton;

@end

@implementation UserpageViewController
{
    int pageIndex;
}
- (void)viewDidLoad {
    pageIndex = 1;
    self.userIocn.layer.cornerRadius = 30;
    [super viewDidLoad];
    YYLabel *usersex = [YYLabel new];
    self.usersex =usersex;
    self.usersex.font = [UIFont systemFontOfSize:12];
    self.usersex.textColor = [UIColor whiteColor];
    self.usersex.userInteractionEnabled = YES;
    self.usersex.numberOfLines = 0;
    [self.usersex setTextAlignment:NSTextAlignmentCenter];
    self.usersex.frame = CGRectMake(8, self.username.bottom+6, mScreenWidth-16    ,20);
    [self.headerView addSubview:self.usersex];
    UITableView *tableview = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    [self.view addSubview:tableview];
    [self showNaviBarView];
   [self.view bringSubviewToFront:self.BlackButton];
    self.tableview = tableview;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.tableHeaderView = self.headerView;
    self.tableview.showsVerticalScrollIndicator = NO;//隐藏垂直滚动条
    [self.tableview addFooterWithCallback:^{
        [self footerRereshing];
    }];
    
    
    self.navigationBarView.hidden = YES;
    if (self.uesrId) {
        [self getuesrDataWithuesrId:self.uesrId];
        
    }
    
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
            [self.userIocn sd_setImageWithURL:[NSURL URLWithString:usermodel.userIcon] placeholderImage:kDefaultHeadImage];
            self.username.text = usermodel.nickName;
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"等级: "];
            UIFont *font = [UIFont systemFontOfSize:12];
            NSMutableAttributedString *attachment = nil;
            int grade = [usermodel.userGrade intValue];
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
            
            
            if (usermodel.commentnum) {
                [self setupnumLabelWithSuperview:self.pinglun1 andNum:usermodel.commentnum];
                [self setupnumLabelWithSuperview:self.pinglun2 andNum:usermodel.commentnum];
            }
            if (usermodel.experienceNum) {
                [self setupnumLabelWithSuperview:self.jingyan1 andNum:usermodel.experienceNum];
                [self setupnumLabelWithSuperview:self.jingyan2 andNum:usermodel.experienceNum];
            }
            if (usermodel.shareNum) {
                [self setupnumLabelWithSuperview:self.shaidan1 andNum:usermodel.shareNum];
                [self setupnumLabelWithSuperview:self.shaidan2 andNum:usermodel.shareNum];
            }
            if (usermodel.discloseNum) {
                [self setupnumLabelWithSuperview:self.baoliao1 andNum:usermodel.discloseNum];
                [self setupnumLabelWithSuperview:self.baoliao2 andNum:usermodel.discloseNum];
            }
            [self clickpinglun];
            
        }else{
            mAlertAPIErrorInfo(error);
            
        }}];
    

}
#pragma mark - 添加四个导航按钮
- (void)addMenuViewButtonWith
{
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
   
    
}
- (void)clickjingyan
{
    UILabel *label1 = [[self.jingyan1 subviews] firstObject];
    [label1 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label2 = [[self.jingyan1 subviews] lastObject];
    [label2 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label3 = [[self.jingyan2 subviews] firstObject];
    [label3 setTextColor:mRGBToColor(0xff4001)];
    UILabel *label4 = [[self.jingyan2 subviews] lastObject];
    [label4 setTextColor:mRGBToColor(0xff4001)];
    [self setupOtherlabelColorWith:2];
//    [self getpinglunData];
    
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
    [self getbaoliaoData];
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.modeltype == pinglun) {
        CommentModel *model = [self.DataModelArray objectAtIndex:indexPath.row];
        CGFloat height = [MyCommentCell heightForSentCellWithObject:model];
        
        return height;
    }else if (self.modeltype == baoliao)
    {
        if (indexPath.row == 0) {
            return 50;
        }
    }
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.modeltype == pinglun) {
        MyCommentCell *cell = [MyCommentCell cellWithTableView:tableView];
        //数据传递
        cell.indexPath=indexPath;
        //模型传递
        cell.model=self.DataModelArray[indexPath.row];
        cell.userIcon = self.pageModel.userIcon;
        cell.isSentComment = YES;
        cell.delegate = self;
        return cell;
    }else if (self.modeltype == baoliao)
    {
        if (indexPath.row == 0) {
            BaoliaoTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BaoliaoTableViewCell" owner:self options:nil] firstObject];
            return cell;
        }
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.modeltype == 0) {
        UIView *menuview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 50)];
        
        self.menuview1 = menuview;
        [self addMenuViewButtonWith];
    }
    
   
    return self.menuview1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.modeltype == pinglun) {
        return self.DataModelArray.count;
    }
    return 30;
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
       NSDictionary *parameter = @{@"uid": @"getMyComment",
                                @"pageIndex": @"1",
                                @"pageSize": @"10",
                                @"userId":self.uesrId
                                };
    [APIOperation GET:@"common.action"
           parameters:parameter
         onCompletion:^(id responseData, NSError *error) {
             
             if (responseData) {
                 int page_flag = [[[responseData objectForKey:@"rows"] objectForKey:@"page_flag"]intValue];
                 if (page_flag <= 10) {
                     [self.tableview removeFooter];
                 }
                 NSArray *jsondataArray = [[responseData objectForKey:@"rows"]objectForKey:@"rows"];
                 NSMutableArray *tempArray = [NSMutableArray array];
                 for (NSDictionary *tempdic in jsondataArray) {
                     CommentModel *tempmodel = [[CommentModel alloc]initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:tempdic]];
                     [tempArray addObject:tempmodel];
                     
                 }
                 self.DataModelArray = tempArray;
                 [self.tableview reloadData];
             }else {
                 
             }
         }];

}
#pragma mark 2 获取爆料数据
- (void)getbaoliaoData
{
    
    NSDictionary *parameter = @{@"uid": @"getShareInfoList",
                                @"type":@"1" ,
                                @"userId":self.uesrId
                                };
    [APIOperation GET:@"common.action"
           parameters:parameter
         onCompletion:^(id responseData, NSError *error) {
             if (responseData) {
                
                 NSArray *jsondataArray = [[responseData objectForKey:@"rows"]objectForKey:@"rows"];
                 NSMutableArray *tempArray = [NSMutableArray array];
                 for (NSDictionary *tempdic in jsondataArray) {
                     CommentModel *tempmodel = [[CommentModel alloc]initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:tempdic]];
                     [tempArray addObject:tempmodel];
                     
                 }
                 self.DataModelArray = tempArray;
                 [self.tableview reloadData];
             }else {
                 
             }
         }];
}
#pragma mark - MyCommentCellDelegate
-(void)showProductVC:(NSString *)proId{
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    vc.goodsId = proId;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 下拉刷新
- (void)footerRereshing
{
    
    if (self.modeltype == pinglun) {
        pageIndex++;
        
        NSDictionary *parameter = @{@"uid": @"getMyComment",
                                    @"pageIndex": [NSString stringWithFormat:@"%i",pageIndex],
                                    @"pageSize": @"10",
                                    @"userId":self.uesrId
                                    };
        [APIOperation GET:@"common.action"
               parameters:parameter
             onCompletion:^(id responseData, NSError *error) {
                 
                 if (responseData) {
                     
                     NSArray *jsondataArray = [[responseData objectForKey:@"rows"]objectForKey:@"rows"];
                     
                     for (NSDictionary *tempdic in jsondataArray) {
                         CommentModel *tempmodel = [[CommentModel alloc]initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:tempdic]];
                         [self.DataModelArray addObject:tempmodel];
                         
                     }
                     
                     
                     [self.tableview reloadData];
                      [self.tableview footerEndRefreshing];                   
                 }else {
                     
                 }
             }];
        

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)blackButton {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
