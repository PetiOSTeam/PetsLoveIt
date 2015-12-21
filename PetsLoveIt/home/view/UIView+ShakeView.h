//
//  UIView+Extension.h
//  PetsLoveIt
//
//  Created by 123 on 15/12/17.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ShakeView)
+ (UIView *)ShakeViewWithFirstTitle:(NSString *)firsttitle andSecondTitle:(NSString *)secondtitle andaddTarget:(id)target action:(SEL)action;
@end
