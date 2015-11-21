//
//  XLLoadingView.m
//  XianRenZhang
//
//  Created by 廖先龙 on 15/1/16.
//  Copyright (c) 2015年 廖先龙. All rights reserved.
//

#import "XLLoadingView.h"

@interface XLLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *errorImageView;

@end

@implementation XLLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = .5f;
        self.isActive = YES;
        //        self.backgroundColor = mRGBColor(245.f, 245.f, 245.f);
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat width = self.titleLabel.width + 50;
    return CGSizeMake(width, 30);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_isActive) {
        if (_errorImageView) {
            [_errorImageView removeFromSuperview];
            _errorImageView = nil;
        }
        self.activityView.left = 10;
        self.activityView.top = self.height / 2 - _activityView.height / 2;
        
        self.titleLabel.left = CGRectGetMaxX(self.activityView.frame) + 7;
        self.titleLabel.top = self.height / 2 - self.titleLabel.height / 2;
    }else {
        if (_activityView) {
            [_activityView removeFromSuperview];
            _activityView = nil;
        }
        self.errorImageView.left = 10;
        self.errorImageView.top = self.height / 2 - self.errorImageView.height / 2;
        
        self.titleLabel.left = CGRectGetMaxX(self.errorImageView.frame) + 10;
        self.titleLabel.top = self.height / 2 - self.titleLabel.height / 2;
    }
}

- (void)setTitle:(NSString *)titleText active:(BOOL)active
{
    _titleText = titleText;
    _isActive = active;
    self.titleLabel.text = titleText;
    [self.titleLabel sizeToFit];
    [self sizeToFit];
    [self setNeedsLayout];
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.titleLabel.text = titleText;
    [self.titleLabel sizeToFit];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)setActionBlock:(CallBackBlock)actionBlock
{
    _actionBlock = actionBlock;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapWithAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapWithAction
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.left = 10;
        _activityView.top = self.height / 2 - _activityView.height / 2;
        [_activityView startAnimating];
        [self addSubview:_activityView];
    }
    return _activityView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)errorImageView
{
    if (!_errorImageView) {
        UIImage *image = [UIImage imageNamed:@"trend_error"];
        _errorImageView = [[UIImageView alloc] initWithImage:image];
        _errorImageView.width = image.size.width;
        _errorImageView.height = image.size.height;
        [self addSubview:_errorImageView];
    }
    return _errorImageView;
}

@end
