

#import "DXFaceView.h"

@interface DXFaceView ()<ZBMessageManagerFaceViewDelegate>

@end

@implementation DXFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _facialView = [[ZBMessageManagerFaceView alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, self.bounds.size.height)];
        _facialView.hiddenSendButton = self.hiddenSendButton;
        _facialView.delegate = self;
        _facialView.backgroundColor = mRGBColor(245, 245, 245);
        [self addSubview:_facialView];
        [self setBackgroundColor:mRGBColor(245, 245, 245)];
    }
    return self;
}

#pragma mark - ZBMessageFaceViewDelegate
- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele
{
    if (_delegate) {
        [_delegate selectedFacialView:faceStr isDelete:dele];
    }
    NSLog(@"faceStr:%@", faceStr);
}

- (void)sendEmoji
{
    if ([_delegate respondsToSelector:@selector(sendFace)]) {
        [_delegate sendFace];
    }
}

//#pragma mark - FacialViewDelegate
//
//-(void)selectedFacialView:(NSString*)str{
//    if (_delegate) {
//        [_delegate selectedFacialView:str isDelete:NO];
//    }
//}
//
//-(void)deleteSelected:(NSString *)str{
//    if (_delegate) {
//        [_delegate selectedFacialView:str isDelete:YES];
//    }
//}
//
//- (void)sendFace
//{
//    if (_delegate) {
//        [_delegate sendFace];
//    }
//}
//
//#pragma mark - public
//
//- (BOOL)stringIsFace:(NSString *)string
//{
//    if ([_facialView.faces containsObject:string]) {
//        return YES;
//    }
//    return NO;
//}

@end
