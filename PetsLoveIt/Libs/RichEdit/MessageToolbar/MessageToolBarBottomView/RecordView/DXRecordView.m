 

#import "DXRecordView.h"

@interface DXRecordView ()
{
    BOOL isOutSide;
//    NSTimer *_timer;
    // 显示动画的ImageView
    UIImageView *_recordAnimationView;
    // 提示文字
    UILabel *_textLabel;
}

@end

@implementation DXRecordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
//        bgView.backgroundColor = [UIColor clearColor];
//        bgView.layer.cornerRadius = 5;
//        bgView.layer.masksToBounds = YES;
//        [self addSubview:bgView];
        
        _recordAnimationView = [[UIImageView alloc] initWithFrame:self.bounds];
        _recordAnimationView.image = [UIImage imageNamed:@"NewVoiceFeedback001"];
        [self addSubview:_recordAnimationView];
        
//        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
//                                                               self.bounds.size.height - 30,
//                                                               self.bounds.size.width - 10,
//                                                               25)];
//        
//        _textLabel.textAlignment = NSTextAlignmentCenter;
//        _textLabel.backgroundColor = [UIColor clearColor];
//        _textLabel.text = @" 手指上滑，取消发送 ";
//        [self addSubview:_textLabel];
//        _textLabel.font = [UIFont systemFontOfSize:13];
//        _textLabel.textColor = [UIColor whiteColor];
//        _textLabel.layer.cornerRadius = 5;
//        _textLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
//        _textLabel.layer.masksToBounds = YES;
    }
    return self;
}

// 录音按钮按下
-(void)recordButtonTouchDown
{
    isOutSide = NO;
    _recordAnimationView.image = [UIImage imageNamed:@"NewVoiceFeedback001"];
    // 需要根据声音大小切换recordView动画
//    _textLabel.text = @" 手指上滑，取消发送 ";
//    _textLabel.backgroundColor = [UIColor clearColor];
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
//                                              target:self
//                                            selector:@selector(setVoiceImage)
//                                            userInfo:nil
//                                             repeats:YES];
    
}
// 手指在录音按钮内部时离开
-(void)recordButtonTouchUpInside
{
//    [_timer invalidate];
}
// 手指在录音按钮外部时离开
-(void)recordButtonTouchUpOutside
{
//    [_timer invalidate];
}
// 手指移动到录音按钮内部
-(void)recordButtonDragInside
{
    isOutSide = NO;
    
    _recordAnimationView.image = [UIImage imageNamed:@"NewVoiceFeedback001"];
    
//    _textLabel.text = @" 手指上滑，取消发送 ";
//    _textLabel.backgroundColor = [UIColor clearColor];
}

// 手指移动到录音按钮外部
-(void)recordButtonDragOutside
{
    isOutSide = YES;
    _recordAnimationView.image = [UIImage imageNamed:@"NewVoiceFeedbackCancle"];
//    _textLabel.text = @" 松开手指，取消发送 ";
//    _textLabel.backgroundColor = [UIColor redColor];
}

-(void)setVoiceImageWithVoiceSound:(CGFloat)voiceSound
{
    if (isOutSide) {
        _recordAnimationView.image = [UIImage imageNamed:@"NewVoiceFeedbackCancle"];
        return;
    }
    
    _recordAnimationView.image = [UIImage imageNamed:@"NewVoiceFeedback001"];
    if (0 < voiceSound <= 0.125) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback001"]];
    }else if (0.125<voiceSound<=0.25) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback002"]];
    }else if (0.25<voiceSound<=0.375) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback003"]];
    }else if (0.375<voiceSound<=0.5) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback004"]];
    }else if (0.5<voiceSound<=0.625) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback005"]];
    }else if (0.625<voiceSound<=0.75) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback006"]];
    }else if (0.75<voiceSound<=0.875) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback007"]];
    }else if (0.875<voiceSound<1.0) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback008"]];
    }else {
        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback009"]];
    }

    
    
//    _recordAnimationView.image = [UIImage imageNamed:@"NewVoiceFeedback001"];
//    if (0 < voiceSound <= 0.1) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback001"]];
//    }else if (0.1<voiceSound<=0.2) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback002"]];
//    }else if (0.1<voiceSound<=0.3) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback003"]];
//    }else if (0.3<voiceSound<=0.4) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback004"]];
//    }else if (0.4<voiceSound<=0.5) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback005"]];
//    }else if (0.5<voiceSound<=0.6) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback006"]];
//    }else if (0.6<voiceSound<=0.7) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback007"]];
//    }else if (0.7<voiceSound<=0.8) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback008"]];
//    }else if (0.8<voiceSound<=0.9) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback009"]];
//    }else if (0.9<voiceSound<1.0) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback010"]];
//    }else {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"NewVoiceFeedback011"]];
//    }

    
//    _recordAnimationView.image = [UIImage imageNamed:@"VoiceSearchFeedback001"];
//    if (0 < voiceSound <= 0.075) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback001"]];
//    }else if (0.075<voiceSound<=0.15) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback002"]];
//    }else if (0.15<voiceSound<=0.225) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback003"]];
//    }else if (0.225<voiceSound<=0.3) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback004"]];
//    }else if (0.3<voiceSound<=0.375) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback005"]];
//    }else if (0.375<voiceSound<=0.45) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback006"]];
//    }else if (0.45<voiceSound<=0.525) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback007"]];
//    }else if (0.525<voiceSound<=0.6) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback008"]];
//    }else if (0.6<voiceSound<=0.675) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback009"]];
//    }else if (0.675<voiceSound<=0.75) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback010"]];
//    }else if (0.75<voiceSound<=0.825) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback011"]];
//    }else if (0.825<voiceSound<=0.9) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback012"]];
//    }else if (0.9<voiceSound<=0.975) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback013"]];
//    }else if (0.975<voiceSound<=1.05) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback014"]];
//    }else if (1.05<voiceSound<=1.125) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback015"]];
//    }else if (1.125<voiceSound<=1.20) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback016"]];
//    }else if (1.20<voiceSound<=1.275) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback017"]];
//    }else if (1.275<voiceSound<=1.35) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback018"]];
//    }else if (1.35<voiceSound<=1.425) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback019"]];
//    }else {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback020"]];
//    }
    
    
//    if (0 < voiceSound <= 0.05) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback001"]];
//    }else if (0.05<voiceSound<=0.10) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback002"]];
//    }else if (0.10<voiceSound<=0.15) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback003"]];
//    }else if (0.15<voiceSound<=0.20) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback004"]];
//    }else if (0.20<voiceSound<=0.25) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback005"]];
//    }else if (0.25<voiceSound<=0.30) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback006"]];
//    }else if (0.30<voiceSound<=0.35) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback007"]];
//    }else if (0.35<voiceSound<=0.40) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback008"]];
//    }else if (0.40<voiceSound<=0.45) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback009"]];
//    }else if (0.45<voiceSound<=0.50) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback010"]];
//    }else if (0.50<voiceSound<=0.55) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback011"]];
//    }else if (0.55<voiceSound<=0.60) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback012"]];
//    }else if (0.60<voiceSound<=0.65) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback013"]];
//    }else if (0.65<voiceSound<=0.70) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback014"]];
//    }else if (0.70<voiceSound<=0.75) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback015"]];
//    }else if (0.75<voiceSound<=0.80) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback016"]];
//    }else if (0.80<voiceSound<=0.85) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback017"]];
//    }else if (0.85<voiceSound<=0.90) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback018"]];
//    }else if (0.90<voiceSound<=0.95) {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback019"]];
//    }else {
//        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback020"]];
//    }
}

@end
