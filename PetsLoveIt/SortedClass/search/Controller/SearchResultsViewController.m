//
//  SearchResultsViewController.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "SearchResultCell.h"
#import "SiftSectionView.h"
#import "MJRefresh.h"
#import "GoodsDetailViewController.h"

typedef enum : NSUInteger {
    SearchResultsStyleNone,
    SearchResultsStyleFail,
    SearchResultsStyleNotData,
} SearchResultsStyle;

#define kCellHeight 110

static NSString *CellIdentifier = @"SearchResultCell";

@interface SearchResultsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    BOOL _isPush;
}

@property (nonatomic, assign) NSInteger siftIndex;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) SearchResultsStyle resultsStyle;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) SiftSectionView *siftSectionView;


@end

@implementation SearchResultsViewController

- (void)dealloc
{
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isPush = NO;
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [self setupNavigationUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_isPush) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
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
    
    [self.searchBar resignFirstResponder];
    WEAKSELF
    [self.tableView addFooterWithCallback:^{
        weakSelf.page = weakSelf.page+1;
        [weakSelf searchRequest:YES];
    }];
    
    NSString *order = [NSString stringWithFormat:@"%li",self.siftIndex];
    NSDictionary *parameters = [[NSDictionary alloc]init];
    if (self.resyltStyle == ResultStyle_Search) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:loadArrayFromDocument(@"hotwords.plist")];
        if (![tempArray containsObject:self.searchText]) {
            [tempArray insertObject:self.searchText atIndex:0];
        }else {
            NSInteger index = [tempArray indexOfObject:self.searchText];
            id obj = [[tempArray objectAtIndex:index] mutableCopy];
            [tempArray removeObjectAtIndex:index];
            [tempArray insertObject:obj atIndex:0];
        }
        saveArrayToDocument(@"hotwords.plist", tempArray);
        parameters = @{@"uid": @"queryProduct",
                                     @"startNum": @(_page),
                                     @"limit": @"15",
                                     @"keywords": self.searchText,
                                     @"order": order
                       };
    }
    
    
    if (self.resyltStyle == ResultStyle_Sift) {
        parameters = @{@"uid": @"getProductsBySort",
                                     @"startNum":@"0",
                                     @"limit": @"15",
                                     @"minSortId": self.sortId,
                                     @"order": order
                                     };
    }
//    http://www.cwaizg.cn/petweb/actions/getCoreSv.action?uid=getProductsByMall&limit=5&prodMallId=&startNum=0&userToken=userToken_84ae594bd8004a80bc7b8e741782b87e
    if (self.resyltStyle == ResultStyle_Mall) {
        parameters = @{@"uid": @"getProductsByMall",
                       @"startNum":@"0",
                       @"limit": @"5",
                       @"prodMallId": self.sortId,
                       @"order": order  
                       };

    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在搜索";
    [APIOperation GET:kSearchHotWordsAPI
           parameters:dict
         onCompletion:^(id responseData, NSError *error) {
             [hud hide:YES];
             
             if (responseData) {
                 NSDictionary *jsonDict = responseData[@"beans"];
                 NSArray *beans = jsonDict[@"beans"];
                 [weakSelf handerSearchResultsFromDatas:beans more:isMore];
                 
             }else {
                 [weakSelf.tableView footerEndRefreshing];
                 if (weakSelf.dataSource.count == 0) {
                     weakSelf.resultsStyle = SearchResultsStyleFail;
                     [weakSelf.tableView reloadEmptyDataSet];
                 }
             }
             [weakSelf.tableView footerEndRefreshing];
         }];
}

- (void)handerSearchResultsFromDatas:(NSArray *)data more:(BOOL)isMore
{
    if (self.dataSource.count == 0 && data.count == 0) {
        self.resultsStyle = SearchResultsStyleNotData;
        [self.tableView reloadEmptyDataSet];
    }else {
        if (data.count < 15) {
            if (self.tableView.footer) {
                [self.tableView.footer removeFromSuperview];
                self.tableView.footer = nil;
            }
        }
        NSMutableArray *tempArray = [NSMutableArray new];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GoodsModel *model = [[GoodsModel alloc] initWithDictionary:obj];
            [tempArray addObject:model];
        }];
//        NSLog(@"temparray%@",tempArray);
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
    self.resyltStyle = ResultStyle_Search;
    [self searchRequest:NO];
}

#pragma mark - *** tableView Delegate && DataSource ***

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsModel *model = self.dataSource[indexPath.row];

    GoodsDetailViewController *goodsDetailVC = [[GoodsDetailViewController alloc] init];
    goodsDetailVC.goods = model;
    goodsDetailVC.apptypename = model.apptypename;
   

    

    [self.navigationController pushViewController:goodsDetailVC animated:YES];
    _isPush = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
        return 50;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
        return self.siftSectionView;
    
    
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
    
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchResultCell" owner:self options:nil] firstObject];
    }


    GoodsModel *model = self.dataSource[indexPath.row];
    cell.productModel = model;
    return cell;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
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
//        [_tableView registerNib:[UINib nibWithNibName:@"SearchResultCell"
//                                               bundle:nil]
//         forCellReuseIdentifier:CellIdentifier];
//       
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

- (SiftSectionView *)siftSectionView
{
    if (!_siftSectionView) {
        _siftSectionView = [[NSBundle mainBundle] loadNibNamed:@"SiftSectionView"
                                                         owner:self
                                                       options:nil][0];
        WEAKSELF
        _siftSectionView.selectSiftIndex = ^(NSInteger index) {
            weakSelf.siftIndex = index;
            weakSelf.page = 0;
            [weakSelf searchRequest:NO];
        };
    }
    return _siftSectionView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

@end
