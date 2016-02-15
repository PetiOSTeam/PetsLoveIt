//
//  BaoliaoView.h
//  PetsLoveIt
//
//  Created by 123 on 16/1/6.
//  Copyright © 2016年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BaoliaoViewDelegate <NSObject>

@optional
- (void) clickButtonWithtype:(NSString *)apptype;

@end

@interface BaoliaoView : UIView
@property (nonatomic,weak) id<BaoliaoViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *youhuiButton;
@property (weak, nonatomic) IBOutlet UIButton *haitaoButton;
@property (weak, nonatomic) IBOutlet UIButton *taochongButton;
/**
 *  爆料详情数目具体以数字形式展现，一次是优惠，海淘，淘宠
 */
@property (strong,nonatomic) NSArray *detailsNums;

@end
