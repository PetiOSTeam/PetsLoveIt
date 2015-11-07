//
//  UIView+Addition.m
//  smartcity
//
//  Created by kongjun on 13-11-1.
//  Copyright (c) 2013年 junfrost. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

- (UIView *)subViewWithTag:(int)tag
{
	for (UIView *v in self.subviews)
    {
		if (v.tag == tag)
        {
			return v;
		}
	}
	return nil;
}
//获取view的controller
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
