//
//  KMDetailsPageViewController.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//

#import "KMDetailsPageView.h"


#define kDefaultImagePagerHeight 210.0f
#define kDefaultTableViewHeaderMargin 95.0f
#define kDefaultImageAlpha 500.0f
#define kDefaultImageScalingFactor 300.0f

@interface KMDetailsPageView ()<UIWebViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton* imageButton;
@property (nonatomic, strong) UIView* headerView;


@end

@implementation KMDetailsPageView

#pragma mark -
#pragma mark Init Methods

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _imageHeaderViewHeight = kDefaultImagePagerHeight;
    _imageScalingFactor = kDefaultImageScalingFactor;
    _headerImageAlpha = kDefaultImageAlpha;
    _backgroundViewColor = [UIColor clearColor];
    
    _navBarFadingOffset = _imageHeaderViewHeight - (CGRectGetHeight(_navBarView.frame) + kDefaultTableViewHeaderMargin);
    _navBarFadingOffset = 64;
    
    if(!self.imageView)
        [self setupImageView];
    if (!self.tableView)
        [self setupTableView];
    
    [self addSubview:self.tableView2];

    
    if (!self.tableView.tableHeaderView)
        [self setupTableViewHeader];
    
    if (self.backgroundColor)
        [self setupBackgroundColor];
    
    [self setupImageButton];
}

-(PLTableView *)tableView2{
    if (!_tableView2) {
        _tableView2 = [[PLTableView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, mScreenWidth, mScreenHeight-49)];
    }
    return _tableView2;
}

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark -
#pragma mark View layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 510)];
        [_headerView addSubview:_imageView];
        [_headerView addSubview:self.webView];
        _headerView.clipsToBounds = YES;
    }
    return _headerView;
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,_imageView.bottom, mScreenWidth, 300)];
        _webView.scrollView.scrollEnabled = NO;
        _webView.delegate = self;
    }
    return _webView;
}

- (void) loadHtmlString:(NSString *)html{
    [self.webView loadHTMLString:html baseURL:nil];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat contentHeight = webView.scrollView.contentSize.height;
    self.webView.height = contentHeight;
    self.headerView.height = self.webView.bottom;
    self.tableView.tableHeaderView.height = self.headerView.height;
    self.tableView.contentSize = CGSizeMake(mScreenWidth, self.tableView.tableHeaderView.height);
}

#pragma mark -
#pragma mark View Layout Setup Methods

- (void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, mScreenWidth, mScreenHeight-49)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDataSource;
    
    if (self.tableViewSeparatorColor)
        self.tableView.separatorColor = self.tableViewSeparatorColor;
    
    // Add scroll view KVO
    void *context = (__bridge void *)self;
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    
    [self addSubview:self.tableView];
    
    if([self.delegate respondsToSelector:@selector(detailsPage:tableViewDidLoad:)])
    {
        [self.delegate detailsPage:self tableViewDidLoad:self.tableView];
    }
}

- (void)setupTableViewHeader
{
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setupImageButton
{
    if (!self.imageButton)
        self.imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, self.imageHeaderViewHeight)];
    [self.imageButton addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.tableHeaderView addSubview:self.imageButton];
}

- (void)setupImageView
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0, mScreenWidth, kDefaultImagePagerHeight)];
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([self.delegate respondsToSelector:@selector(contentModeForImage:)])
        self.imageView.contentMode = [self.delegate contentModeForImage:self.imageView];

    if ([self.delegate respondsToSelector:@selector(detailsPage:imageDataForImageView:)])
        [self.delegate detailsPage:self imageDataForImageView:self.imageView];
    
}

- (void)setupBackgroundColor
{
    self.backgroundColor = self.backgroundViewColor;
    self.tableView.backgroundColor = self.backgroundViewColor;
}

- (void)setupImageViewGradient
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.imageView.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor], [(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], nil];
    
    gradientLayer.startPoint = CGPointMake(0.6f, 0.6);
    gradientLayer.endPoint = CGPointMake(0.6f, 1.0f);
    
    self.imageView.layer.mask = gradientLayer;
}

#pragma mark -
#pragma mark Data Refresh

- (void)reloadData;
{
    if ([self.delegate respondsToSelector:@selector(contentModeForImage:)])
        self.imageView.contentMode = [self.delegate contentModeForImage:self.imageView];
    
    if ([self.delegate respondsToSelector:@selector(detailsPage:imageDataForImageView:)])
        [self.delegate detailsPage:self imageDataForImageView:self.imageView];
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Tableview Delegate and DataSource setters

- (void)setTableViewDataSource:(id<UITableViewDataSource>)tableViewDataSource
{
    _tableViewDataSource = tableViewDataSource;
    self.tableView.dataSource = _tableViewDataSource;
    
    if (_tableViewDelegate)
    {
        [self.tableView reloadData];
    }
}

- (void)setTableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate
{
    _tableViewDelegate = tableViewDelegate;
    self.tableView.delegate = _tableViewDelegate;
    
    if (_tableViewDataSource)
    {
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark HeaderView Setter

- (void)setNavBarView:(UIView *)headerView
{
    _navBarView = headerView;
    
    if([self.delegate respondsToSelector:@selector(detailsPage:headerViewDidLoad:)])
    {
        [self.delegate detailsPage:self headerViewDidLoad:self.navBarView];
    }
}

- (void)hideHeaderImageView:(BOOL)hidden
{
    self.imageView.hidden = hidden;
}

#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // Make sure we are observing this value.
    if (context != (__bridge void *)self) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ((object == self.tableView) &&
        ([keyPath isEqualToString:@"contentOffset"] == YES))
    {
        [self scrollViewDidScrollWithOffset:self.tableView.contentOffset.y];
        return;
    }
}

#pragma mark -
#pragma mark Action Methods

- (void)imageButtonPressed:(UIButton*)buttom
{
    if ([self.delegate respondsToSelector:@selector(detailsPage:imageViewWasSelected:)])
        [self.delegate detailsPage:self imageViewWasSelected:self.imageView];
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset
{
    CGPoint scrollViewDragPoint = [self.delegate detailsPage:self tableViewWillBeginDragging:self.tableView];
    
    if (scrollOffset < 0)
        self.tableView.transform = CGAffineTransformMakeScale(1 - (scrollOffset / self.imageScalingFactor), 1 - (scrollOffset / self.imageScalingFactor));
    else
        self.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [self animateImageView:scrollOffset draggingPoint:scrollViewDragPoint alpha:self.headerImageAlpha];
}

- (void)animateImageView:(CGFloat)scrollOffset draggingPoint:(CGPoint)scrollViewDragPoint alpha:(float)alpha
{
    [self animateNavigationBar:scrollOffset draggingPoint:scrollViewDragPoint];
    
    if (scrollOffset > scrollViewDragPoint.y && scrollOffset > kDefaultTableViewHeaderMargin)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.alpha = alpha;
        } completion:nil];
    }
    else if (scrollOffset <= kDefaultTableViewHeaderMargin)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.alpha = 1.0;
        } completion:nil];
    }
}

- (void)animateNavigationBar:(CGFloat)scrollOffset draggingPoint:(CGPoint)scrollViewDragPoint
{
    if(scrollOffset > _navBarFadingOffset && _navBarView.alpha == 0.0)
    { //make the navbar appear
        _navBarView.alpha = 0;
        _navBarView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^
         {
             _navBarView.alpha = 1;
         }];
    }
    else if(scrollOffset < _navBarFadingOffset && _navBarView.alpha == 1.0)
    { //make the navbar disappear
        [UIView animateWithDuration:0.3 animations:^{
            _navBarView.alpha = 0;
        } completion: ^(BOOL finished) {
            _navBarView.hidden = YES;
        }];
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com