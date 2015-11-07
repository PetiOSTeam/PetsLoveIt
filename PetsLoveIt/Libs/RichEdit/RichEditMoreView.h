


#import <UIKit/UIKit.h>

@protocol DXChatBarMoreViewDelegate;
@interface RichEditMoreView : UIView

@property (nonatomic,assign) id<DXChatBarMoreViewDelegate> delegate;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UILabel *photoLabel;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UILabel *takePicLabel;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UILabel *recordLabel;
@property (nonatomic, strong) UIButton *linkSquareButton;
@property (nonatomic, strong) UILabel *linkSquareLabel;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *cardButton;
@property (nonatomic, strong) UILabel *cardLabel;
@property (nonatomic, strong) UILabel *locationLabel;

- (void)setupSubviews;

@end

@protocol DXChatBarMoreViewDelegate <NSObject>

@optional
- (void)moreViewTakePicAction:(RichEditMoreView *)moreView;
- (void)moreViewPhotoAction:(RichEditMoreView *)moreView;
- (void)moreViewRecordAction:(RichEditMoreView *)moreView;
- (void)moreViewSquareLinkAction:(RichEditMoreView *)moreView;

- (void)moreViewLocationAction:(RichEditMoreView *)moreView;
- (void)moreViewVideoAction:(RichEditMoreView *)moreView;
- (void)moreViewCardAction:(RichEditMoreView *)moreView;

@end
