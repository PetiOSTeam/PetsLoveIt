//
//  SearchViewController.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/14.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHeaderView.h"
#import "SearchKeyWordsCell.h"
#import "SearchHistoryFooterView.h"
#import "SearchResultsViewController.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, SearchKeyWordsCellDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) SearchHistoryFooterView *footerView;

@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_tableView) {
        NSArray *historys = [NSArray arrayWithArray:loadArrayFromDocument(@"hotwords.plist")];
        [self.dataSource replaceObjectAtIndex:1 withObject:historys];
    }
    [self.tableView reloadData];
    [self setupSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**
     *  初始化数据
     */
    NSArray *historys = [NSArray arrayWithArray:loadArrayFromDocument(@"hotwords.plist")];
    [self.dataSource addObject:[NSArray new]];
    [self.dataSource addObject:historys];
    
    [self setupNavigationUI];
}

- (void)setupNavigationUI
{
    self.navigationItem.titleView = self.searchBar;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:kOrangeColor forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton sizeToFit];
    [cancelButton addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -5;
    self.navigationItem.rightBarButtonItems = @[spaceItem, rightItem];
}

- (void)setupSubviews
{
    self.tableView.tableFooterView = self.footerView;
    NSArray *historys = [self.dataSource lastObject];
    if (historys.count != 0) {
        [self.footerView.clearButton setTitleColor:mRGBToColor(0x0A35CA)
                                          forState:UIControlStateNormal];
        [self.footerView.clearButton setTitle:@"清除搜索记录"
                                     forState:UIControlStateNormal];
        self.footerView.clearButton.enabled = YES;
        [self.footerView addTopBorderWithColor:kLineColor andWidth:.5];
    }else {
        
        [self.footerView.clearButton setTitleColor:kLineColor
                                          forState:UIControlStateNormal];
        [self.footerView.clearButton setTitle:@"暂无搜索记录"
                                     forState:UIControlStateNormal];
        self.footerView.clearButton.enabled = NO;
           }
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - *** SearchKeywords delegate ***
/**
 *  获取热门关键词
 */
- (void)reloadKeywordsWithCell:(SearchKeyWordsCell *)cell
{
    WEAKSELF
    [APIOperation GET:kDefaultAPI
           parameters:@{@"uid": kHotWordsAPI}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSDictionary *jsonDict = responseObject[@"datas"];
                  if (jsonDict) {
                      NSArray *keywords = jsonDict[@"datas"];
                      if (keywords.count == 0) {
                          [cell stopTitle:@"暂无关键词"];
                      }else {
                          [cell stopTitle:nil];
                          NSMutableArray *tempData = [NSMutableArray new];
                          [keywords enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                              [tempData addObject:[[KeywordsModel alloc] initWithJson:obj]];
                          }];
                          [weakSelf.dataSource replaceObjectAtIndex:0 withObject:tempData];
                          [weakSelf.tableView reloadData];
                      }
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [cell failLoading];
              }];
}

#pragma mark - *** delegate && dataSource ****
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSArray *tempArray = self.dataSource[indexPath.section];
        SearchResultsViewController *resultsVC = [[SearchResultsViewController alloc] init];
        resultsVC.resyltStyle = ResultStyle_Search;
        resultsVC.searchText = tempArray[indexPath.row];
        [self.navigationController pushViewController:resultsVC animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    NSArray *historySearchs = self.dataSource[section];
    return historySearchs.count > 6 ? 6 : historySearchs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSArray *keywords = self.dataSource[indexPath.section];
        if (keywords.count == 0) {
            return 100;
        }
        return [SearchKeyWordsCell heightFromArray:keywords];
    }
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SearchHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"SearchHeaderView"
                                                                 owner:self
                                                               options:nil][0];
    headerView.width = self.view.width;
    if (section == 0) {
        headerView.changeKeyworksButton.hidden = NO;
        WEAKSELF
        headerView.changeAction = ^{
            SearchKeyWordsCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell startLoading];
        };
        headerView.title= @"热门关键词";
    }else {
        headerView.changeKeyworksButton.hidden = YES;
        headerView.title = @"搜索历史";
        
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifierKeyWords = @"CellIdentifierKeyWords";
        SearchKeyWordsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierKeyWords];
        [cell addBottomBorderWithColor:tableView.separatorColor andWidth:.5];
        NSArray *keywords = self.dataSource[indexPath.section];
        if (!cell) {
            cell = [[SearchKeyWordsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:CellIdentifierKeyWords];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (keywords.count == 0) {
                cell.height = 100;
            }else {
                cell.height = [SearchKeyWordsCell heightFromArray:keywords];
            }
           
            cell.width = mScreenWidth;
            cell.delegate = self;
        }
        
        
        if (keywords.count == 0) {
            [cell startLoading];
        }else {
            cell.keywords = keywords;
        }
        return cell;
    }else{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.width = mScreenWidth;
//    [cell addBottomBorderWithColor:tableView.separatorColor andWidth:.5];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = mRGBToColor(0x666666);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    NSArray *data = self.dataSource[indexPath.section];
    cell.textLabel.text = data[indexPath.row];
    return cell;
    }
}


#pragma mark - **** SearchDelegate ***

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    SearchResultsViewController *searchResultsVC = [[SearchResultsViewController alloc] init];
    searchResultsVC.resyltStyle = ResultStyle_Search;
    searchResultsVC.searchText = searchBar.text;
    [self.navigationController pushViewController:searchResultsVC animated:YES];
}

- (void)didClickWithText:(NSString *)hotwordText
{
    SearchResultsViewController *searchResultsVC = [[SearchResultsViewController alloc] init];
    searchResultsVC.resyltStyle = ResultStyle_Search;
    searchResultsVC.searchText = hotwordText;
    [self.navigationController pushViewController:searchResultsVC animated:YES];
}

#pragma mark - **** getter ***

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

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (SearchHistoryFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[NSBundle mainBundle] loadNibNamed:@"SearchHistoryFooterView" owner:self options:nil][0];
        WEAKSELF
        _footerView.clearCompletion = ^{
            NSArray *historys = [NSArray arrayWithArray:loadArrayFromDocument(@"hotwords.plist")];
            [weakSelf.dataSource replaceObjectAtIndex:1 withObject:historys];
            [weakSelf.tableView reloadData];
            [weakSelf setupSubviews];
            
        };
        _footerView.width = self.view.width;
    }
    return _footerView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

@end
