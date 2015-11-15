//
//  SearchResultsViewController.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "SearchResultCell.h"

#define kCellHeight 110

static NSString *CellIdentifier = @"SearchResultCellIdentifier";

@interface SearchResultsViewController () <UITableViewDelegate, UITableViewDataSource>

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
    [self setupNavigationUI];
    [self setupSubviews];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupNavigationUI
{
    self.navigationItem.titleView = self.searchBar;
    
//    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
//    [buttonBack setImage:[UIImage imageNamed:@"backBarButtonIcon"] forState:UIControlStateNormal];
//    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [buttonBack sizeToFit];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:buttonBack];
//    self.navigationItem.leftBarButtonItems = @[backItem];

}

- (void)setupSubviews
{
    [self.tableView reloadData];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - *** getter ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;//self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
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
        [self.view addSubview:_tableView];
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
        
        searchTextField = [[[_searchBar.subviews firstObject] subviews] lastObject];
        searchTextField.backgroundColor = mRGBToColor(0xeeeeee);
    }
    return _searchBar;
}

@end
