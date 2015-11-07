//
//  UITableViewCell+Addition.m
//  TeamWork
//
//  Created by kongjun on 14-10-29.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import "UITableViewCell+Addition.h"

@implementation UITableViewCell (Addition)
-(void) addSeparatorLine
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, mScreenWidth, 0.5)];
    [view setBackgroundColor:mRGBAColor(207, 207, 207, 1)];
    [self.contentView addSubview:view];
}
@end
