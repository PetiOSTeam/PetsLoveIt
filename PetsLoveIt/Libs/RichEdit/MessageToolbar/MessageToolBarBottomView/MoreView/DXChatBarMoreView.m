 

#import "DXChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 48
#define INSETS 8

NSInteger numberPerRow = 4;

@implementation DXChatBarMoreView

- (id)initWithFrame:(CGRect)frame isGroup:(BOOL)isGroup
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsWithGroup:isGroup];
    }
    return self;
}

- (void)setupSubviews
{
    [self setupSubviewsWithGroup:NO];
}

- (void)setupSubviewsWithGroup:(BOOL)aIsGroup
{
    self.backgroundColor = [UIColor clearColor];
    
    NSArray *titleArray = nil;
    NSArray *imageArray = nil;
    
    if (aIsGroup) {
        titleArray = @[@"图片", @"拍照", @"名片", @"位置",
                       @"公告", @"任务", @"文章", @"活动",
                       @"投票"];
        imageArray = @[@"morePicture", @"moreTakePhoto", @"moreFriendCard", @"moreLocation",
                       @"moreAnnounce", @"moreTask", @"moreNews", @"moreActivity",
                       @"moreVote"];
    } else {
        titleArray = @[@"图片", @"拍照", @"名片", @"位置"];
        imageArray = @[@"morePicture", @"moreTakePhoto", @"moreFriendCard", @"moreLocation"];
    }
    
    [self createButtonsWithTitles:titleArray imgs:imageArray];
}

- (void)createButtonsWithTitles:(NSArray *)aTitles imgs:(NSArray *)images
{
    NSInteger pageCount = (aTitles.count + 7) / 8;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [scrollView setContentSize:CGSizeMake(self.width * pageCount, self.height)];
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setDelegate:self];
    [self addSubview:scrollView];
    
    if (pageCount > 1) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - 20, self.width, 10)];
        [_pageControl setNumberOfPages:pageCount];
        [_pageControl setPageIndicatorTintColor:mRGBColor(201, 201, 201)];
        [_pageControl setCurrentPageIndicatorTintColor:mRGBColor(153, 153, 153)];
        [self addSubview:_pageControl];
    }
    
    CGFloat offsetW = self.frame.size.width / 4;
    
    for (int i = 0; i < aTitles.count; i++) {
        NSString *titleString = aTitles[i];
        NSString *imageString = images[i];
        
        CGFloat originY = 10 + (int)((i % 8) / numberPerRow) * 80;
        NSInteger pageNum = i / 8;
        CGFloat offsetX = pageNum * self.width;
        
        UIButton *actionButton =[UIButton buttonWithType:UIButtonTypeCustom];
//        actionButton.layer.cornerRadius = 6;
//        actionButton.layer.masksToBounds = YES;
//        actionButton.layer.borderColor = kLayerBorderColor.CGColor;
//        actionButton.layer.borderWidth = kLayerBorderWidth;
        actionButton.tag = i;
        [actionButton setFrame:CGRectMake(offsetX + offsetW * (i % numberPerRow) + (offsetW / 2 - CHAT_BUTTON_SIZE / 2), originY, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [actionButton setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
        [actionButton addTarget:self action:@selector(buttonActionDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:actionButton];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(actionButton.left, actionButton.bottom + 2, CHAT_BUTTON_SIZE, 15)];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        titleLabel.font = [UIFont systemFontOfSize:12];
        [titleLabel setTextColor:[UIColor grayColor]];
        titleLabel.text = titleString;
        [scrollView addSubview:titleLabel];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger selectedIndex = scrollView.contentOffset.x / self.width;
    [_pageControl setCurrentPage:selectedIndex];
}

#pragma mark - action

- (void)buttonActionDidClick:(id)sender
{
    UIButton *button = sender;
    NSLog(@" buttonActionDidClick %ld", (long)button.tag);
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAction:buttonIndex:)]) {
        [_delegate moreViewAction:self buttonIndex:button.tag];
    }
}

@end
