//
//  UIView+AddBorder.h
//  TeamWork
//
//  Created by kongjun on 14-7-2.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AddBorder)

- (void)addBottomBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addLeftBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addRightBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addTopBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addBorderWithFrame:(CGRect)frame andColor:(UIColor *)color andWidth:(CGFloat) borderWidth;
@end
