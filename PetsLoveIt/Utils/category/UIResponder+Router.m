//
//  UIResponder+Router.m
//  TeamWork
//
//  Created by kongjun on 14-9-17.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end
