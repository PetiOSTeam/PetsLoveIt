//
//  ShakeViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/14.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ShakeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "GoodsModel.h"
#import "GoodsDetailViewController.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialWechatHandler.h"
#import "LoginViewController.h"

@interface ShakeViewController ()<UMSocialUIDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)   UIView *bgView;
@property (nonatomic,strong)   UIImageView*        imgUp;
@property (nonatomic,strong)   UIImageView*        imgDown;

@property (nonatomic,strong)   UIView *maskView;
@property (nonatomic,strong)   UIView *goodsView;
@property (nonatomic,strong)   UIView *noOpView;
@property (nonatomic,strong)   UIView *noShareNumView;
@property (nonatomic,assign)   BOOL showPopViewFlag;
@property (nonatomic,strong) NSString *goodsId;


@end

@implementation ShakeViewController{
    SystemSoundID           soundID;
    UILabel *goodsTitleLabel;
    UIImageView *goodsImageView;
    UILabel *commentNumLabel;
    UILabel *favorNumLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}

- (void) prepareViewAndData{
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.imgUp];
    [self.view addSubview:self.imgDown];
    [self setupNavbarButtons];
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"shake" ofType:@"wav"];
    //AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnimations) name:@"shake" object:nil];
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 200)];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        imageView.center = CGPointMake(mScreenWidth/2,_bgView.height/2);
        [imageView setImage:[UIImage imageNamed:@"ImageAppIcon"]];
        _bgView.center = CGPointMake(mScreenWidth/2, mScreenHeight/2);
        [_bgView addSubview:imageView];
        
    }
    return _bgView;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake )
    {
        // User was shaking the device. Post a notification named "shake".
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{	
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"shake"];
}

//添加
#pragma mark - 摇一摇动画效果
- (void)addAnimations
{
    if (self.showPopViewFlag) {
        return;
    }
    //AudioServicesPlaySystemSound (soundID);
    
    //让imgup上下移动
    CABasicAnimation *translation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    translation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation2.fromValue = [NSValue valueWithCGPoint:CGPointMake(mScreenWidth/2, mScreenHeight/4)];
    translation2.toValue = [NSValue valueWithCGPoint:CGPointMake(mScreenWidth/2, mScreenHeight/4-100)];
    translation2.duration = 0.4;
    translation2.repeatCount = 1;
    translation2.autoreverses = YES;
    
    //让imagdown上下移动
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(mScreenWidth/2, mScreenHeight/4*3)];
    translation.toValue = [NSValue valueWithCGPoint:CGPointMake(mScreenWidth/2, mScreenHeight/4*3 + 100)];
    translation.duration = 0.4;
    translation.repeatCount = 1;
    translation.autoreverses = YES;
    
    [_imgDown.layer addAnimation:translation forKey:@"translation"];
    [_imgUp.layer  addAnimation:translation2 forKey:@"translation2"];

    if (![AppCache getUserInfo]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您还没有登录哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        [alertView show];
        return;
    }
    
    self.showPopViewFlag = YES;
    [self performSelector:@selector(getRandomProduct) withObject:nil afterDelay:0];
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        [_maskView setBackgroundColor:[UIColor blackColor]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopView)];
        [_maskView addGestureRecognizer:tap];
        _maskView.alpha = 0;
    }
    return _maskView;
}

-(UIView *)noShareNumView{
    if (!_noShareNumView) {
        _noShareNumView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 160)];
        _noShareNumView.center = CGPointMake(mScreenWidth/2, mScreenHeight/2);
        _noShareNumView.backgroundColor = [UIColor whiteColor];
        _noShareNumView.clipsToBounds = YES;
        _noShareNumView.layer.cornerRadius = 5;
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, _noShareNumView.width-20, 60)];
        tipLabel.center = CGPointMake(_noShareNumView.width/2, _noShareNumView.height/2-15);
        [tipLabel setTextAlignment:NSTextAlignmentCenter];
        [tipLabel setFont:[UIFont systemFontOfSize:14]];
        [tipLabel setTextColor:mRGBToColor(0x333333)];
        [tipLabel setNumberOfLines:2];
        [tipLabel setText:@"亲，您今天的机会用完了\n请明天再来吧"];
        [_noShareNumView addSubview:tipLabel];
        
        
        UIButton *shareButtton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButtton.frame = CGRectMake(0, tipLabel.bottom+8, 150, 35);
        shareButtton.center = CGPointMake(_noShareNumView.width/2, shareButtton.center.y);
        [shareButtton setTitle:@"取消" forState:UIControlStateNormal];
        [shareButtton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        shareButtton.layer.cornerRadius = 5;
        [shareButtton setBackgroundColor:mRGBToColor(0xff4401)];
        [_noShareNumView addSubview:shareButtton];
    }
    return _noShareNumView;
}

- (void) cancelAction{
    [self hidePopView];
}

-(UIView *)noOpView{
    if (!_noOpView) {
        _noOpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 160)];
        _noOpView.center = CGPointMake(mScreenWidth/2, mScreenHeight/2);
        _noOpView.backgroundColor = [UIColor whiteColor];
        _noOpView.clipsToBounds = YES;
        _noOpView.layer.cornerRadius = 5;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, _noOpView.width, 17)];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setTextColor:mRGBToColor(0x333333)];
        [titleLabel setText:@"机会用光啦"];
        [_noOpView addSubview:titleLabel];
        
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + 15, _noOpView.width, 30)];
        [tipLabel setTextAlignment:NSTextAlignmentCenter];
        [tipLabel setFont:[UIFont systemFontOfSize:14]];
        [tipLabel setTextColor:mRGBToColor(0xff4401)];
        [tipLabel setText:@"分享可再获取一次机会"];
        [_noOpView addSubview:tipLabel];
        
        UIButton *shareButtton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButtton.frame = CGRectMake(0, _noOpView.height-29-35, 150, 35);
        shareButtton.center = CGPointMake(_noOpView.width/2, shareButtton.center.y);
        [shareButtton setTitle:@"立即分享" forState:UIControlStateNormal];
        [shareButtton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        shareButtton.layer.cornerRadius = 5;
        [shareButtton setBackgroundColor:mRGBToColor(0xff4401)];
        [_noOpView addSubview:shareButtton];
        
    }
    return _noOpView;
}

-(UIView *)goodsView{
    if (!_goodsView) {
        _goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 280)];
        _goodsView.center = CGPointMake(mScreenWidth/2, mScreenHeight/2);
        _goodsView.backgroundColor = [UIColor whiteColor];
        _goodsView.clipsToBounds = YES;
        _goodsView.layer.cornerRadius = 5;
        UIImageView *topBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];
        topBgImageView.image = [UIImage imageNamed:@"shakeTopBgImage"];
        topBgImageView.center = CGPointMake(_goodsView.width/2, topBgImageView.height/2);
        [_goodsView addSubview:topBgImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];
        titleLabel.center = topBgImageView.center;
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:@"优惠"];
        [_goodsView addSubview:titleLabel];
        
        goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topBgImageView.bottom + 15, 140, 125)];
        goodsImageView.center = CGPointMake(_goodsView.width/2, goodsImageView.center.y);
        
        [_goodsView addSubview:goodsImageView];
        
        goodsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, goodsImageView.bottom +10, goodsImageView.width+40, 16)];
        goodsTitleLabel.left = goodsImageView.left-20;
        [goodsTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [goodsTitleLabel setFont:[UIFont systemFontOfSize:14]];
        [goodsTitleLabel setTextColor:mRGBToColor(0x333333)];
        [_goodsView addSubview:goodsTitleLabel];
        
        UIImageView *commentNumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, goodsTitleLabel.bottom + 8, 20, 20)];
        [commentNumImageView setImage:[UIImage imageNamed:@"listcommentIcon"]];
        [_goodsView addSubview:commentNumImageView];
    
        commentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, goodsTitleLabel.bottom + 8, 30, 16)];
        commentNumLabel.left = commentNumImageView.right+2;
        commentNumLabel.center = CGPointMake(commentNumLabel.center.x, commentNumImageView.center.y);
        [commentNumLabel setTextAlignment:NSTextAlignmentLeft];
        [commentNumLabel setFont:[UIFont systemFontOfSize:12]];
        [commentNumLabel setTextColor:mRGBToColor(0x999999)];
        [_goodsView addSubview:commentNumLabel];
        
        UIImageView *favorNumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(commentNumLabel.right + 2, goodsTitleLabel.bottom + 8, 20, 20)];
        [favorNumImageView setImage:[UIImage imageNamed:@"listfavorIcon"]];
        [_goodsView addSubview:favorNumImageView];
        
        favorNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, goodsTitleLabel.bottom + 8, 30, 16)];
        favorNumLabel.left = favorNumImageView.right+2;
        favorNumLabel.center = CGPointMake(favorNumLabel.center.x, favorNumImageView.center.y);
        [favorNumLabel setTextAlignment:NSTextAlignmentLeft];
        [favorNumLabel setFont:[UIFont systemFontOfSize:12]];
        [favorNumLabel setTextColor:mRGBToColor(0x999999)];
        [_goodsView addSubview:favorNumLabel];
        
        UIButton *showDetailButtton = [UIButton buttonWithType:UIButtonTypeCustom];
        showDetailButtton.frame = CGRectMake(0, commentNumLabel.bottom+8, 150, 35);
        showDetailButtton.center = CGPointMake(_goodsView.width/2, showDetailButtton.center.y);
        [showDetailButtton setTitle:@"去看看" forState:UIControlStateNormal];
        [showDetailButtton addTarget:self action:@selector(showGoodsDetail) forControlEvents:UIControlEventTouchUpInside];
        showDetailButtton.layer.cornerRadius = 5;
        [showDetailButtton setBackgroundColor:mRGBToColor(0xff4401)];
        [_goodsView addSubview:showDetailButtton];
    }
    return _goodsView;
}

- (void)shareAction{
    [self hidePopView];
    //点击分享查看详情url
    NSString *detailUrl = iVersioniOSAppStoreURLFormat;
    [UMSocialData defaultData].extConfig.qqData.url = detailUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = detailUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = detailUrl;
    
    NSString *title = @"我在宠物爱这个摇到好多积分和白菜价商品";
    [UMSocialData defaultData].extConfig.title = title;
    //微博分享内容单独设置
    
    //    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@",@""];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:@"宠物爱这个，爱Ta就给Ta不一样的宠爱，拉近您与爱宠的距离"
                                     shareImage:[UIImage imageNamed:@"ImageAppIcon"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToQQ,UMShareToQzone,UMShareToWechatTimeline,UMShareToSina]
                                       delegate:self];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        //shareNum 加1
        [self updateShareNum];
    }
}

- (void)updateShareNum{
    NSDictionary *params = @{
                             @"uid":@"updShareNum"
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        
    }];
}

- (void)showGoodsDetail{
    [self hidePopView];
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    vc.goodsId = self.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        LoginViewController *vc = [LoginViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getRandomProduct{
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeNone];
    NSDictionary *params = @{
                             @"uid":@"getRandomProduct"
                             };
    [APIOperation GET_2:@"getCoreSv.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            //只允许摇3次,code为0表示不能再摇了
            NSString *code = [responseData objectForKey:@"rtnCode"];
            //只允许分享5次
            NSInteger canShareNum = [[[responseData objectForKey:@"data"]  objectForKey:@"sharenum"] integerValue];
            if ([code isEqualToString:@"0"] && canShareNum<5) {
                [self showNoOpView];
                return ;
            }
            else if (canShareNum >=5) {
                [self showNoShareNumView];
                return ;
            }
            
            id jsonDict = [responseData objectForKey:@"data"];
            GoodsModel *goods = [[GoodsModel alloc] initWithDictionary:jsonDict];
            self.goodsId = goods.prodId;
            [self showGoodsView:goods];
        }else{
            self.showPopViewFlag = NO;
        }
    }];
}

- (void)showNoShareNumView{
    self.maskView.alpha = 0;
    self.noShareNumView.bottom = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view addSubview:self.maskView];
        [self.view addSubview:self.noShareNumView];
        self.noShareNumView.center = CGPointMake(mScreenWidth/2, mScreenHeight/2);
        self.maskView.alpha = 0.7;
    }];
}

- (void)showNoOpView{
    self.maskView.alpha = 0;
    self.noOpView.bottom = 0;
   [UIView animateWithDuration:0.5 animations:^{
       [self.view addSubview:self.maskView];
       [self.view addSubview:self.noOpView];
       self.noOpView.center = CGPointMake(mScreenWidth/2, mScreenHeight/2);
       self.maskView.alpha = 0.7;
   }];
}

- (void)showGoodsView:(GoodsModel *)goods{
    self.showPopViewFlag = YES;

    self.maskView.alpha = 0;
    self.goodsView.bottom = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view addSubview:self.maskView];
        [self.view addSubview:self.goodsView];
        self.goodsView.width = 230;
        self.goodsView.height = 280;
        self.goodsView.center = CGPointMake(mScreenWidth/2, mScreenHeight/2);
        self.maskView.alpha = 0.7;
        goodsTitleLabel.text = goods.name;
        [goodsImageView sd_setImageWithURL:[NSURL URLWithString:goods.appPic] placeholderImage:kImagePlaceHolder];
        commentNumLabel.text = goods.commentNum;
        favorNumLabel.text = goods.favorNum;
        
    }];
    
}

- (void)hidePopView{
    self.showPopViewFlag = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.maskView removeFromSuperview];
        [self.goodsView removeFromSuperview];
        [self.noOpView removeFromSuperview];
        [self.noShareNumView removeFromSuperview];
    }];
}

- (void)setupNavbarButtons
{
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(0, 30, 44, 34);
    [buttonBack setImage:[UIImage imageNamed:@"whiteBackBarButtonIcon"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    buttonBack.center = CGPointMake(buttonBack.center.x, 42);
    [self.view addSubview:buttonBack];
    
    self.navBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, mScreenWidth-60, 24)];
    self.navBarTitleLabel.center = CGPointMake(self.navBarTitleLabel.center.x, 42);
    self.navBarTitleLabel.text = @"摇一摇";
    [self.navBarTitleLabel setTextColor:[UIColor whiteColor]];
    [self.navBarTitleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.navBarTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.navBarTitleLabel];
}

-(UIImageView *)imgUp{
    if (!_imgUp) {
        _imgUp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight/2)];
        _imgUp.image = [UIImage imageNamed:@"shake1"];
    }
    return _imgUp;
}

-(UIImageView *)imgDown{
    if (!_imgDown) {
        _imgDown = [[UIImageView alloc] initWithFrame:CGRectMake(0, mScreenHeight/2, mScreenWidth, mScreenHeight/2)];
        _imgDown.image = [UIImage imageNamed:@"shake2"];
    }
    return _imgDown;
}

- (void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
