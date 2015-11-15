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
@property (strong, nonatomic)  UIButton *menuButton1;
@property (strong, nonatomic)  UIButton *menuButton2;
@property (strong, nonatomic)  UIButton *menuButton3;
@property (strong, nonatomic)  UIButton *menuButton4;
@property (strong, nonatomic)  UIButton *menuButton5;

@property (nonatomic, strong) UIImageView *headerImageView;
@end

@implementation BottomMenuView

-(instancetype)initWithFrame:(CGRect)frame menuType:(DetailPageType)type{
    self = [super initWithFrame:frame];
    
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
    [self.menuButton5 addTarget:self action:@selector(didClickOnMenu4) forControlEvents:UIControlEventTouchUpInside];
    
    self.menuButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton5.height = frame.size.height;
    [self.menuButton5.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.menuButton5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.menuButton5 addTarget:self action:@selector(didClickOnMenu5) forControlEvents:UIControlEventTouchUpInside];
    self.menuButton5.width = 120;

   
    self.menuButton1.width = self.menuButton2.width =self.menuButton3.width=self.menuButton4.width = (mScreenWidth-120)/4;
   
    
    self.menuButton1.left = 0;
    self.menuButton2.left=self.menuButton1.right;
    self.menuButton3.left=self.menuButton2.right;
    self.menuButton4.left=self.menuButton3.right;
    self.menuButton5.left = self.menuButton4.right;
    
    
    [self addSubview:self.menuButton1];
    [self addSubview:self.menuButton2];
    [self addSubview:self.menuButton3];
    [self addSubview:self.menuButton4];
    [self addSubview:self.menuButton5];
    if (self) {
        switch (type) {
            case GoodsType:
            {
                [self.menuButton5 setBackgroundColor:mRGBToColor(0xff4401)];
                [self.menuButton5 setTitle:@"特快直达" forState:UIControlStateNormal];
            }
                break;
            case RelatedPersonType:
            {
                _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(mScreenWidth-55-30, 20, 24, 24)];
                _headerImageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapOnHeaderImageViewGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPersonInfoVC)];
                [_headerImageView addGestureRecognizer:tapOnHeaderImageViewGesture];
                CALayer* headerImageViewLayer = _headerImageView.layer;
                [headerImageViewLayer setMasksToBounds:YES];
                [headerImageViewLayer setCornerRadius:14];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(mScreenWidth-55, 20, 1, 24)];
                [lineView setBackgroundColor:kCellSeparatorColor];
                [self addSubview:lineView];
                [self addSubview:_headerImageView];
            }
                break;
            case NewsType:
            {
                [self.menuButton5 setBackgroundColor:mRGBToColor(0xf4401)];
                [self.menuButton5 setTitle:@"特快直达" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
    }
    return self;
}
- (void) didClickOnMenu1{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"喜欢", @"不喜欢", nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
        
    }else{
        
    }
}

- (void) didClickOnMenu2{
    if (![AppCache getUserInfo]) {
        if ([self.delegate respondsToSelector:@selector(showLoginVC)]) {
            [self.delegate showLoginVC];
        }
        return;
    }
    //收藏
    self.menuButton2.selected = YES;
    
}

- (void) didClickOnMenu3{
    //点击分享查看详情url
    NSString *detailUrl = @"http://www.pets.com";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = detailUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = detailUrl;
    //微博分享内容单独设置
   
//    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@",@""];
    [UMSocialSnsService presentSnsIconSheetView:[self viewController]
                                         appKey:UMENG_APPKEY
                                      shareText:@"测试分享"
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
    if ([self.delegate respondsToSelector:@selector(lastMenuAction)]) {
        [self.delegate lastMenuAction];
    }
}

- (void) showPersonInfoVC{
    if ([self.delegate respondsToSelector:@selector(showPersonInfoVC)]) {
        [self.delegate showPersonInfoVC];
    }
}

@end
