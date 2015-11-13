//
//  XLSlideBarView.h
//  TeamWork
//
//  Created by 廖先龙 on 14-10-5.
//  Copyright (c) 2014年 Shenghuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLSlideBarView;
@protocol XLSlideBarDelegate <NSObject>

- (void)selectItemWithPage:(int)page withObject:(XLSlideBarView *)slideBar;

@end

@interface XLSlideBarView : UIView

@property (nonatomic, strong) UIScrollView *slideView;

@property (nonatomic, assign) id<XLSlideBarDelegate> delegate;

- (id)initWithItems:(NSArray *)items
          withFrame:(CGRect)frame
       withDelegate:(id<XLSlideBarDelegate>)delegate;

- (void)changeItem:(float)x;

- (void)changeSelectedItemWithOffsetX:(float)x;

@end
