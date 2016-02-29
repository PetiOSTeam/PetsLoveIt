

#import <UIKit/UIKit.h>

#import "XHMessageTextView.h"

#import "RichEditMoreView.h"
#import "DXFaceView.h"
#import "DXRecordView.h"

#define kInputTextViewMinHeight 36
#define kInputTextViewMaxHeight 100
#define kHorizontalPadding 5
#define kVerticalPadding 5

#define ANIMATION_DURATION .25f  // 动画时间

#define kTouchToRecord @"按住说话"
#define kTouchToFinish @"松开发送"


/**
 *  类说明：
 *  1、推荐使用[initWithFrame:...]方法进行初始化
 *  2、提供默认的录音，表情，更多按钮的附加页面
 *  3、可自定义以上的附加页面
 */

@protocol DXMessageToolBarDelegate;
@interface RichEditToolBar : UIView

- (instancetype)initWithFrame:(CGRect)frame hideInputView:(BOOL)hidden;
- (instancetype)initWithFrame:(CGRect)frame hideFaceBtn:(BOOL)hidden;
- (void)willShowInputTextViewToHeight:(CGFloat)toHeight;

@property (nonatomic,assign) BOOL hideInputView;
@property (nonatomic,assign) BOOL hideFaceBtn;

@property (nonatomic, weak) id <DXMessageToolBarDelegate> delegate;

@property (strong, nonatomic) UIButton *faceButton;
@property (strong, nonatomic) UIButton *sendBtn;
/**
 *  操作栏背景图片
 */
@property (strong, nonatomic) UIImage *toolbarBackgroundImage;

/**
 *  背景图片
 */
@property (strong, nonatomic) UIImage *backgroundImage;

/**
 *  更多的附加页面
 */
@property (strong, nonatomic) RichEditMoreView *moreView;

/**
 *  表情的附加页面
 */
@property (strong, nonatomic) DXFaceView *faceView;


/**
 *  用于输入文本消息的输入框
 */
@property (strong, nonatomic) XHMessageTextView *inputTextView;

/**
 *  文字输入区域最大高度，必须 > KInputTextViewMinHeight(最小高度)并且 < KInputTextViewMaxHeight，否则设置无效
 */
@property (nonatomic) CGFloat maxTextInputViewHeight;


@property (nonatomic, assign) BOOL hiddenSendButton;



/**
 *  默认高度
 *
 *  @return 默认高度
 */
+ (CGFloat)defaultHeight;



@end

@protocol DXMessageToolBarDelegate <NSObject>

@optional

/**
 *  隐藏表情键盘以及文子键盘
 */
- (void)HiddeneditToolBar;
/**
 *  文字输入框开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView;

/**
 *  文字输入框将要开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView;

/**
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 */
- (void)didSendText:(NSString *)text;


/**
 *  发送第三方表情，不会添加到文字输入框中
 *
 *  @param faceLocalPath 选中的表情的本地路径
 */
- (void)didSendFace:(NSString *)faceLocalPath;


/**判断是否输入状态**/
- (void)isInputViewEditing:(BOOL)isEditing keyboardInfo:(NSDictionary *)userInfo;

//** 转换发送的消息
- (NSString *)sendMessageToDealWith:(NSString *)sendText;


/**
 *  高度变到toHeight
 */
- (void)didChangeFrameToHeight:(CGFloat)toHeight keyboardInfo:(NSDictionary *)userInfo;
- (void)richEditViewBecomeFirstResponse;
- (void)richEditViewResignFirstResponse;

- (void)inputTextViewDidChanged:(NSString *)text;

@end
