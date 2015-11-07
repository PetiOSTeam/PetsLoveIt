
//
//  RichEditView.m
//  TeamWork
//
//  Created by kongjun on 15-2-2.
//  Copyright (c) 2015年 Shenghuo. All rights reserved.
//

#import "RichEditView.h"
#import "RichEditMoreView.h"
#import <AVFoundation/AVFoundation.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RichEditView()<DXChatBarMoreViewDelegate, DXMessageToolBarDelegate,UITextViewDelegate>
@property (weak, nonatomic) UIViewController *parentVC;
@property (nonatomic,assign) CGFloat editWidth;
@property (nonatomic,assign) CGFloat editHeight;

@property (nonatomic,strong)  UILabel *placeHolderLabel;
@end

@implementation RichEditView{
    NSString *imageSelectedUrl;
     AVAudioPlayer *audioPlayer;
    NSString *bodyContent;

}


-(instancetype) initWithRichEditFrame:(CGRect)frame hideToolBarInputView:(BOOL)hidden{
    self = [self initWithFrame:frame];
    if (self) {
        self.editWidth = frame.size.width;
        self.editHeight = frame.size.height;
        self.parentVC = [self viewController];
        self.hideToolBarInputView = hidden;
        [self addSubview:self.textView];
    }
    return self;
}

- (void)setInputTextFontSize:(CGFloat)fontSize placeHolder:(NSString *)placeHolder{
    [self.textView setFont:[UIFont systemFontOfSize:fontSize]];
    self.placeHolderLabel.text = placeHolder;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    // 当别的地方需要add的时候，就会调用这里
    if (newSuperview) {
        
    }
    [super willMoveToSuperview:newSuperview];
}

-(UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 8, self.editWidth -20, 20)];
        [_placeHolderLabel setFont:_textView.font];
        [_placeHolderLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_placeHolderLabel];
    }
    return _placeHolderLabel;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.editWidth-20, self.editHeight)];
        [_textView setBackgroundColor:kAppDefaultColor];
        _textView.delegate = self;
    }
    return _textView;
}
- (RichEditToolBar *)editToolBar
{
    if (_editToolBar == nil) {
        _editToolBar = [[RichEditToolBar alloc] initWithFrame:CGRectMake(0, mScreenHeight- [RichEditToolBar defaultHeight], mScreenWidth, [RichEditToolBar defaultHeight]) hideInputView:self.hideToolBarInputView];
        NSLog(@"%f,%f",_editToolBar.top,_editToolBar.height);
        _editToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _editToolBar.delegate = self;
    }
    
    return _editToolBar;
}
-(UIViewController *)parentVC{
    if (_parentVC == nil) {
        _parentVC = [self viewController];
    }
    return _parentVC;
}

#pragma textView delegate
-(void)textViewDidChange:(UITextView *)textView{

    self.placeHolderLabel.hidden =[textView.text length]>0?YES:NO;
    self.editToolBar.inputTextView.text = textView.text;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self.editToolBar.faceButton setSelected:NO];
    return YES;
}


#pragma mark editToolBar delegate 同步RichEditView与toolBar里面的inputTextView
//经过表情编码的text
-(void)didSendText:(NSString *)text{
    if ([self.delegate respondsToSelector:@selector(sendEncodeEmojiText:)]) {
        [self.delegate sendEncodeEmojiText:text];
    }
}

-(void)richEditViewResignFirstResponse{
    [self.textView resignFirstResponder];
}

-(void)richEditViewBecomeFirstResponse{
    [self.textView becomeFirstResponder];
}

-(void)inputTextViewDidChanged:(NSString *)text{
    self.textView.text = text;
    self.placeHolderLabel.hidden =[text length]>0?YES:NO;
}
- (void)didChangeFrameToHeight:(CGFloat)toHeight keyboardInfo:(NSDictionary *)userInfo
{
        NSInteger cuver = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationCurve:cuver];
        [UIView setAnimationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        CGRect rect = self.textView.frame;
        rect.size.height = self.parentVC.view.frame.size.height - toHeight;
        self.textView.frame = rect;
    
        [UIView commitAnimations];
}



@end
