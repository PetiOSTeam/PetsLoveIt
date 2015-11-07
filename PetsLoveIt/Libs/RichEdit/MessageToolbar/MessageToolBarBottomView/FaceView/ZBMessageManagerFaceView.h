//
//  MessageFaceView.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-12.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBFaceView.h"
#import "ZBExpressionSectionBar.h"

@protocol ZBMessageManagerFaceViewDelegate <NSObject>

- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele;

- (void)sendEmoji;

@end

@interface ZBMessageManagerFaceView : UIView<UIScrollViewDelegate,ZBFaceViewDelegate, ZBExpressionSectionBarDelegate>

@property (nonatomic, strong) ZBExpressionSectionBar *sectionBar;

@property (nonatomic,weak)id<ZBMessageManagerFaceViewDelegate>delegate;
@property (nonatomic, assign) BOOL hiddenSendButton;


@end
