//
//  XLSlideBarView.m
//  TeamWork
//
//  Created by 廖先龙 on 14-10-5.
//  Copyright (c) 2014年 Shenghuo. All rights reserved.
//

#import "XLSlideBarView.h"
#import "QHCommonUtil.h"

#define kTag 300
#define kButtonTag 400
#define kTitleColor mRGBColor(67.f, 67.f, 67.f)
#define kDefaultColor mRGBToColor(0xff4401)


@interface XLSlideBarView ()

@property (nonatomic, assign) NSArray *titles;

@property (nonatomic, strong) NSMutableArray *labelItems;

@property (nonatomic, assign) int kItemWidth;

@property (nonatomic, strong) UIImageView *selectImageView;

@end

@implementation XLSlideBarView

- (id)initWithItems:(NSArray *)items
          withFrame:(CGRect)frame
       withDelegate:(id<XLSlideBarDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        self.titles = items;
        self.backgroundColor = [UIColor whiteColor];
        _labelItems = [NSMutableArray new];
        _slideView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _slideView.showsHorizontalScrollIndicator = NO;
        _slideView.showsVerticalScrollIndicator = NO;
        _slideView.contentSize = CGSizeMake(self.width, 0);
        [self addSubview:_slideView];
        
        _kItemWidth = self.width / items.count;
        
//        [self addBottomBorderWithColor:mRGBToColor(0xeeeeee) andWidth:.5];
        [self createWithItems:items];
    }
    return self;
}

- (void)createWithItems:(NSArray *)items
{
    for (int i = 0; i < items.count; i++) {
        NSString *itemText = [items objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.top = 0;
        button.height = self.height;
        button.width = self.width / items.count;
        button.left = button.width * i;
        button.tag = kButtonTag + i;
        [button addTarget:self action:@selector(clickActionChangeItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.slideView addSubview:button];
        
        UILabel *titleLabel = [[UILabel alloc] initForAutoLayout];
        titleLabel.text = itemText;
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        titleLabel.textColor = kTitleColor;
        [titleLabel sizeToFit];
        titleLabel.tag = kTag + i;
        [button addSubview:titleLabel];
        [titleLabel autoCenterInSuperview];
        [_labelItems addObject:titleLabel];
        
        if (i == 0) {
            titleLabel.textColor = kDefaultColor;
            self.selectImageView.left = button.left + button.width / 2 - self.selectImageView.width / 2;
        }
    }
}

- (void)clickActionChangeItem:(id)sender
{
    if ([_delegate respondsToSelector:@selector(selectItemWithPage:withObject:)]) {
        [_delegate selectItemWithPage:(int)((UIButton *)sender).tag - kButtonTag withObject:self];
    }
    UIButton *button = sender;
    [self selectIndex:button.tag - kButtonTag + kTag];
    //    [self lineOffsetFromLabelIndex:(int)button.tag - kButtonTag];
}

- (void)lineOffsetFromLabelIndex:(int)index
{
    UIButton *button = (id)[self.slideView viewWithTag:kButtonTag + index];
    [UIView animateWithDuration:.3f animations:^{
        self.selectImageView.left = button.left + button.width / 2 - self.selectImageView.width / 2;
    }];
}

- (void)selectIndex:(unsigned long)index
{
    for (UILabel *obj in _labelItems) {
        if (obj.tag != index) {
            obj.textColor = kTitleColor;
        }else {
            obj.textColor = kDefaultColor;
        }
    }
}

- (void)changeItem:(float)x
{
    float xx = x * (_kItemWidth / self.frame.size.width);
    float pStartX = xx;
    
    int sT = (x)/self.slideView.frame.size.width;
    if (sT < 0 || sT > self.labelItems.count - 1) {
        return;
    }
    UILabel *label = [_labelItems objectAtIndex:sT];
    float percent = (pStartX - _kItemWidth * sT)/_kItemWidth;
    //    float value = [QHCommonUtil lerp:(1 - percent) min:1.0f max:1.1f];
    //    [self scaleLabelFromItem:label scale:value];
    [self changeColorForItem:label red:(1 - percent)];
    
    if((int)xx % _kItemWidth == 0) {
        return;
    }
    if (sT + 1 > self.labelItems.count - 1) {
        return;
    }
    UILabel *label1 = [_labelItems objectAtIndex:sT + 1];
    //float value1 = [QHCommonUtil lerp:percent min:1.0f max:1.1f];
    //[self scaleLabelFromItem:label1 scale:value1];
    [self changeColorForItem:label1 red:percent];
    
    [self equalLineOffsetX:xx];
}

- (void)changeColorForItem:(UILabel *)label red:(float)nRedPercent
{
    CGFloat redColorValue = [QHCommonUtil lerp:nRedPercent min:101 max:228];
    CGFloat greenColorValue = [QHCommonUtil lerp:nRedPercent min:101 max:77];
    CGFloat blueColorValue = [QHCommonUtil lerp:nRedPercent min:101 max:66];
    
    label.textColor = mRGBAColor(redColorValue,greenColorValue,blueColorValue,1);
}

- (void)equalLineOffsetX:(CGFloat)offsetX
{
    self.selectImageView.left = 15 + offsetX;
}

- (void)changeSelectedItemWithOffsetX:(float)x
{
    int sT = (x)/self.slideView.frame.size.width;
    [self lineOffsetFromLabelIndex:sT];
}

- (void)scaleLabelFromItem:(UILabel *)label scale:(float)scaleValue
{
    [UIView beginAnimations:@"" context:nil];
    CGAffineTransform transfrom = label.transform;
    transfrom = CGAffineTransformMakeScale(scaleValue, scaleValue);
    label.transform = transfrom;
    [UIView commitAnimations];
}

- (UIImageView *)selectImageView
{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.backgroundColor = kDefaultColor;
        _selectImageView.width = 70;
        _selectImageView.height = 2;
        _selectImageView.bottom = self.height - 5;
        [self addSubview:_selectImageView];
    }
    return _selectImageView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
