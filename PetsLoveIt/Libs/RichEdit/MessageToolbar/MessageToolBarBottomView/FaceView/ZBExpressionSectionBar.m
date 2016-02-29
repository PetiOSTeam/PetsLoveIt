//
//  ZBExpressionSectionBar.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "ZBExpressionSectionBar.h"

@interface ZBExpressionSectionBar ()

@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation ZBExpressionSectionBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = mRGBColor(245, 245, 245);
        [self addTopBorderWithColor:[UIColor lightGrayColor] andWidth:.5f];
        
        UIButton *defFaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        defFaceButton.backgroundColor = [UIColor lightGrayColor];
        [defFaceButton setImage:[UIImage imageNamed:@"EmotionsEmojiHL"]
                       forState:UIControlStateNormal];
        defFaceButton.width = 30;
        defFaceButton.height = 30;
        defFaceButton.left = 5;
        defFaceButton.top = 2.5;
        if (defFaceButton.imageView.image != nil) {
            [self addSubview:defFaceButton];
        }
        
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *normalImage = [UIImage imageNamed:@"EmotionsSendBtnBlue"];
        UIImage *disImage = [UIImage imageNamed:@"EmotionsSendBtnGrey"];
        UIImage *selectImage = [UIImage imageNamed:@"EmotionsSendBtnBlueHL"];
        [sendButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [sendButton setBackgroundImage:disImage forState:UIControlStateDisabled];
        [sendButton setBackgroundImage:selectImage forState:UIControlStateHighlighted];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        sendButton.contentEdgeInsets = UIEdgeInsetsMake(0, 6.f, 0, 0);
        [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        sendButton.height = self.height;
        sendButton.width = normalImage.size.width;
        sendButton.top = 0;
        sendButton.right = self.width;
        [sendButton addTarget:self
                       action:@selector(clickActionWithSend:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendButton];
        self.sendButton = sendButton;
        self.sendButton.hidden = self.hiddenSendButton;
    }
    return self;
}

- (void)changeSendButtonState:(NSString *)objectText
{
    NSString *text = objectText;
    if ([text isEqualToString:@""]) {
        self.sendButton.enabled = NO;
        [self.sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }else {
        self.sendButton.enabled = YES;
        [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    }
}

- (void)clickActionWithSend:(id)sender
{
    if ([_delegate respondsToSelector:@selector(sendEmojiWithBar:)]) {
        [_delegate sendEmojiWithBar:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
