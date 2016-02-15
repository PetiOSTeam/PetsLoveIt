//
//  KMDetailsPageViewController.m
//  TheMovieDB
//
//  Created by Kevin Mindeguia on 04/02/2014.
//  Copyright (c) 2014 iKode Ltd. All rights reserved.
//
#import "KMDetailsPageView.h"
#import "Shaidanauthor.h"
#define kDefaultImagePagerHeight 210.0f

#define kDefaultTableViewHeaderMargin 95.0f
#define kDefaultImageAlpha 500.0f
#define kDefaultImageScalingFactor 300.0f

@interface KMDetailsPageView ()<UIWebViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton* imageButton;
@property (nonatomic, strong) UIView* headerView;

@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic,strong) Shaidanauthor *shaidanview;
@property (nonatomic,strong) NSString *goodsuid;
@property (assign,nonatomic)  Menutype apptypename;
@property (nonatomic,copy) NSString *imgURL;
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
- (Shaidanauthor *)shaidanview
{
    if (!_shaidanview) {
        _shaidanview = [[[NSBundle mainBundle]loadNibNamed:@"Shaidanauthor" owner:self options:nil]firstObject];    }
  
    return _shaidanview;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Withtype:(Menutype)type andAuthor:(NSString *)goodsuid
{
    self = [super initWithFrame:frame];
    if (self) {
        self.apptypename = type;
        self.goodsuid = goodsuid;
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
    //_navBarFadingOffset = 64;
    
    if(!self.imageView)
        [self setupImageView];
    
    
    [self addSubview:self.tableView2];
    if (!self.tableView)
        [self setupTableView];
    
    if (!self.tableView.tableHeaderView && (self.apptypename != TypeCheap))
        [self setupTableViewHeader];
    
    if (self.backgroundColor)
        [self setupBackgroundColor];
    
    [self setupImageButton];
    
}

-(PLTableView *)tableView2{
    if (!_tableView2) {
        _tableView2 = [[PLTableView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, mScreenWidth, mScreenHeight-49) Withtype:self.apptypename];
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
        [_headerView addSubview:self.label1];
        [_headerView addSubview:self.label2];
        [_headerView addSubview:self.label3];
        [_headerView addSubview:self.webView];
        
        if (self.apptypename == TypeCheap) {
            [_headerView addSubview:self.cheapTable];
        }
        #warning  晒单经验页面作者详情，现在先注释掉后期需要用。
//        if (((self.apptypename == TypeShareOrder)||(self.apptypename == TypeExperience))&&((![self.goodsuid isEqualToString:@"0"])&&(self.goodsuid))) {
//         
//            [_headerView addSubview:self.shaidanview];
//        }
        _headerView.clipsToBounds = YES;
    }
    return _headerView;
}

-(UILabel *)label1{
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        [_label1 setTextColor:mRGBToColor(0x999999)];
        [_label1 setFont:[UIFont systemFontOfSize:12]];
        _label1.numberOfLines = 0;
    }
    return _label1;
}

-(UILabel *)label2{
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        [_label2 setTextColor:mRGBToColor(0x333333)];
        [_label2 setFont:[UIFont boldSystemFontOfSize:19]];
        _label2.numberOfLines = 0;
    }
    return _label2;
}

-(UILabel *)label3{
    if (!_label3) {
        _label3 = [[UILabel alloc] init];
        [_label3 setTextColor:mRGBToColor(0xff4401)];
        [_label3 setFont:[UIFont boldSystemFontOfSize:17]];
        _label3.numberOfLines = 0;
    }
    return _label3;
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.scrollView.scrollEnabled = NO;
        _webView.delegate = self;
     
//        UIScrollView *tempView=(UIScrollView *)[_webView.subviews objectAtIndex:0];
//        tempView.scrollEnabled=NO;

    }
    return _webView;
}

-(CheapTableView *)cheapTable{
    if (!_cheapTable) {
        _cheapTable = [[CheapTableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 0)];
    }
    return _cheapTable;
}

-(void) loadGoodsInfo:(GoodsModel *)goods{
    
    self.label1.text = [NSString stringWithFormat:@"｜ %@  %@",goods.typeName,goods.dateTime] ;
    
    self.label2.text = goods.name;
    self.label3.text = goods.desc;
    self.goods = goods;
    // 根据模型数据设置控件的坐标和尺寸
    [self setupviewFrameWithDetailsdata];
}


#pragma mark - 根据模型数据设置控件的坐标和尺寸
- (void)setupviewFrameWithDetailsdata
{
    
    // label1
    CGSize lablesize1 = [self getframeWithTitle:self.label1.text andTitleFont:self.label1.font];
    self.label1.frame = (CGRect){{17,_imageView.bottom + 10}, lablesize1};
    // label2
    CGSize lablesize2 = [self getframeWithTitle:self.label2.text andTitleFont:self.label2.font];
    self.label2.frame = (CGRect){{20, _label1.bottom + 15}, lablesize2};
    
    // label3
    CGSize lablesize3 = [self getframeWithTitle:self.label3.text andTitleFont:self.label3.font];
    self.label3.frame = (CGRect){{20, _label2.bottom +10}, lablesize3};
   

    self.webView.frame = CGRectMake(12,_label3.bottom+20, mScreenWidth - 24 , 1);
//    }
   }
// 根据文字计算标签的高度
- (CGSize)getframeWithTitle:(NSString *)title andTitleFont:(UIFont *)titlefont
{
    CGFloat maxW = mScreenWidth-40;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [title sizeWithFont:titlefont constrainedToSize:maxSize];
    
    return textSize;
}

// web数据源方法
- (void) loadHtmlString:(NSString *)html{
    [self.webView loadHTMLString:html baseURL:nil];
}
#pragma mark - webViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    /** js函数用来获得点击事件以及点击的位置 */
    static NSString* const kTouchJavaScriptString=
    @"document.ontouchstart=function(event){\
    x=event.targetTouches[0].clientX;\
    y=event.targetTouches[0].clientY;\
    document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
    document.ontouchmove=function(event){\
    x=event.targetTouches[0].clientX;\
    y=event.targetTouches[0].clientY;\
    document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
    document.ontouchcancel=function(event){\
    document.location=\"myweb:touch:cancel\";};\
    document.ontouchend=function(event){\
    document.location=\"myweb:touch:end\";};";
    // 添加函数到webview
    [self.webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
    CGFloat height1 = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    self.webView.height = height1+10;
    [webView sizeToFit];
    if (self.apptypename == TypeCheap) {
        [self getCheapProductOnCompletion:^{
            self.cheapTable.top = self.webView.bottom+45;
            self.cheapTable.height = self.cheapTable.dataArray.count * 150;
            self.headerView.frame = CGRectMake(0, 0, mScreenWidth, self.cheapTable.bottom+45) ;
            [self setupTableViewHeader];
            self.tableView.tableHeaderView.height = self.headerView.height;
            if ([self.delegate respondsToSelector:@selector(detailWebViewDidFinishLoad)]) {
                [self.delegate detailWebViewDidFinishLoad];
            }
        }];
        
      }

 #warning  晒单经验页面作者详情，现在先注释掉后期需要用。
//    else if (((self.apptypename == TypeShareOrder)||(self.apptypename == TypeExperience))&&((![self.goodsuid isEqualToString:@"0"])&&(self.goodsuid)))
//    {
//        self.headerView.frame = CGRectMake(0, 0, mScreenWidth, self.webView.bottom+45+250) ;
//        self.shaidanview.frame = CGRectMake(0, self.webView.bottom, mScreenWidth, 250);
//     
//        self.shaidanview.uesrId = self.goodsuid ;
////        [self.headerView addSubview:self.shaidanview];
//        
//        [self setupTableViewHeader];
//        self.tableView.tableHeaderView.height = self.headerView.height;
//        if ([self.delegate respondsToSelector:@selector(detailWebViewDidFinishLoad)]) {
//            [self.delegate detailWebViewDidFinishLoad];
//        }
//
//    }
    
    else{
        self.headerView.frame = CGRectMake(0, 0, mScreenWidth, self.webView.bottom +45) ;
        [self setupTableViewHeader];
        
        self.tableView.tableHeaderView.height = self.headerView.height;
        
        if ([self.delegate respondsToSelector:@selector(detailWebViewDidFinishLoad)]) {
            [self.delegate detailWebViewDidFinishLoad];
        }
    }
    if ([self.goods.isUserShare  isEqual: @"1"]) {
        UILabel *publisher = [[UILabel alloc]initWithFrame:CGRectMake(20, self.webView.bottom, mScreenWidth - 40, 12)];
        publisher.textAlignment = NSTextAlignmentRight;
        publisher.textColor = mRGBToColor(0x999999);
        publisher.font = [UIFont systemFontOfSize:12];
        publisher.text = [NSString stringWithFormat:@"爆料人:%@",self.goods.publisher];
        [self.tableView.tableHeaderView addSubview:publisher];
    }
      
}
// 拦截webview的点击事件
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request navigationType:(UIWebViewNavigationType)navigationType {
   static BOOL isMoveWeb = NO;
   static BOOL isClickWeb = NO;
    NSString *requestString = [[_request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
                                   isEqualToString:@"myweb"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            //NSLog(@"you are touching!");
            //NSTimeInterval delaytime = Delaytime;
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                /*
                 @需延时判断是否响应页面内的js...
                 */
                isClickWeb = YES;
                NSLog(@"touch start!");
                
                float ptX = [[components objectAtIndex:3]floatValue];
                float ptY = [[components objectAtIndex:4]floatValue];
                NSLog(@"touch point (%f, %f)", ptX, ptY);
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [self.webView stringByEvaluatingJavaScriptFromString:js];
                if ([tagName isEqualToString:@"IMG"]) {
                    _imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                }else{
                    _imgURL = nil;
                }
            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                isMoveWeb = YES;
                NSLog(@"you are move");
                 
            }
        else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
            NSLog(@"touch end");
            // 如果仅仅是点击且没有滑动则调用图片的点击事件
            if ((isMoveWeb == NO)&&(isClickWeb = YES)) {
                if (_imgURL != nil) {
                    [self savedtolocal];
                }
                
            }
            isClickWeb = NO;
            isMoveWeb = NO;
        }
                }
    return NO;
}
return YES;
}

- (void)savedtolocal{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
   
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 0) {
            NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:_imgURL];
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
            UIImage* image = [UIImage imageWithData:data];
            // 此方法可以把图片保存到本地相册
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
       
        }else{
            return;
        }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
            if (error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:@"请确认应用程序已获得访问相册的权限" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [alert show];
            }else {
              
                 [mAppUtils showHint:@"保存成功"];
            }
}
#pragma mark - 白菜价的接口
-(void)getCheapProductOnCompletion:(void (^)())completionBlock{
    NSDictionary *params = @{@"uid":@"getCheapProductList",
                             @"startNum":@"0",
                             @"limit":@"11"
                             };
    [APIOperation GET:@"getCoreSv.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            NSArray *jsonArray = [[responseData objectForKey:@"beans"] objectForKey:@"beans"];
            if ([jsonArray count] ==0) {
                return ;
            }
            for (NSMutableDictionary *typedict in jsonArray) {
                GoodsModel *typemodel = [[GoodsModel alloc] initWithDictionary:typedict];
                if (![self.goods.prodId isEqualToString:typemodel.prodId]) {
                    [self.cheapTable.dataArray addObject:typemodel];
                }
                
            }
            
            [self.cheapTable reloadData];
            if (completionBlock) {
                completionBlock();
            }
            
        }
    }];
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
    self.tableView.showsVerticalScrollIndicator = NO;
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
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 20, mScreenWidth, kDefaultImagePagerHeight)];
    self.imageView.clipsToBounds = YES;
    //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
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
    
//    if (scrollOffset < 0)
//        self.tableView.transform = CGAffineTransformMakeScale(1 - (scrollOffset / self.imageScalingFactor), 1 - (scrollOffset / self.imageScalingFactor));
//    else
//        self.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
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
    if (self.tableView2.top >64 && self.tableView.top<0) {
        _navBarView.alpha = 1;
        _navBarView.hidden = NO;
        return;
        
    }
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