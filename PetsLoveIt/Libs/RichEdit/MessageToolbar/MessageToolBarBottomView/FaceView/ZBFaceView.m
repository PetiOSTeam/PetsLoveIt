//
//  ZBFaceView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "ZBFaceView.h"

#define NumPerLine 7
#define Lines    3
#define FaceSize  24
/*
 ** 两边边缘间隔
 */
#define EdgeDistance 12
/*
 ** 上下边缘间隔
 */
#define EdgeInterVal 12

@implementation ZBFaceView

- (id)initWithFrame:(CGRect)frame forIndexPath:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float kFaceWidth = self.width / NumPerLine;
        float kFaceHeight = self.height / Lines;
        
        for (int i = 0; i < Lines; i++)
        {
            for (int x = 0 ; x < NumPerLine; x++)
            {
                UIImageView *expressionImageView = [[UIImageView alloc] init];
                expressionImageView.contentMode = UIViewContentModeCenter;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceClick:)];
                if (i*7+x+1 ==21) {
                    UIImage *deleteImageNormal = [UIImage imageNamed:@"DeleteEmoticonBtn"];
                    expressionImageView.image = deleteImageNormal;
                    expressionImageView.tag = 0;
                }else{
                    NSString *imageStr = [NSString stringWithFormat:@"e_%ld",(long)index*20+i*7+x+1];
                    expressionImageView.image = [UIImage imageNamed:imageStr];
                    expressionImageView.tag = 20*index+i*7+x+1;
                }
                expressionImageView.width = kFaceWidth;
                expressionImageView.height = kFaceHeight;
                expressionImageView.left = x * kFaceWidth;
                expressionImageView.top = i * kFaceHeight;
                expressionImageView.userInteractionEnabled = YES;
                [expressionImageView addGestureRecognizer:tap];
                [self addSubview:expressionImageView];

            }
        }
    }
    return self;
}

- (void)faceClick:(UITapGestureRecognizer *)button{
    
    UIImageView *imageView = (UIImageView *)button.view;
    if (imageView.tag >= 90) {
        return;
    }
    NSString *faceName;
    BOOL isDelete;
    if (imageView.tag ==0){
        faceName = nil;
        isDelete = YES;
    }else{
        faceName = [NSString stringWithFormat:@"[#&%ld]", (long)imageView.tag];
        isDelete = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelecteFace:andIsSelecteDelete:)]) {
        [self.delegate didSelecteFace:faceName andIsSelecteDelete:isDelete];
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
