//
//  BottomMenuView.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomMenuViewDelegate <NSObject>

@optional
- (void) showPersonInfoVC;
- (void) lastMenuAction;
- (void) showCommentVC;
- (void) showLoginVC;

@end
@interface BottomMenuView : UIView

@property (nonatomic,weak) id<BottomMenuViewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame menuType:(DetailPageType)type;

@end
