//
//  UIView+Extension.m
//  PetsLoveIt
//
//  Created by 123 on 15/12/17.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "UIView+ShakeView.h"

@implementation UIView (ShakeView)
+ (UIView *)ShakeViewWithFirstTitle:(NSString *)firsttitle andSecondTitle:(NSString *)secondtitle andaddTarget:(id)target action:(SEL)action
{
    
  
    UIView *shakeview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 160)];
    shakeview.center = CGPointMake(mScreenWidth/2, mScreenHeight/2);
    shakeview.backgroundColor = [UIColor whiteColor];
    shakeview.clipsToBounds = YES;
    shakeview.layer.cornerRadius = 5;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, shakeview.width-20, 60)];
    tipLabel.center = CGPointMake(shakeview.width/2, shakeview.height/2-15);
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [tipLabel setFont:[UIFont systemFontOfSize:14]];
    [tipLabel setTextColor:mRGBToColor(0x333333)];
    [tipLabel setNumberOfLines:2];
    [shakeview addSubview:tipLabel];
    tipLabel.text = firsttitle;
    
    UIButton *shareButtton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButtton.frame = CGRectMake(0, tipLabel.bottom+8, 150, 35);
    shareButtton.center = CGPointMake(shakeview.width/2, shareButtton.center.y);
    [shareButtton setTitle:secondtitle forState:UIControlStateNormal];
    [shareButtton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    shareButtton.layer.cornerRadius = 5;
    [shareButtton setBackgroundColor:mRGBToColor(0xff4401)];
    [shakeview addSubview:shareButtton];
    return shakeview;
    
}
@end
