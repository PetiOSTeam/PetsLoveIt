//
//  SearchResultsViewController.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "SearchResultCell.h"

typedef enum : NSUInteger {
    SearchResultsStyleNone,
    SearchResultsStyleFail,
    SearchResultsStyleNotData,
} SearchResultsStyle;

#define kCellHeight 110

static NSString *CellIdentifier = @"SearchResultCellIdentifier";

@interface SearchResultsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, assign) SearchResultsStyle resultsStyle;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SearchResultsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigationUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self searchRequest:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupNavigationUI
{
    self.navigationItem.titleView = self.searchBar;
    
    self.searchBar.text = self.searchText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchRequest:(BOOL)isMore
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:loadArrayFromDocument(@"hotwords.plist")];
    if (![tempArray containsObject:self.searchText]) {
        [tempArray insertObject:self.searchText atIndex:0];
        saveArrayToDocument(@"hotwords.plist", tempArray);
    }
    
    NSDictionary *parameters = @{@"uid": @"queryProduct",
                                 @"startNum": @0,
                                 @"limit": @"15",
                                 @"keywords": self.searchText};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在搜索";
    WEAKSELF
    [APIOperation GET:kSearchHotWordsAPI
           parameters:parameters
         onCompletion:^(id responseData, NSError *error) {
             [hud hide:YES];
             if (!error) {
                 NSDictionary *jsonDict = responseData[@"beans"];
                 NSArray *beans = jsonDict[@"beans"];
                 [weakSelf handerSearchResultsFromDatas:beans more:isMore];
             }else {
                 if (weakSelf.dataSource.count == 0) {
                     weakSelf.resultsStyle = SearchResultsStyleFail;
                     [weakSelf.tableView reloadEmptyDataSet];

                 }
             }
         }];
}

- (void)handerSearchResultsFromDatas:(NSArray *)data more:(BOOL)isMore
{
    if (self.dataSource.count == 0 && data.count == 0) {
        self.resultsStyle = SearchResultsStyleNotData;
        [self.tableView reloadEmptyDataSet];
    }else {
        NSMutableArray *tempArray = [NSMutableArray new];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProductModel *model = [[ProductModel alloc] initWithJson:obj];
            [tempArray addObject:model];
        }];
        if (isMore) {
            [self.dataSource addObjectsFromArray:tempArray];
        }else {
            self.dataSource = tempArray;
        }
        [self.tableView reloadData];
    }
}

#pragma mark - *** search delegate ***

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchText = searchBar.text;
    [self searchRequest:NO];
}

#pragma mark - *** tableView Delegate && DataSource ***

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                             forIndexPath:indexPath];
    ProductModel *model = self.dataSource[indexPath.row];
    cell.productModel = model;
    return cell;
}


#pragma mark - *** DZNEmptyDataSetSource && Delegate ***

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *alertString = @"";
    switch (self.resultsStyle) {
        case SearchResultsStyleNotData:
            alertString = @"没有搜索到商品";
            break;
        case SearchResultsStyleFail:
            alertString = @"点击屏幕，重新加载";
            break;
    
        default:
            break;
    }
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:alertString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    return str;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return self.resultsStyle == SearchResultsStyleFail;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    [self searchRequest:NO];
}


#pragma mark - *** getter ***

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"SearchResultCell"
                                               bundle:nil]
         forCellReuseIdentifier:CellIdentifier];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [self.view addSubview:_tableView];

        setExtraCellLineHidden(_tableView);
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tableView autoPinEdgesToSuperviewEdges];
    }
    return _tableView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.barStyle = UIBarStyleBlackTranslucent;
        _searchBar.placeholder = @"请输入要搜索的内容";
        
        UIView *searchTextField = nil;
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.tintColor=[UIColor blueColor];
        
        _searchBar.delegate = self;
        searchTextField = [[[_searchBar.subviews firstObject] subviews] lastObject];
        searchTextField.backgroundColor = mRGBToColor(0xeeeeee);
    }
    return _searchBar;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

@end
