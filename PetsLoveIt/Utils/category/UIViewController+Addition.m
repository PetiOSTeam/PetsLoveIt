//
//  UIViewController+Addition.m
//  smartcity
//
//  Created by junfrost on 13-12-25.
//  Copyright (c) 2013年 junfrost. All rights reserved.
//

#import "UIViewController+Addition.h"
#import <objc/runtime.h>

@implementation UIViewController (Addition)

- (void)adjustForIOS7
{
    if (mIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


static const void *kNavigationBarView = &kNavigationBarView;
static const void *kNavBarTitleLabel = &kNavBarTitleLabel;

- (UIView *)navigationBarView
{
    return objc_getAssociatedObject(self, kNavigationBarView);
}

- (void)setNavigationBarView:(UIView *)navigationBarView
{
    objc_setAssociatedObject(self, kNavigationBarView, navigationBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)navBarTitleLabel
{
    return objc_getAssociatedObject(self, kNavBarTitleLabel);
}

- (void)setNavBarTitleLabel:(UILabel *)navBarTitleLabel
{
    objc_setAssociatedObject(self, kNavBarTitleLabel, navBarTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)showNaviBarView{
    if (!self.navigationBarView) {
        self.navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 64)];
        
        if (CURRENT_SYS_VERSION >= 8.0) {
            UIImageView *blurImageView = [[UIImageView alloc] initWithFrame:self.navigationBarView.bounds];
            
            UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            
            visualEffectView.frame = blurImageView.bounds;
            
            [blurImageView addSubview:visualEffectView];
            [self.navigationBarView addSubview:blurImageView];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.height-1, mScreenWidth, 1)];
        [line setBackgroundColor:mRGBToColor(0xdcdcdc)];
        [self.navigationBarView addSubview:line];
        
        UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonBack.frame = CGRectMake(0, 30, 44, 34);
        [buttonBack setImage:[UIImage imageNamed:@"backBarButtonIcon"] forState:UIControlStateNormal];
        [buttonBack addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBarView addSubview:buttonBack];
        
        self.navBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, mScreenWidth-60, 24)];
        [self.navBarTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.navigationBarView addSubview:self.navBarTitleLabel];
    }
    
    [self.view addSubview:self.navigationBarView];
}

- (void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 @pragma str:文字内容
         font:文字采用的字体
         contrainedSize: 最大size
 @return 根据str的内容计算后，返回合适的size
 **/

-(CGSize)autoAjustedSizeAccordingToString:(NSString *)str  font:(UIFont *)font  constrainedSize:(CGSize) contrainedSize{
    
    CGSize labelsize;
    if (!str) {
        return CGSizeZero;
    }
    if (!font) {
        font = [UIFont systemFontOfSize:14];
    }
    //对ios7处理
    if (mIos7) {
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:str
         attributes:@
         {
         NSFontAttributeName: font
         }];
        //参数为NSStringDrawingUsesLineFragmentOrigin
        CGRect rect = [attributedText boundingRectWithSize:contrainedSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        labelsize = rect.size;
    }else{
        labelsize = [str sizeWithFont:font constrainedToSize:contrainedSize lineBreakMode:NSLineBreakByWordWrapping];
    }
    return labelsize;
}



//画一条线，线的颜色接近cell的separator颜色
-(UIView *) drawSeparatorWithX:(NSInteger)x Y:(NSInteger) y width:(CGFloat) w height:(CGFloat) h{
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(x, y, w,h)];
    UIColor *defaultSeparatorColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    lineView.backgroundColor=defaultSeparatorColor;
//    lineView.autoresizingMask=0x3f;
    return lineView;
}

@end
