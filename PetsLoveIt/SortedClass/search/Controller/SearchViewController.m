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

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) SearchHistoryFooterView *footerView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *keywords = @[@"零食", @"美容器材", @"妙鲜包", @"保健品", @"狗罐头", @"香波沐浴"];
    NSArray *historys = @[@"冠能狗粮", @"狗链", @"ipad mini", @"iPhone6S", @"德玛西亚"];
    [self.dataSource addObject:keywords];
    [self.dataSource addObject:historys];
    
    [self setupNavigationUI];
    [self setupSubviews];
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
    [self tableView];
    
    self.tableView.tableFooterView = self.footerView;
    NSArray *historys = [self.dataSource lastObject];
    if (historys.count != 0) {
        [self.footerView.clearButton setTitleColor:mRGBToColor(0x0A35CA)
                                          forState:UIControlStateNormal];
        [self.footerView.clearButton setTitle:@"清除搜索记录"
                                     forState:UIControlStateNormal];
    }else {
        [self.footerView.clearButton setTitleColor:kLineColor
                                          forState:UIControlStateNormal];
        [self.footerView.clearButton setTitle:@"暂无搜索记录"
                                     forState:UIControlStateNormal];
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

#pragma mark - *** delegate && dataSource ****

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        SearchResultsViewController *resultsVC = [[SearchResultsViewController alloc] init];
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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSArray *keywords = self.dataSource[indexPath.section];
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
        NSArray *keywords = self.dataSource[indexPath.section];
        if (!cell) {
            cell = [[SearchKeyWordsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:CellIdentifierKeyWords];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.height = [SearchKeyWordsCell heightFromArray:keywords];
            [cell addBottomBorderWithColor:tableView.separatorColor andWidth:.5];
        }
        cell.keywords = keywords;
        return cell;
    }
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
