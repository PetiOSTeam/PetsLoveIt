//
//  RichEditView.h
//  TeamWork
//
//  Created by kongjun on 15-2-2.
//  Copyright (c) 2015年 Shenghuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichEditToolBar.h"

@protocol RichEditViewDelegate;
@interface RichEditView : UIView

-(instancetype) initWithRichEditFrame:(CGRect)frame hideToolBarInputView:(BOOL)hidden;

- (void)setInputTextFontSize:(CGFloat)fontSize placeHolder:(NSString *)placeHolder;

@property (assign,nonatomic) BOOL hideToolBarInputView;
@property (strong, nonatomic) RichEditToolBar *editToolBar;
@property (nonatomic,strong) UITextView *textView;

@property (assign,nonatomic) id<RichEditViewDelegate> delegate;

@end

@protocol RichEditViewDelegate <NSObject>

@optional

- (void) sendEncodeEmojiText:(NSString *)text;

@end
