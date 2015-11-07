//
//  UIApplication+NetworkActivityIndicator.m
//  Hyman
//
//  Created by Hyman Wang on 7/6/13.
//  Copyright (c) 2013. All rights reserved.
//

#import "UIApplication+NetworkActivityIndicator.h"

@implementation UIApplication (NetworkActivityIndicator)

- (void)toggleNetworkActivityIndicatorVisible:(BOOL)visible
{
    static int activityCount = 0;
    @synchronized (self) {
        if (visible) {
            activityCount++;
        } else {
            activityCount--;
        }
        self.networkActivityIndicatorVisible = activityCount > 0;
    }
}

@end
