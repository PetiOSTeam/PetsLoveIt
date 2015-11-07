//
//  UIViewController+Addition.m
//  smartcity
//
//  Created by junfrost on 13-12-25.
//  Copyright (c) 2013年 junfrost. All rights reserved.
//

#import "UIViewController+Addition.h"

@implementation UIViewController (Addition)

- (void)adjustForIOS7
{
    if (mIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
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
