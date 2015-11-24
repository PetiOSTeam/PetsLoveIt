//
//  CMView.h
//  CoreViewNetWorkStausManager
//
//  Created by muxi on 15/3/12.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreViewNetWorkStausManager.h"

@interface CMView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *imageView;


+(instancetype)cmViewWithType:(CMType)type msg:(NSString *)msg subMsg:(NSString *)subMsg offsetY:(CGFloat)offsetY failClickBlock:(void(^)())failClickBlock;



@end
