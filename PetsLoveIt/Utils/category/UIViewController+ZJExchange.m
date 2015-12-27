//
//  UIScrollView+ZJExchange.m
//  滚动效果
//
//  Created by Joon on 15/11/9.
//  Copyright © 2015年 Joon. All rights reserved.
//

#import "UIViewController+ZJExchange.h"
#import <objc/runtime.h>


@implementation UIViewController (ZJExchange)

static const char kBottomChangeTextKey = 'a';
static const char kTopChangeTextKey = 'b';

static const char kTopScrollViewKey = 'c';
static const char kBottomScrollViewKey = 'd';

static const char kTopFrameKey = 'e';
static const char kDisplayFrameKey = 'f';
static const char kBottomFrameKey = 'g';


- (void)addExchangeWithTopScrollView:(UIScrollView *)topScrollView
                    BottomScrollView:(UIScrollView *)bottomScrollView {
    
    //移除旧的
    [self removeZJExchangeObserver];
    
    //设置上中下三个frame
    self.topScrollView = topScrollView;
    self.bottomScrollView = bottomScrollView;
    
    CGRect displayFrame = self.topScrollView.frame;
    self.displayFrameValue = [NSValue valueWithCGRect:displayFrame];
    
    self.topFrameValue = [NSValue valueWithCGRect:CGRectMake(0, -displayFrame.size.height, displayFrame.size.width, displayFrame.size.height)];
    self.bottomFrameValue = [NSValue valueWithCGRect:CGRectMake(0, mScreenHeight+displayFrame.size.height, displayFrame.size.width,displayFrame.size.height)];
    
    self.bottomScrollView.frame = [self.bottomFrameValue CGRectValue];
    
    //添加滚动控件的顶部以及底部控件
    UILabel *bottomLabel = [topScrollView viewWithTag:mBottomChangeViewTag];
    UILabel *topLabel = [bottomScrollView viewWithTag:mTopChangeViewTag];
    if (!bottomLabel) {
        bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topScrollView.contentSize.height, topScrollView.bounds.size.width, mChangeViewHeight)];
        bottomLabel.tag = mBottomChangeViewTag;
        bottomLabel.backgroundColor = mChangeViewBg;
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.textColor = [UIColor grayColor];
        bottomLabel.font = [UIFont systemFontOfSize:13];
        bottomLabel.text = self.bottomChangeText?:mBottomChangeText;
        [self.topScrollView addSubview:bottomLabel];
    }
    if (!topLabel) {
        topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -mChangeViewHeight, bottomScrollView.bounds.size.width, mChangeViewHeight)];
        topLabel.tag = mTopChangeViewTag;
        topLabel.backgroundColor = mChangeViewBg;
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.textColor = [UIColor grayColor];
        topLabel.font = [UIFont systemFontOfSize:13];
        topLabel.text = self.topChangeText?:mTopChangeText;
        [self.bottomScrollView addSubview:topLabel];
    }
    //增加新的
    [self addObserver];
}


#pragma mark - KVO
- (void)addObserver {
    [self.topScrollView.panGestureRecognizer addObserver:self
                                              forKeyPath:mGestureStateKeyPath
                                                 options:NSKeyValueObservingOptionNew
                                                 context:nil];
    [self.topScrollView addObserver:self
                         forKeyPath:mContentSizeKeyPath
                            options:NSKeyValueObservingOptionNew
                            context:nil];
    
    [self.bottomScrollView.panGestureRecognizer addObserver:self
                                                 forKeyPath:mGestureStateKeyPath
                                                    options:NSKeyValueObservingOptionNew
                                                    context:nil];
}

- (void)removeZJExchangeObserver {
    [self.topScrollView removeObserver:self forKeyPath:mContentSizeKeyPath];
    [self.topScrollView.panGestureRecognizer removeObserver:self forKeyPath:mGestureStateKeyPath];
    [self.bottomScrollView.panGestureRecognizer removeObserver:self forKeyPath:mGestureStateKeyPath];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
   // NSLog(@"=========keypath:%@\n=========object:%@\n===========change:%@", keyPath, object, change);
    if ([keyPath isEqualToString:mContentSizeKeyPath] && [object isEqual:self.topScrollView]) {
        CGSize newContentSize = [change[@"new"] CGSizeValue];
        newContentSize.height = newContentSize.height<mScreenHeight-49?mScreenHeight-49:newContentSize.height;
        UILabel *bottomLabel = [self.topScrollView viewWithTag:mBottomChangeViewTag];
        bottomLabel.frame = CGRectMake(0, newContentSize.height, bottomLabel.frame.size.width, bottomLabel.frame.size.height);
    }
    if ([keyPath isEqualToString:mGestureStateKeyPath]) {
        UIGestureRecognizerState state = (UIGestureRecognizerState)[change[@"new"] integerValue];
        if (state == UIGestureRecognizerStateEnded) {
            if ([object isEqual:self.topScrollView.panGestureRecognizer]) {
                if (self.topScrollView.contentOffset.y >= self.topScrollView.contentSize.height - self.topScrollView.bounds.size.height + mChangeViewHeight) {
                    [self moveUp];
                }
            }
            if ([object isEqual:self.bottomScrollView.panGestureRecognizer]) {
                if (self.bottomScrollView.contentOffset.y <= -mChangeViewHeight) {
                    [self moveDown];
                }
            }
        }
    }
}


- (void)moveUp {
    [UIView animateWithDuration:0.5 animations:^{
        self.topScrollView.frame = [self.topFrameValue CGRectValue];
        self.bottomScrollView.frame = [self.displayFrameValue CGRectValue];
        //fix tableView2 height and top
        self.bottomScrollView.top =  self.bottomScrollView.frame.origin.y + 64;
        self.bottomScrollView.height =self.bottomScrollView.frame.size.height - 64;
    }];
}

- (void)moveDown {
    [UIView animateWithDuration:0.5 animations:^{
        self.topScrollView.frame = [self.displayFrameValue CGRectValue];
        self.bottomScrollView.frame = [self.bottomFrameValue CGRectValue];
    }];
}


#pragma mark - Property Getter and Setter
- (void)setTopFrameValue:(NSValue *)topFrameValue {
    objc_setAssociatedObject(self, &kTopFrameKey, topFrameValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)topFrameValue {
    return objc_getAssociatedObject(self, &kTopFrameKey);
}

- (void)setDisplayFrameValue:(NSValue *)displayFrameValue {
    objc_setAssociatedObject(self, &kDisplayFrameKey, displayFrameValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)displayFrameValue {
    return objc_getAssociatedObject(self, &kDisplayFrameKey);
}

- (void)setBottomFrameValue:(NSValue *)bottomFrameValue {
    objc_setAssociatedObject(self, &kBottomFrameKey, bottomFrameValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)bottomFrameValue {
    return objc_getAssociatedObject(self, &kBottomFrameKey);
}

- (void)setTopScrollView:(UIScrollView *)topScrollView {
    objc_setAssociatedObject(self, &kTopScrollViewKey, topScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollView *)topScrollView {
    return objc_getAssociatedObject(self, &kTopScrollViewKey);
}

- (void)setBottomScrollView:(UIScrollView *)bottomScrollView {
    objc_setAssociatedObject(self, &kBottomScrollViewKey, bottomScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollView *)bottomScrollView {
    return objc_getAssociatedObject(self, &kBottomScrollViewKey);
}


- (void)setBottomChangeText:(NSString *)bottomChangeText {
    objc_setAssociatedObject(self, &kBottomChangeTextKey, bottomChangeText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)bottomChangeText {
    return objc_getAssociatedObject(self, &kBottomChangeTextKey);
}

- (void)setTopChangeText:(NSString *)topChangeText {
    objc_setAssociatedObject(self, &kTopChangeTextKey, topChangeText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)topChangeText {
    return objc_getAssociatedObject(self, &kTopChangeTextKey);
}

@end
