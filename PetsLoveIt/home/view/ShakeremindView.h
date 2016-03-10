//
//  ShakeremindView.h
//  PetsLoveIt
//
//  Created by 123 on 15/12/22.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeremindView : UIView
/** 
   第一行标签
 */
@property (nonatomic,weak) UILabel *lable1;
/**
   第二行标签
 */
@property (nonatomic,weak) UILabel *lable2;
/**
 左边按钮
 */
@property (nonatomic,weak) UIButton *lelftButton;
/**
 右边按钮
 */
@property (nonatomic,weak) UIButton *rightButton;
/**
 是否隐藏右边按钮
 */
@property (nonatomic,assign) BOOL hidesrightButton;

@end
