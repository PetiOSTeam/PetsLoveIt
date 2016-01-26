//
//  BottomMenuView.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "BottomMenuView.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialWechatHandler.h"

@interface BottomMenuView()<UIActionSheetDelegate,UMSocialUIDelegate>

@property (strong, nonatomic)  UIButton *menuButton5;

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, assign) Menutype detailType;
@end

@implementation BottomMenuView

-(instancetype)initWithFrame:(CGRect)frame menuType:(Menutype)type{
    self = [super initWithFrame:frame];
    
    self.detailType = type;
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addTopBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    
    self.menuButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton1.height = frame.size.height;
    [self.menuButton1 setImage:[UIImage imageNamed:@"unlikeIcon"] forState:UIControlStateNormal];
    [self.menuButton1 setImage:[UIImage imageNamed:@"likeIcon"] forState:UIControlStateSelected];
    [self.menuButton1 addTarget:self action:@selector(didClickOnMenu1) forControlEvents:UIControlEventTouchUpInside];
    
    self.menuButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton2.height = frame.size.height;
    [self.menuButton2 setImage:[UIImage imageNamed:@"unStoreIcon"] forState:UIControlStateNormal];
    [self.menuButton2 setImage:[UIImage imageNamed:@"storeIcon"] forState:UIControlStateSelected];
    [self.menuButton2 addTarget:self action:@selector(didClickOnMenu2) forControlEvents:UIControlEventTouchUpInside];
    self.menuButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton3.height = frame.size.height;
    [self.menuButton3 setImage:[UIImage imageNamed:@"shareIcon"] forState:UIControlStateNormal];
    [self.menuButton3 addTarget:self action:@selector(didClickOnMenu3) forControlEvents:UIControlEventTouchUpInside];
    
    self.menuButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton4.height = frame.size.height;
    [self.menuButton4 setImage:[UIImage imageNamed:@"commentIcon"] forState:UIControlStateNormal];
    [self.menuButton4 addTarget:self action:@selector(didClickOnMenu4) forControlEvents:UIControlEventTouchUpInside];
    
    self.menuButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton5.height = frame.size.height;
    [self.menuButton5.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.menuButton5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.menuButton5 addTarget:self action:@selector(didClickOnMenu5) forControlEvents:UIControlEventTouchUpInside];
    self.menuButton5.width = 105;

   
    self.menuButton1.width = self.menuButton2.width =self.menuButton3.width=self.menuButton4.width = (mScreenWidth-100)/4;
   
    
    self.menuButton1.left = 5;
    self.menuButton2.left=self.menuButton1.right -3;
    self.menuButton3.left=self.menuButton2.right -3;
    self.menuButton4.left=self.menuButton3.right-5;
    self.menuButton5.left = self.menuButton4.right + 3;
    
    
    [self addSubview:self.menuButton5];
    [self addSubview:self.menuButton4];
    [self addSubview:self.menuButton3];
    [self addSubview:self.menuButton2];
    [self addSubview:self.menuButton1];
    
    //  设置内容居左
    
    self.menuButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.menuButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.menuButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.menuButton4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    // 文字对齐
    self.menuButton1.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.menuButton2.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.menuButton3.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.menuButton4.titleLabel.textAlignment = NSTextAlignmentCenter;

    
//    // 设置高亮时候不调整图片
//    self.adjustsImageWhenHighlighted = NO;

    [self.menuButton1 setTitleColor:mRGBToColor(0x999999) forState:UIControlStateNormal];
    [self.menuButton1.titleLabel setFont:[UIFont systemFontOfSize:11]];

    [self.menuButton2.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [self.menuButton2 setTitleColor:mRGBToColor(0x999999) forState:UIControlStateNormal];
    
    [self.menuButton3.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [self.menuButton3 setTitleColor:mRGBToColor(0x999999) forState:UIControlStateNormal];
    
    [self.menuButton4.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [self.menuButton4 setTitleColor:mRGBToColor(0x999999) forState:UIControlStateNormal];
    
    [self.menuButton1.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [self.menuButton1 setTitle:@"0" forState:UIControlStateNormal];
    [self.menuButton2 setTitle:@"0" forState:UIControlStateNormal];
    [self.menuButton3 setTitle:@"分享" forState:UIControlStateNormal];
    [self.menuButton4 setTitle:@"0" forState:UIControlStateNormal];
    
    if (self) {
        switch (type) {
            case TypeDiscount:
            case TypeMassTao:
            case TypeTaoPet:
            case TypeCheap:
            {
                [self.menuButton5 setBackgroundColor:mRGBToColor(0xff4401)];
                [self.menuButton5 setTitle:@"特快直达" forState:UIControlStateNormal];
            }
                break;
            case TypeShareOrder:
            case TypeExperience:
            {
                _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(mScreenWidth-55+15, 15, 24, 24)];
                _headerImageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapOnHeaderImageViewGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPersonInfoVC)];
                [_headerImageView addGestureRecognizer:tapOnHeaderImageViewGesture];
                CALayer* headerImageViewLayer = _headerImageView.layer;
                [headerImageViewLayer setMasksToBounds:YES];
                [headerImageViewLayer setCornerRadius:12];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(mScreenWidth-55, 15, 1, 24)];
                [lineView setBackgroundColor:kCellSeparatorColor];
                [self addSubview:lineView];
                [self addSubview:_headerImageView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Clickusericon)];
                [_headerImageView addGestureRecognizer:tap];

            }
                break;
            case TypeNews:
            {
                [self.menuButton5 setBackgroundColor:mRGBToColor(0xff4401)];
                [self.menuButton5 setTitle:@"资讯中心" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (void) loadAvatarImage:(NSString *)avatar{
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:kDefaultHeadImage];
}


- (void) didClickOnMenu1{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"爱", @"不爱", nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
     
        if ([self.delegate respondsToSelector:@selector(praiseProduct:)]) {
            [self.delegate praiseProduct:YES];
        }
    }else if (buttonIndex == 1){
        
        if ([self.delegate respondsToSelector:@selector(praiseProduct:)]) {
            [self.delegate praiseProduct:NO];
        }
    }else{
        
    }
}


- (void) didClickOnMenu2{
    if (![AppCache getUserInfo]) {
//        if ([self.delegate respondsToSelector:@selector(showLoginVC)]) {
//            [self.delegate showLoginVC];
//        }
        [mAppUtils showHint:@"您还没有登陆"];
        return;
    }else{
        self.menuButton2.selected = !self.menuButton2.selected;
        BOOL selected = self.menuButton2.selected;
        //收藏
        self.menuButton2.selected = selected;
        if ([self.delegate respondsToSelector:@selector(collectProduct:)]) {
            [self.delegate collectProduct:selected];
        }
    }
    
    
}

- (void) didClickOnMenu3{
    //点击分享查看详情url
    NSString *detailUrl = sharelink;
    [UMSocialData defaultData].extConfig.qqData.url = detailUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = detailUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = detailUrl;
    
    NSString *title = @"《宠物爱这个》专注宠物生活，拉近您与爱宠的距离。";
    [UMSocialData defaultData].extConfig.title = title;
    //微博分享内容单独设置
    
    //    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@",@""];
    [UMSocialSnsService presentSnsIconSheetView:[self viewController]
                                         appKey:UMENG_APPKEY
                                      shareText:@"海量品牌商品，为您提供物美价廉的多重选择，更有白菜价、海外购等优质商品一站直达，快去无忧剁手爽购吧！"
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
    }
}

- (void) didClickOnMenu4{
    if ([self.delegate respondsToSelector:@selector(showCommentVC)]) {
        [self.delegate showCommentVC];
    }
}

- (void) didClickOnMenu5{
    if ([self.delegate respondsToSelector:@selector(lastMenuAction:)]) {
        [self.delegate lastMenuAction:self.detailType];
    }
}

- (void) showPersonInfoVC{
    if ([self.delegate respondsToSelector:@selector(showPersonInfoVC)]) {
        [self.delegate showPersonInfoVC];
    }
}
- (void)Clickusericon
{
    if ([self.delegate respondsToSelector:@selector(ClickShaidanauthor)]) {
        [self.delegate ClickShaidanauthor];
    }
}
@end
