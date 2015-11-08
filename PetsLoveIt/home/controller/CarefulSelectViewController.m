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
#import "CorePagesView/Config/CorePagesViewConst.h"

@interface CarefulSelectViewController ()<ZQWScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *tableHeaderView;
@property(nonatomic,strong)  ZQW_ScrollView *zqw;

@property (nonatomic,strong) NSMutableArray *imageURLs;

@property (nonatomic,strong) UIView *displayView;



@property (nonatomic,strong) UIImageView *urlImageView1;

@property (nonatomic,strong) UIView *displayView2;

@property (nonatomic,strong) UIImageView *urlImageView2;

@property (nonatomic,strong) UIView *displayView3;

@property (nonatomic,strong) UIImageView *urlImageView3;
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
        
       
        
        _urlImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, _displayView.height)];
        [_displayView addBorderWithFrame:CGRectMake(_urlImageView1.right, 0, kLayerBorderWidth, _displayView.height) andColor:kLayerBorderColor andWidth:kLayerBorderWidth];
        [_displayView addBorderWithFrame:CGRectMake(240, _displayView.height/2, mScreenWidth-_urlImageView1.width, kLayerBorderWidth) andColor:kLayerBorderColor andWidth:kLayerBorderWidth];
        [_urlImageView1 yy_setImageWithURL:[NSURL URLWithString:@"http://eimg.smzdm.com/201511/07/563d8527b7dad7297.jpg"] placeholder:kImagePlaceHolder options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            if (!error) {

            }
        }];
        
        _urlImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_urlImageView1.right, 0, mScreenWidth-_urlImageView1.width, _displayView.height/2)];
        [_urlImageView2 yy_setImageWithURL:[NSURL URLWithString:@"http://eimg.smzdm.com/201511/08/563ea8e9c46a79304.png"] placeholder:kImagePlaceHolder options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation completion:NULL];
        _urlImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(_urlImageView1.right, _urlImageView2.bottom+0.5, mScreenWidth-_urlImageView1.width, _displayView.height/2)];
        [_urlImageView3 yy_setImageWithURL:[NSURL URLWithString:@"http://eimg.smzdm.com/201511/08/563ea991a4da52095.png"] placeholder:kImagePlaceHolder options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation completion:NULL];
        
        [_displayView addSubview:_urlImageView1];
        [_displayView addSubview:_urlImageView2];
        [_displayView addSubview:_urlImageView3];
        
        [_tableHeaderView addSubview:_displayView];
        
    }
    return _tableHeaderView;
}

- (UIImage *)  imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
