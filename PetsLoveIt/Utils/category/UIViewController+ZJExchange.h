//
//  UIScrollView+ZJExchange.h
//  滚动效果
//
//  Created by Joon on 15/11/9.
//  Copyright © 2015年 Joon. All rights reserved.
//

#define mChangeViewBg [UIColor clearColor]


#define mBottomChangeViewTag 8888
#define mTopChangeViewTag 8889
#define mChangeViewHeight 40

#define mGestureStateKeyPath @"state"
#define mContentSizeKeyPath @"contentSize"

#define mBottomChangeText @"继续拖动，查看相关推荐"
#define mTopChangeText @"下拉，返回文章详情"


#import <UIKit/UIKit.h>

@interface UIViewController (ZJExchange)

//@property (assign, nonatomic, setter=setTopFrame:, getter=topFrame) CGRect topFrame;
//@property (assign, nonatomic, setter=setDisplayFrame:, getter=displayFrame) CGRect displayFrame;
//@property (assign, nonatomic, setter=setBottomFrame:, getter=bottomFrame) CGRect bottomFrame;

@property (strong, nonatomic) NSValue *topFrameValue, *displayFrameValue, *bottomFrameValue;

@property (strong, nonatomic) UIScrollView *topScrollView, *bottomScrollView;
@property (copy, nonatomic) NSString *bottomChangeText, *topChangeText;

- (void)addExchangeWithTopScrollView:(UIScrollView *)topScrollView BottomScrollView:(UIScrollView *)bottomScrollView;

- (void)removeZJExchangeObserver;

@end
