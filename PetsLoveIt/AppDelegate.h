//
//  AppDelegate.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/4.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalUserInfoModelClass.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *rootNavigationController;
@property (strong, nonatomic) LocalUserInfoModelClass *loginUser;
- (void)autoLogin;
@end

