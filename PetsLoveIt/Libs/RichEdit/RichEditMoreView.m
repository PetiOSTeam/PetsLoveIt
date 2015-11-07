 

#import "RichEditMoreView.h"

#define CHAT_BUTTON_SIZE 48
#define INSETS 8

@implementation RichEditMoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat offsetW = self.frame.size.width / 4;
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _photoButton.layer.cornerRadius = 6;
    _photoButton.layer.masksToBounds = YES;
    _photoButton.layer.borderColor = kLayerBorderColor.CGColor;
    _photoButton.layer.borderWidth = kLayerBorderWidth;
    [_photoButton setFrame:CGRectMake(offsetW / 2 - CHAT_BUTTON_SIZE / 2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    _photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_photoButton.left, _photoButton.bottom + 2, CHAT_BUTTON_SIZE, 15)];
    [_photoLabel setTextAlignment:NSTextAlignmentCenter];
    _photoLabel.text = @"图片";
    [_photoLabel setTextColor:[UIColor grayColor]];
     _photoLabel.font = [UIFont systemFontOfSize:12];
    [_photoButton setImage:[UIImage imageNamed:@"Image_richEditPhotoPicker"] forState:UIControlStateNormal];
    //[_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photoSelected"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    [self addSubview:_photoLabel];
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _takePicButton.layer.cornerRadius = 6;
    _takePicButton.layer.masksToBounds = YES;
    _takePicButton.layer.borderColor = kLayerBorderColor.CGColor;
    _takePicButton.layer.borderWidth = kLayerBorderWidth;
    [_takePicButton setFrame:CGRectMake(offsetW + (offsetW / 2 - CHAT_BUTTON_SIZE / 2) , 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton setImage:[UIImage imageNamed:@"Image_richEditMoreTaskPhoto"] forState:UIControlStateNormal];
    
    
    _takePicLabel = [[UILabel alloc] initWithFrame:CGRectMake(_takePicButton.left, _takePicButton.bottom + 2, CHAT_BUTTON_SIZE, 15)];
    [_takePicLabel setTextAlignment:NSTextAlignmentCenter];
    _takePicLabel.font = [UIFont systemFontOfSize:12];
    [_takePicLabel setTextColor:[UIColor grayColor]];
    _takePicLabel.text = @"拍摄";
   // [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_cameraSelected"] forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];
    [self addSubview:_takePicLabel];
    //录音
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordButton.layer.cornerRadius = 6;
    _recordButton.layer.masksToBounds = YES;
    _recordButton.layer.borderColor = kLayerBorderColor.CGColor;
    _recordButton.layer.borderWidth = kLayerBorderWidth;
    [_recordButton setFrame:CGRectMake(offsetW * 2 + (offsetW / 2 - CHAT_BUTTON_SIZE / 2) , 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_recordButton setImage:[UIImage imageNamed:@"Image_richEditMoreSoundRecord"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_recordButton];
   _recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(_recordButton.left, _recordButton.bottom + 2, CHAT_BUTTON_SIZE, 15)];
    [_recordLabel setTextAlignment:NSTextAlignmentCenter];
    _recordLabel.font = [UIFont systemFontOfSize:12];
    [_recordLabel setTextColor:[UIColor grayColor]];
    _recordLabel.text = @"录音";
    [self addSubview:_recordLabel];
    // [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_cameraSelected"] forState:UIControlStateHighlighted];
    //文章链接
    
    _linkSquareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _linkSquareButton.layer.cornerRadius = 6;
    _linkSquareButton.layer.masksToBounds = YES;
    _linkSquareButton.layer.borderColor = kLayerBorderColor.CGColor;
    _linkSquareButton.layer.borderWidth = kLayerBorderWidth;
    [_linkSquareButton setFrame:CGRectMake(offsetW * 3 + (offsetW / 2 - CHAT_BUTTON_SIZE / 2) , 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_linkSquareButton setImage:[UIImage imageNamed:@"Image_richEditSquareLink"] forState:UIControlStateNormal];
    [_linkSquareButton addTarget:self action:@selector(squareLinkAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_linkSquareButton];
    _linkSquareLabel = [[UILabel alloc] initWithFrame:CGRectMake(_linkSquareButton.left, _linkSquareButton.bottom + 2, CHAT_BUTTON_SIZE, 15)];
    [_linkSquareLabel setTextAlignment:NSTextAlignmentCenter];
    _linkSquareLabel.font = [UIFont systemFontOfSize:12];
    [_linkSquareLabel setTextColor:[UIColor grayColor]];
    _linkSquareLabel.text = @"链接";
    [self addSubview:_linkSquareLabel];
    
    
    //名片
    _cardButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _cardButton.layer.cornerRadius = 6;
    _cardButton.layer.masksToBounds = YES;
    _cardButton.layer.borderColor = kLayerBorderColor.CGColor;
    _cardButton.layer.borderWidth = kLayerBorderWidth;
    [_cardButton setFrame:CGRectMake(offsetW * 2 + (offsetW / 2 - CHAT_BUTTON_SIZE / 2) , 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_cardButton setImage:[UIImage imageNamed:@"sharemore_friendcard"] forState:UIControlStateNormal];
    [_cardButton addTarget:self action:@selector(cardAction) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:_cardButton];
    
    _cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cardButton.left, _cardButton.bottom + 2, CHAT_BUTTON_SIZE, 15)];
    [_cardLabel setTextAlignment:NSTextAlignmentCenter];
    _cardLabel.font = [UIFont systemFontOfSize:12];
    [_cardLabel setTextColor:[UIColor grayColor]];
    _cardLabel.text = @"名片";
    //[self addSubview:_cardLabel];
    
    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.layer.cornerRadius = 6;
    _locationButton.layer.masksToBounds = YES;
    _locationButton.layer.borderColor = kLayerBorderColor.CGColor;
    _locationButton.layer.borderWidth = kLayerBorderWidth;
    [_locationButton setFrame:CGRectMake(offsetW * 3 + (offsetW / 2 - CHAT_BUTTON_SIZE / 2), 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_locationButton setImage:[UIImage imageNamed:@"sharemore_location"] forState:UIControlStateNormal];
    //    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_locationSelected"] forState:UIControlStateHighlighted];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:_locationButton];
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_locationButton.left, _locationButton.bottom + 2, CHAT_BUTTON_SIZE, 15)];
    [_locationLabel setTextAlignment:NSTextAlignmentCenter];
    _locationLabel.font = [UIFont systemFontOfSize:12];
    [_locationLabel setTextColor:[UIColor grayColor]];
    _locationLabel.text = @"位置";
    //[self addSubview:_locationLabel];
    
//    _videoButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [_videoButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//    [_videoButton setImage:[UIImage imageNamed:@"sharemore_video"] forState:UIControlStateNormal];
//    [_videoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoSelected"] forState:UIControlStateHighlighted];
//    [_videoButton addTarget:self action:@selector(takeVideoAction) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:_videoButton];
}

#pragma mark - action

- (void)squareLinkAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewSquareLinkAction:)]) {
        [_delegate moreViewSquareLinkAction:self];
    }
}

- (void)cardAction
{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewCardAction:)]){
        [_delegate moreViewCardAction:self];
    }
}

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}
- (void)recordAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewRecordAction:)]) {
        [_delegate moreViewRecordAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takeVideoAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewVideoAction:self];
    }
}

@end
