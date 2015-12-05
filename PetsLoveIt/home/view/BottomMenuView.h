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
- (void) lastMenuAction:(DetailPageType) type;
- (void) showCommentVC;
- (void) showLoginVC;
- (void) praiseProduct:(BOOL)praiseFlag;
- (void) collectProduct:(BOOL)collectFlag;

@end
@interface BottomMenuView : UIView

@property (strong, nonatomic)  UIButton *menuButton1;
@property (strong, nonatomic)  UIButton *menuButton2;
@property (strong, nonatomic)  UIButton *menuButton3;
@property (strong, nonatomic)  UIButton *menuButton4;

@property (nonatomic,weak) id<BottomMenuViewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame menuType:(DetailPageType)type;
@property (nonatomic,strong) NSString *avatarUrl;

- (void) loadAvatarImage:(NSString *)avatar;
@end
