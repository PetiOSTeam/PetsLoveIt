//
//  HeadImageView.h
//  youbibuluo
//
//  Created by kongjun on 15/8/15.
//  Copyright (c) 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadImageView : UIImageView<UIGestureRecognizerDelegate>
@property (nonatomic,strong) NSString *userId;
@end
