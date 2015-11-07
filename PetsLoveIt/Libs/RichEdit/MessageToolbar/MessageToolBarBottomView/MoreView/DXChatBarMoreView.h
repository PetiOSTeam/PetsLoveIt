 

#import <UIKit/UIKit.h>

@protocol DXChatBarMoreViewDelegate;
@interface DXChatBarMoreView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic,assign) id<DXChatBarMoreViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame isGroup:(BOOL)isGroup;

- (void)setupSubviews;

@end

@protocol DXChatBarMoreViewDelegate <NSObject>

@required
- (void)moreViewAction:(DXChatBarMoreView *)moreView buttonIndex:(NSInteger)aIndex;

@end
