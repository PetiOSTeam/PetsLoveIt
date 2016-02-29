

#import "DXMessageToolBar.h"
#import "TWEmojHelper.h"
#import "TWImagePicker.h"

@interface DXMessageToolBar()<UITextViewDelegate, DXFaceDelegate>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}

@property (nonatomic) CGFloat version;

/**
 *  背景
 */
@property (strong, nonatomic) UIImageView *toolbarBackgroundImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;

/**
 *  按钮、输入框、toolbarView
 */
@property (strong, nonatomic) UIView *toolbarView;
@property (strong, nonatomic) UIButton *styleChangeButton;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIButton *faceButton;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UIButton *serveButton; //服务号按钮

@property (nonatomic, assign) BOOL isSelectFace; //判断点击表情

/**
 *  底部扩展页面
 */
@property (nonatomic) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面

@property (strong, nonatomic) NSDictionary *keyboardNotificationDict;

@property (assign, nonatomic) BOOL isRecord;

@end

@implementation DXMessageToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupConfigure];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    [super setFrame:frame];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    // 当别的地方需要add的时候，就会调用这里
    if (newSuperview) {
        [self setupSubviews];
    }
    
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    _delegate = nil;
    _inputTextView.delegate = nil;
    _inputTextView = nil;
}

#pragma mark - getter

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    return _backgroundImageView;
}

- (UIImageView *)toolbarBackgroundImageView
{
    if (_toolbarBackgroundImageView == nil) {
        _toolbarBackgroundImageView = [[UIImageView alloc] init];
        _toolbarBackgroundImageView.backgroundColor = [UIColor clearColor];
        _toolbarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _toolbarBackgroundImageView;
}

- (UIView *)toolbarView
{
    if (_toolbarView == nil) {
        _toolbarView = [[UIView alloc] init];
        _toolbarView.backgroundColor = [UIColor clearColor];
    }
    
    return _toolbarView;
}

- (NSDictionary *)keyboardNotificationDict
{
    if (!_keyboardNotificationDict) {
        _keyboardNotificationDict = @{UIKeyboardAnimationDurationUserInfoKey: [NSNumber numberWithDouble:.25],
                                      UIKeyboardAnimationCurveUserInfoKey: [NSNumber numberWithInteger:7]};
    }
    return _keyboardNotificationDict;
}
#pragma mark - setter

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setToolbarBackgroundImage:(UIImage *)toolbarBackgroundImage
{
    _toolbarBackgroundImage = toolbarBackgroundImage;
    self.toolbarBackgroundImageView.image = toolbarBackgroundImage;
}

- (void)setMaxTextInputViewHeight:(CGFloat)maxTextInputViewHeight
{
    if (maxTextInputViewHeight > kInputTextViewMaxHeight) {
        maxTextInputViewHeight = kInputTextViewMaxHeight;
    }
    _maxTextInputViewHeight = maxTextInputViewHeight;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    
    self.faceButton.selected = NO;
    self.styleChangeButton.selected = NO;
    self.moreButton.selected = NO;
    [self.faceView.facialView.sectionBar changeSendButtonState:self.inputTextView.text];
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
    //判断光标是否在表情中中
    NSRange result = [TWEmojHelper checkCousorInEmojRangeWithText:textView.text selectedRange:textView.selectedRange];
    if (!NSEqualRanges(result, textView.selectedRange)) {
        textView.selectedRange = result;
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    // 发送操作
    if ([text isEqualToString:@"\n"]) {
        return [self sendFace];
    }
    
    if (textView.text.length > 0 && [text isEqualToString:@""]) {
        if ([self deleteAtFriend]) {  // 如果是删除，删除成功则返回No
            return NO;
        }
        
        if ([self deleteEmoji]) { // 如果是删除，删除成功则返回No
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
    [self.faceView.facialView.sectionBar changeSendButtonState:self.inputTextView.text];
}

#pragma mark - DXFaceDelegate

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSMutableString *chatText = [[NSMutableString alloc] initWithString:self.inputTextView.text];
    NSRange selectRange = self.inputTextView.selectedRange;
    
    if (!isDelete && str.length > 0) {
        
        NSString *tempInputStr = [TWEmojHelper decodeEmojCodeToChineseWithText:str];
        
        [self.inputTextView.delegate textView:self.inputTextView
                      shouldChangeTextInRange:selectRange
                              replacementText:tempInputStr];
        
        if (chatText.length > 0) {
            [chatText replaceCharactersInRange:selectRange withString:tempInputStr];
        } else {
            [chatText appendString:tempInputStr];
        }
        
        self.inputTextView.text = chatText;
        [self.inputTextView setContentOffset:CGPointMake(0, self.inputTextView.contentSize.height - self.inputTextView.height) animated:YES];
        
        selectRange.location += tempInputStr.length;
        selectRange.length = 0;
        self.inputTextView.selectedRange = selectRange;
    } else {
        if (chatText.length > 0) {
            if (![self deleteAtFriend]) {
                if (![self deleteEmoji]) {
                    
                    NSString *tempInputStr = [chatText substringToIndex:chatText.length-1];
                    self.inputTextView.text = tempInputStr;
                    NSRange subRange = NSMakeRange(selectRange.location - 1, selectRange.length == 0 ? 1 : selectRange.length);
                    [chatText deleteCharactersInRange:subRange];
                }
            }
        }
    }
    [self textViewDidChange:self.inputTextView];
}

/**
 *  发送消息
 *
 *  @return 是否发送成功
 */
- (BOOL)sendFace
{
    NSString *chatText = self.inputTextView.text;
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            NSString *sendMsg = chatText;   // 处理AtFriend
//            sendMsg = [TWEmojHelper encodeEmojChineseToCodeWithText:sendMsg];                           // 处理表情
            [self.delegate didSendText:sendMsg];
            self.inputTextView.text = @"";
          
            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];
        }
    }
    
    return NO;
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    id vc = [mAppDelegate.rootNavigationController.viewControllers lastObject];
    if (![NSStringFromClass([vc class]) isEqualToString:@"PrivateChatViewController"] && ![NSStringFromClass([vc class]) isEqualToString:@"TWGroupChatViewController"]
        && ![NSStringFromClass([vc class]) isEqualToString:@"TaskDetailViewController"]) {
        return;
    }

    self.keyboardNotificationDict = notification.userInfo;
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
}


#pragma mark - private

/**
 *  设置初始属性
 */
- (void)setupConfigure
{
    self.backgroundColor = [UIColor clearColor];
    self.version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    self.maxTextInputViewHeight = kInputTextViewMaxHeight;
    
    self.activityButtomView = nil;
    self.isShowButtomView = NO;
    self.backgroundImageView.image = [[UIImage imageNamed:@"messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
    [self addSubview:self.backgroundImageView];
    
    self.toolbarView.frame = CGRectMake(0, 0, self.frame.size.width, kVerticalPadding * 2 + kInputTextViewMinHeight);
    self.toolbarBackgroundImageView.frame = self.toolbarView.bounds;
    [self.toolbarView addSubview:self.toolbarBackgroundImageView];
    [self addSubview:self.toolbarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupSubviews
{
    CGFloat allButtonWidth = 0.0;
    CGFloat textViewLeftMargin = 6.0;
    self.backgroundColor = [UIColor clearColor];
    
    //转变输入样式
    self.styleChangeButton = [[UIButton alloc] initWithFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
//    self.styleChangeButton = [[UIButton alloc] initWithFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, 0 , 0)];
    self.styleChangeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.styleChangeButton setImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];
    [self.styleChangeButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [self.styleChangeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.styleChangeButton.tag = 0;
    allButtonWidth += CGRectGetMaxX(self.styleChangeButton.frame);
    textViewLeftMargin += CGRectGetMaxX(self.styleChangeButton.frame);
    
    
    //更多
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kHorizontalPadding - kInputTextViewMinHeight, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.moreButton setImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:@"chatBar_moreSelected"] forState:UIControlStateHighlighted];
    [self.moreButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [self.moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.moreButton.tag = 2;
    allButtonWidth += CGRectGetWidth(self.moreButton.frame) + kHorizontalPadding * 2.5;
    
    //表情
    self.faceButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.moreButton.frame) - kInputTextViewMinHeight - kHorizontalPadding + 3, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.faceButton setImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
    [self.faceButton setImage:[UIImage imageNamed:@"chatBar_faceSelected"] forState:UIControlStateHighlighted];
    [self.faceButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [self.faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.faceButton.tag = 1;
    allButtonWidth += CGRectGetWidth(self.faceButton.frame) + kHorizontalPadding * 1.5;
    
    
    // 输入框的高度和宽度
    CGFloat width = CGRectGetWidth(self.bounds) - (allButtonWidth ? allButtonWidth : (textViewLeftMargin * 2));
    // 初始化输入框
    //self.inputTextView = [[XHMessageTextView  alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight)];
    self.inputTextView = [[XHMessageTextView  alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight)];
    self.inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //    self.inputTextView.contentMode = UIViewContentModeCenter;
    _inputTextView.scrollEnabled = YES;
    _inputTextView.returnKeyType = UIReturnKeySend;
    //    _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    _inputTextView.placeHolder = @"输入新消息";
    if (IOS_VERSION_7_OR_ABOVE) {
          _inputTextView.layoutManager.allowsNonContiguousLayout = NO;
    }
    _inputTextView.delegate = self;
    _inputTextView.backgroundColor = [UIColor clearColor];
    _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _inputTextView.layer.borderWidth = 0.65f;
    _inputTextView.layer.cornerRadius = 6.0f;
    _previousTextViewContentHeight = [self getTextViewContentH:_inputTextView];
    
    //录制
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(textViewLeftMargin + 5, kVerticalPadding, width, kInputTextViewMinHeight)];
    self.recordButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.recordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    UIImage *normalImage = [[UIImage imageNamed:@"chatBar_recordBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeTile];
    UIImage *selectImage = [[UIImage imageNamed:@"chatBar_recordSelectedBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeTile];

    [self.recordButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.recordButton setBackgroundImage:selectImage forState:UIControlStateHighlighted];
    [self.recordButton setTitle:kTouchToRecord forState:UIControlStateNormal];
    [self.recordButton setTitle:kTouchToFinish forState:UIControlStateHighlighted];
    [self.recordButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
    self.recordButton.hidden = YES;
    [self.recordButton addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.recordButton addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.recordButton addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
    [self.recordButton addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];
    [self.recordButton addTarget:self action:@selector(recordCancel) forControlEvents:UIControlEventTouchCancel];
    self.recordButton.hidden = YES;
    
    if (!self.moreView) {
        self.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, _isGroup ? 180 : 90) isGroup:_isGroup];
        [self.moreView addTopBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
        self.moreView.backgroundColor = mRGBColor(247, 247, 247);
        self.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    if (!self.faceView) {
        self.faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, 200)];
        [self.faceView setDelegate:self];
        [self.faceView addTopBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
        self.faceView.backgroundColor = mRGBColor(247, 247, 247);
        self.faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    if (!self.recordView) {
        self.recordView = [[DXRecordView alloc] initWithFrame:CGRectMake(90, 130, 140, 140)];
    }
    
    [self.toolbarView addSubview:self.styleChangeButton];
    [self.toolbarView addSubview:self.moreButton];
    [self.toolbarView addSubview:self.faceButton];
    [self.toolbarView addSubview:self.inputTextView];
    [self.toolbarView addSubview:self.recordButton];
    
}

#pragma mark - change frame

- (void)willShowBottomHeight:(CGFloat)bottomHeight isAnimation:(BOOL)animation
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    } else {
        self.isShowButtomView = YES;
    }
    
    if (animation) {
        NSInteger cuver = [self.keyboardNotificationDict[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationCurve:cuver];
        [UIView setAnimationDuration:[self.keyboardNotificationDict[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        self.frame = toFrame;
        [UIView commitAnimations];
    }else {
        self.frame = toFrame;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(isInputViewEditing:keyboardInfo:)]) {
        [_delegate isInputViewEditing:self.isShowButtomView keyboardInfo:self.keyboardNotificationDict];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:keyboardInfo:)]) {
        [_delegate didChangeFrameToHeight:toHeight keyboardInfo:self.keyboardNotificationDict];
    }
}

- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activityButtomView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight isAnimation:YES];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
            
            NSInteger cuver = [self.keyboardNotificationDict[UIKeyboardAnimationCurveUserInfoKey] integerValue];
            [UIView beginAnimations:@"" context:nil];
            [UIView setAnimationCurve:cuver];
            [UIView setAnimationDuration:[self.keyboardNotificationDict[UIKeyboardAnimationDurationUserInfoKey] integerValue]];
            bottomView.frame = rect;
            [UIView commitAnimations];
        }
        
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:toFrame.size.height isAnimation:YES];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        if (!_isSelectFace) {
            [self willShowBottomHeight:0 isAnimation:YES];
        }
    }
    else{
        [self willShowBottomHeight:toFrame.size.height isAnimation:NO];
    }
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    } else {
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        NSInteger cuver = [self.keyboardNotificationDict[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationCurve:cuver];
        [UIView setAnimationDuration:[self.keyboardNotificationDict[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.toolbarView.frame;
        rect.size.height += changeHeight;
        self.toolbarView.frame = rect;
        [UIView commitAnimations];
        
        _previousTextViewContentHeight = toHeight;
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:keyboardInfo:)]) {
            [_delegate didChangeFrameToHeight:self.frame.size.height keyboardInfo:self.keyboardNotificationDict];
        }
    }
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if (self.version >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - action

- (void)buttonAction:(id)sender
{
    
    
    _isSelectFace = YES;
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    NSInteger tag = button.tag;
    
    switch (tag) {
        case 0://切换状态
        {
            if (button.selected) {
                self.faceButton.selected = NO;
                self.moreButton.selected = NO;
                //录音状态下，不显示底部扩展页面
                [self willShowBottomView:nil];
                
                //将inputTextView内容置空，以使toolbarView回到最小高度
                self.inputTextView.text = @"";
                [self textViewDidChange:self.inputTextView];
                [self.inputTextView resignFirstResponder];
            }
            else{
                //键盘也算一种底部扩展页面
                [self.inputTextView becomeFirstResponder];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.recordButton.hidden = !button.selected;
                self.inputTextView.hidden = button.selected;
            } completion:nil];
            
            if ([self.delegate respondsToSelector:@selector(didStyleChangeToRecord:)]) {
                [self.delegate didStyleChangeToRecord:button.selected];
            }
        }
            break;
        case 1://表情
        {
            if (button.selected) {
                self.moreButton.selected = NO;
                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
                if (self.styleChangeButton.selected) {
                    self.styleChangeButton.selected = NO;
                }
                else{//如果处于文字输入状态，使文字输入框失去焦点
                    [self.inputTextView resignFirstResponder];
                }
                
                [self willShowBottomView:self.faceView];
                [self.faceView.facialView.sectionBar changeSendButtonState:self.inputTextView.text];
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.recordButton.hidden = button.selected;
                    self.inputTextView.hidden = !button.selected;
                } completion:^(BOOL finished) {
                    
                }];
            } else {
                if (!self.styleChangeButton.selected) {
                    [self.inputTextView becomeFirstResponder];
                }
                else{
                    [self willShowBottomView:nil];
                }
            }
        }
            break;
        case 2://更多
        {
            if (button.selected) {
                self.faceButton.selected = NO;
                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
                if (self.styleChangeButton.selected) {
                    self.styleChangeButton.selected = NO;
                }
                else{//如果处于文字输入状态，使文字输入框失去焦点
                    [self.inputTextView resignFirstResponder];
                }
                
                [self willShowBottomView:self.moreView];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.recordButton.hidden = button.selected;
                    self.inputTextView.hidden = !button.selected;
                } completion:^(BOOL finished) {
                    
                }];
            } else {
                self.styleChangeButton.selected = NO;
                [self.inputTextView becomeFirstResponder];
            }
        }
            break;
        case 3://服务号
        {
            [self.inputTextView resignFirstResponder];
            self.faceButton.selected = NO;
            self.moreButton.selected = NO;
            self.styleChangeButton.selected = NO;
            if (_delegate && [_delegate respondsToSelector:@selector(messageToolBar:didServeButtonClicked:)]) {
                [_delegate messageToolBar:self didServeButtonClicked:button];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - **** Touch ****


- (void)recordButtonTouchDown
{
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonTouchDown];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didStartRecordingVoiceAction:)]) {
        [_delegate didStartRecordingVoiceAction:self.recordView];
    }
}

- (void)recordButtonTouchUpInside
{
    [self disableRecordButton];
    
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonTouchUpInside];
    }
    
    if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction:)])
    {
        [self.delegate didFinishRecoingVoiceAction:self.recordView];
    }
    
    [self.recordView removeFromSuperview];
}


- (void)recordButtonTouchUpOutside
{
    if (_delegate && [_delegate respondsToSelector:@selector(didCancelRecordingVoiceAction:)])
    {
        [_delegate didCancelRecordingVoiceAction:self.recordView];
    }
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonTouchUpOutside];
    }
    
    [self.recordView removeFromSuperview];
}

- (void)recordDragOutside
{
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonDragOutside];
    }
    
    if ([self.delegate respondsToSelector:@selector(didDragOutsideAction:)])
    {
        [self.delegate didDragOutsideAction:self.recordView];
    }
}

- (void)recordDragInside
{
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonDragInside];
    }
    
    if ([self.delegate respondsToSelector:@selector(didDragInsideAction:)])
    {
        [self.delegate didDragInsideAction:self.recordView];
    }
}

- (void)recordCancel
{
    NSLog(@"取消录音事件");
    [self recordButtonTouchUpOutside];
}

- (void)disableRecordButton
{
    [self.recordButton setEnabled:NO];
    
    [self performSelector:@selector(enableRecodeButton) withObject:nil afterDelay:1.0f];
}

- (void)enableRecodeButton
{
    [self.recordButton setEnabled:YES];
}

#pragma mark - public

/**
 *  停止编辑
 */
- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    self.faceButton.selected = NO;
    self.moreButton.selected = NO;
    [self willShowBottomView:nil];
    
    return result;
}

/**
 *  取消触摸录音键
 */
- (void)cancelTouchRecord
{
    //    self.recordButton.selected = NO;
    //    self.recordButton.highlighted = NO;
    if ([_recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)_recordView recordButtonTouchUpInside];
        [_recordView removeFromSuperview];
    }
}

+ (CGFloat)defaultHeight
{
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}

#pragma mark - **** @好友

- (void)pushSelectAtFriendViewController
{
   
}

- (void)addAtFriend:(TWFriendInfo *)friendInfo
{
    NSArray *friendInfos = @[friendInfo];
    [self selectTwitterFriends:friendInfos];
}

- (void)selectTwitterFriends:(NSArray *)selectMembers
{
    
}

- (NSRange)rangeFromString:(NSString *)rangeStr
{
    NSArray *rangeArray = [rangeStr componentsSeparatedByString:@","];
    NSRange range;
    range.location = [[rangeArray objectAtIndex:0] intValue];
    range.length = [[rangeArray objectAtIndex:1] intValue];
    return range;
}

- (void)cancelAtFriend
{
    NSRange selectRange = self.inputTextView.selectedRange;
    
    NSMutableString *chatText = [[NSMutableString alloc] initWithString:self.inputTextView.text];
    [chatText replaceCharactersInRange:selectRange withString:@"@"];
    self.inputTextView.text = chatText;
    
    [self textViewDidBeginEditing:self.inputTextView];
}

#pragma mark - *** 删除@好友 ***
- (BOOL)deleteAtFriend
{
    
    return YES;
}

- (BOOL)deleteEmoji
{
    NSRange selectedRange = self.inputTextView.selectedRange;
    NSString *forceString = [self.inputTextView.text substringToIndex:selectedRange.location];
    NSString *endString = [self.inputTextView.text substringFromIndex:selectedRange.location];
    
    NSMutableString *resultString = [TWEmojHelper removeLastEmojChineseWithText:forceString];
    
    // 如果无变化说明最后不是表情
    if (resultString.length == forceString.length) {
        return NO;
    }
    
    selectedRange.location -= (forceString.length - resultString.length);
    
    [resultString appendString:endString];
    self.inputTextView.text = resultString;
    
    self.inputTextView.selectedRange = selectedRange;
    
    [self textViewDidChange:self.inputTextView];
    
    return YES;
}

@end
