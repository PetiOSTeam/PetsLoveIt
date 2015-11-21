//
//  XLLoadingView.h
//  XianRenZhang
//
//  Created by 廖先龙 on 15/1/16.
//  Copyright (c) 2015年 廖先龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackBlock)();

@interface XLLoadingView : UIView

@property (nonatomic, copy) NSString *titleText;

@property (nonatomic, assign) BOOL isActive;

@property (nonatomic, copy) CallBackBlock actionBlock;

- (void)setTitle:(NSString *)titleText active:(BOOL)active;

- (void)dismiss;

@end
