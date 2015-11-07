//
//  UIAlertView+Addition.m
//  smartcity
//
//  Created by kongjun on 13-11-1.
//  Copyright (c) 2013年 junfrost. All rights reserved.
//

#import "UIAlertView+Addition.h"

@implementation UIAlertView (Addition)

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}



@end
