//
//  CarefulSelectViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/7.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CarefulSelectViewController.h"
#import "ZQW_ScrollView.h"
#import "GoodsModel.h"
#import "GoodsCell.h"
#import "CoreViewNetWorkStausManager.h"
#import "GoodsDetailViewController.h"

@interface CarefulSelectViewController ()<ZQWScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *tableHeaderView;
@property(nonatomic,strong)  ZQW_ScrollView *zqw;

@property (nonatomic,strong) NSMutableArray *imageURLs;

@property (nonatomic,strong) UIView *displayView;
@property (nonatomic,strong) UIView *displayView1;
@property (nonatomic,strong) UIView *displayView2;
@property (nonatomic,strong) UIView *displayView3;


@property (nonatomic,strong) UIImageView *urlImageView1;
@property (nonatomic,strong) UILabel *titleLabel1;
@property (nonatomic,strong) UILabel *descLabel1;

@property (nonatomic,strong) UIImageView *urlImageView2;
@property (nonatomic,strong) UILabel *titleLabel2;
@property (nonatomic,strong) UILabel *descLabel2;

@property (nonatomic,strong) UIImageView *urlImageView3;
@property (nonatomic,strong) UILabel *titleLabel3;
@property (nonatomic,strong) UILabel *descLabel3;
@end

@implementation CarefulSelectViewController{
    NSMutableArray *dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareViewsAndData];
}

- (void)prepareViewsAndData{
    
    self.imageURLs = @[@"http://eimg.smzdm.com/201511/07/563d5aafb4b5a7775.jpg",
                       @"http://eimg.smzdm.com/201511/06/563c106d4c8a7502.png",
                       @"http://eimg.smzdm.com/201511/07/563d5fb8cb2a47852.jpg"];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.height = mScreenHeight-mStatusBarHeight-mNavBarHeight-self.tabBarController.tabBar.height - CorePagesBarViewH;
    [self config];
    dataArray = [NSMutableArray new];
    for (int i =0 ; i<20; i++) {
        GoodsModel *good = [GoodsModel new];
        good.imageUrl = @"http://am.zdmimg.com/201511/01/56362f724a9535919.jpg_d320.jpg";
        good.name = @"天猫狗粮优惠活动开始了";
        good.desc = @"双十一天猫优惠活动开始了，小样儿快行动吧...";
        good.prodDetail = @"100元包邮";
        good.commentNum = @"10";
        good.favorNum = @"80%";
        good.dateDesc = @"11-11";
        [dataArray addObject:good];
    }
    self.dataList = dataArray;
    [self.tableView reloadData];
}


-(void)testdealWithResponseData:(id)obj{
    
}


-(void)selectScrollView:(NSInteger)index{
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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
    configModel.ModelClass=[GoodsModel class];
    //cell类
    configModel.ViewForCellClass=[GoodsCell class];
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
    configModel.hiddenNetWorkStausManager = YES;
    
    //移除返回顶部:(默认开启)
    configModel.removeBackToTopBtn=NO;
    
    configModel.refreshControlType = LTConfigModelRefreshControlTypeBoth;
    
    //配置完毕
    self.configModel=configModel;
}

-(UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 370)];
        [_tableHeaderView setBackgroundColor:mRGBToColor(0xf5f5f5)];
        
        _zqw = [[ZQW_ScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 190)];
        _zqw.currentColor = [UIColor grayColor];
        _zqw.allColor = [UIColor whiteColor];
        _zqw.autoScrollTimeInterval = 5;
        _zqw.Delegate = self;
        _zqw.pictureArray = _imageURLs;
        [_tableHeaderView addSubview:_zqw];
        
        _displayView = [[UIView alloc] initWithFrame:CGRectMake(0, _zqw.bottom+10, mScreenWidth, 160)];
        [_displayView setBackgroundColor:[UIColor whiteColor]];
        
        _displayView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth/2, _displayView.height)];
        _titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, mScreenWidth/2-20, 18)];
        [_titleLabel1 setTextColor:mRGBToColor(0xff4401)];
        [_titleLabel1 setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel1 setText:@"今日白菜"];
        
        _descLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, _titleLabel1.bottom+10, mScreenWidth/2-20, 14)];
        [_descLabel1 setTextColor:mRGBToColor(0x666666)];
        [_descLabel1 setFont:[UIFont systemFontOfSize:12]];
        [_descLabel1 setText:@"今日白菜今日白菜今日白菜"];
        _urlImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, _descLabel1.bottom+5, 130, 95)];
        [_displayView1 addSubview:_titleLabel1];
        [_displayView1 addSubview:_descLabel1];
        [_displayView1 addSubview:_urlImageView1];
        
        
        [_displayView addBorderWithFrame:CGRectMake(mScreenWidth/2, 0, kLayerBorderWidth, _displayView.height) andColor:kLayerBorderColor andWidth:kLayerBorderWidth];
        [_displayView addBorderWithFrame:CGRectMake(mScreenWidth/2, _displayView.height/2, mScreenWidth/2, kLayerBorderWidth) andColor:kLayerBorderColor andWidth:kLayerBorderWidth];
        [_urlImageView1 yy_setImageWithURL:[NSURL URLWithString:@"http://eimg.smzdm.com/201511/07/563d8527b7dad7297.jpg"] placeholder:kImagePlaceHolder options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            if (!error) {

            }
        }];
        
        _displayView2 = [[UIView alloc] initWithFrame:CGRectMake(_displayView1.right, 0, mScreenWidth/2, _displayView.height/2)];
        if (mIsiP5) {
            _urlImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_displayView2.width - 80, _descLabel2.bottom+5, 70, 60)];
        }else{
            _urlImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_displayView2.width - 100, _descLabel2.bottom+5, 90, 60)];
        }
                
        _titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _displayView2.width-_urlImageView2.width-20, 18)];
        _descLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, _titleLabel2.bottom+10, _displayView2.width-_urlImageView2.width-20, 14)];
        [_titleLabel2 setTextColor:mRGBToColor(0xff4401)];
        [_titleLabel2 setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel2 setText:@"限时优惠"];
        [_descLabel2 setTextColor:mRGBToColor(0x666666)];
        [_descLabel2 setFont:[UIFont systemFontOfSize:12]];
        [_descLabel2 setText:@"满99元减30"];
        
        [_displayView2 addSubview:_titleLabel2];
        [_displayView2 addSubview:_descLabel2];
        [_displayView2 addSubview:_urlImageView2];
        
        
        [_urlImageView2 yy_setImageWithURL:[NSURL URLWithString:@"http://eimg.smzdm.com/201511/08/563ea8e9c46a79304.png"] placeholder:kImagePlaceHolder options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation completion:NULL];
        
        
        
        
        _displayView3 = [[UIView alloc] initWithFrame:CGRectMake(_displayView1.right, _displayView2.bottom, mScreenWidth/2, _displayView.height/2)];
        if (mIsiP5) {
            _urlImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(_displayView2.width - 80, _descLabel3.bottom+5, 70, 60)];
        }else{
            _urlImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(_displayView2.width - 100, _descLabel3.bottom+5, 90, 60)];
        }
        
        _titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _displayView3.width-_urlImageView3.width-20, 18)];
        _descLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, _titleLabel3.bottom+10, _displayView3.width-_urlImageView2.width-20, 14)];
        [_titleLabel3 setTextColor:mRGBToColor(0xff4401)];
        [_titleLabel3 setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel3 setText:@"高端尖货"];
        [_descLabel3 setTextColor:mRGBToColor(0x666666)];
        [_descLabel3 setFont:[UIFont systemFontOfSize:12]];
        [_descLabel3 setText:@"限时抢购"];
        
        
        [_urlImageView3 yy_setImageWithURL:[NSURL URLWithString:@"http://eimg.smzdm.com/201511/08/563ea991a4da52095.png"] placeholder:kImagePlaceHolder options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation completion:NULL];
        
        [_displayView3 addSubview:_titleLabel3];
        [_displayView3 addSubview:_descLabel3];
        [_displayView3 addSubview:_urlImageView3];
        
        _urlImageView1.userInteractionEnabled = YES;
        _urlImageView2.userInteractionEnabled = YES;
        _urlImageView3.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImageView1)];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImageView2)];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImageView3)];
        [_displayView1 addGestureRecognizer:tap1];
        [_displayView2 addGestureRecognizer:tap2];
        [_displayView3 addGestureRecognizer:tap3];
        
        [_displayView addSubview:_displayView1];
        [_displayView addSubview:_displayView2];
        [_displayView addSubview:_displayView3];
        
        [_tableHeaderView addSubview:_displayView];
        
    }
    return _tableHeaderView;
}

- (void)tapOnImageView1{
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tapOnImageView2{
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tapOnImageView3{
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
