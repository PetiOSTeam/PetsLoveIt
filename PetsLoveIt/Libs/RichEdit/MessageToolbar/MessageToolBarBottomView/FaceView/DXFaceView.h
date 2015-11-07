 

#import <UIKit/UIKit.h>

#import "ZBMessageManagerFaceView.h"

@protocol DXFaceDelegate <NSObject>

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;
- (BOOL)sendFace;

@end


@interface DXFaceView : UIView

@property (nonatomic, strong) ZBMessageManagerFaceView *facialView;

@property (nonatomic, assign) id<DXFaceDelegate> delegate;

@property (nonatomic, assign) BOOL hiddenSendButton;


//- (BOOL)stringIsFace:(NSString *)string;

@end
