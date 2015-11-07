//
//  UINavigationController+BarColorStyle.m
//  smartcity
//
//  Created by junfrost on 13-12-23.
//  Copyright (c) 2013年 junfrost. All rights reserved.
//

#import "UINavigationController+BarColorStyle.h"

@implementation UINavigationController (BarColorStyle)

- (void)setBarColor
{
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor darkTextColor],
                                               NSFontAttributeName : [UIFont systemFontOfSize:18.0],
                                               NSShadowAttributeName : [NSValue valueWithUIOffset:UIOffsetZero]};
//    if (mIos7) {
//        [self.navigationBar setBarTintColor:[UIColor red:15.0 green:112.0 blue:188.0 alpha:1.0]];
//    } else {
//        [self.navigationBar setTintColor:[UIColor red:15.0 green:112.0 blue:188.0 alpha:1.0]];
//    }
    if (mIos7) {
         [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"image_navi_bg_iOS7_or_greater"] forBarMetrics:UIBarMetricsDefault];
    }else{
         [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"image_navi_bg"] forBarMetrics:UIBarMetricsDefault];
    }
   
}


@end
