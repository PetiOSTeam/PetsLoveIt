//
//  UIView+Addition.h
//  smartcity
//
//  Created by kongjun on 13-11-1.
//  Copyright (c) 2013年 junfrost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)
- (UIView *)subViewWithTag:(int)tag;
//获取view的controller
- (UIViewController *)viewController;
@end
