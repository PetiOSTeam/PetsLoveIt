//
//  HeadImageView.m
//  youbibuluo
//
//  Created by kongjun on 15/8/15.
//  Copyright (c) 2015年 kongjun. All rights reserved.
//

#import "HeadImageView.h"

@implementation HeadImageView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    //头像点击方法
    [self addTapGesture];
}

-(void)addTapGesture{
    UITapGestureRecognizer *singleFingerViewMore = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(fingerIncidentDetail:)];
    //手指数
    singleFingerViewMore.numberOfTouchesRequired = 1;
    //点击次数
    singleFingerViewMore.numberOfTapsRequired = 1;
    //设置代理方法
    singleFingerViewMore.delegate= self;
    //增加事件者响应者，
    [self addGestureRecognizer:singleFingerViewMore];
    
}

-(void)fingerIncidentDetail:(UITapGestureRecognizer *)sender{
    if ([_userId length]>0) {
//        PersonInfoViewController *controller = [[PersonInfoViewController alloc] init];
//        controller.isOther = YES;
//        controller.userId = _userId;
//        [mAppDelegate.rootNavigationController pushViewController:controller animated:YES];
    }
}

@end
