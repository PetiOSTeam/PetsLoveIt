//
//  ZBExpressionSectionBar.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBExpressionSectionBar;

@protocol ZBExpressionSectionBarDelegate <NSObject>

- (void)sendEmojiWithBar:(ZBExpressionSectionBar *)sectionBar;

@end

@interface ZBExpressionSectionBar : UIView

- (void)changeSendButtonState:(NSString *)objectText;

@property (nonatomic, assign) id<ZBExpressionSectionBarDelegate> delegate;
@property (nonatomic, assign) BOOL hiddenSendButton;

@end
