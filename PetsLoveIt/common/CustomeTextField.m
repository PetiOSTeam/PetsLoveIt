//
//  LoginTextField.m
//  TeamWork
//
//  Created by kongjun on 14-7-11.
//  Copyright (c) 2014年 Shenghuo. All rights reserved.
//

#import "CustomeTextField.h"

@implementation CustomeTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if   (self) {
        // Initialization code
    }
    return self;
}

- (void) setUnHighlightedBorder:(UIColor *)color{
    CALayer *layer = self.layer;
    layer.backgroundColor = [[UIColor whiteColor] CGColor];
    layer.cornerRadius = 5.0;
    layer.masksToBounds = YES;
    layer.borderWidth = 0.8;
    layer.borderColor = [color CGColor];
}

- (void) setHighlightedBorder:(UIColor *)color {
    CALayer *layer = self.layer;
    layer.backgroundColor = [[UIColor whiteColor] CGColor];
    layer.cornerRadius = 5.0;
    layer.masksToBounds = YES;
    layer.borderWidth = 0.8;
    layer.borderColor = [color CGColor];
//    [layer setShadowColor: [color CGColor]];
//    [layer setShadowOpacity:1];
//    [layer setShadowOffset: CGSizeMake(0, 2.0)];
    [layer setShadowRadius:5];
    [self setClipsToBounds:NO];
}

#pragma mark - set textRect offset
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 20, bounds.origin.y + 8,
                      bounds.size.width - 40, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
