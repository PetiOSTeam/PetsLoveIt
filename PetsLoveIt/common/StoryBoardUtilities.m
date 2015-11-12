//
//  StoryBoardUtilities.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 09/02/2013.
//  Copyright (c) 2013 iKode Ltd. All rights reserved.
//

#import "StoryBoardUtilities.h"

@implementation StoryBoardUtilities

+ (UIViewController*)viewControllerForStoryboardName:(NSString*)storyboardName class:(id)class
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    NSString* className = nil;
    
    if ([class isKindOfClass:[NSString class]])
        className = [NSString stringWithFormat:@"%@", class];
    else
        className = [NSString stringWithFormat:@"%s", class_getName([class class])];
    
    UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"%@", className]];
    return viewController;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com