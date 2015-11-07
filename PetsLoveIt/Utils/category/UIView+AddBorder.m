//
//  UIView+AddBorder.m
//  TeamWork
//
//  Created by kongjun on 14-7-2.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import "UIView+AddBorder.h"

@implementation UIView (AddBorder)

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    [self.layer  addSublayer:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;

    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

- (void)addBorderWithFrame:(CGRect)frame andColor:(UIColor *)color andWidth:(CGFloat) borderWidth{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame =frame;
    [self.layer addSublayer:border];
}

@end
