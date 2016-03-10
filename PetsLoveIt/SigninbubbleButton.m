//
//  SigninbubbleButton.m
//  ceshi
//
//  Created by 123 on 15/12/15.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "SigninbubbleButton.h"
#import "UIView+MJExtension.h"

@implementation SigninbubbleButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithframe:(CGRect)frame andSigninNum:(NSString *)signinnum
{
    if (self =[super init]) {
        NSString *btntitle;
        if (signinnum.length>0) {
           btntitle = [NSString stringWithFormat:@"+%@",signinnum];
        }else{
//            static int i = 0;
//            if (i == 7) {
//                i = 0;
//            }
//            i++;
//            btntitle = [NSString stringWithFormat:@"+%i",i];
        }
        
        // 设置按钮坐标以及尺寸
        self.mj_x = frame.origin.x  + frame.size.width ;
        self.mj_y =  frame.origin.y - frame.size.height/2;
        self.mj_width = frame.size.height;
        self.mj_height = frame.size.height;
        self.backgroundColor = [UIColor clearColor];
//        self.layer.cornerRadius = self.mj_height/2;
        // 设置文字颜色和字体大小
        [self setTitle:btntitle forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        UIColor *titleColor = [UIColor colorWithRed:255/255.0 green:74/255.0 blue:0/255.0 alpha:1.0];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;// 左对齐
        self.alpha = 1;
        // 执行动画
        [UIView animateWithDuration:1.0 animations:^{
            self.alpha = 0.5;
            self.mj_y = self.mj_y - self.mj_height;
        } completion:^(BOOL finished) {
            // 删除控件
            [self removeFromSuperview];
        }];

       
    }
    return self;
}

@end
