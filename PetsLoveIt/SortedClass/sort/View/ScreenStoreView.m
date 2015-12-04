//
//  ScreenStoreView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/12.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ScreenStoreView.h"
#import "StoreModel.h"
#import "StoreHeaderView.h"
#import "StoreFooterView.h"
#import "PLStoreCell.h"
#import "SearchResultsViewController.h"

static NSString * CellIdentifier = @"GradientCell";
static NSString * ScreenStoreHeaderCellIdentifier = @"GradientHeader";
static NSString * ScreenStoreFooterCellIdentifier = @"GradientFooter";

#define DefaultNum 9

@interface ScreenStoreView ()<UICollectionViewDataSource, UICollectionViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    BOOL _moreStoreInter;
    BOOL _moreStoreOuter;
    
    NSInteger _interSectionNum;
    NSInteger _outerSectionNum;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation ScreenStoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadDataFromSever];
    }
    return self;
}

- (void)loadDataFromSever
{
    [self.activityView startAnimating];
    WEAKSELF
    [APIOperation GET:kDefaultAPI
           parameters:@{@"uid": kSortChinaprodAPI}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSDictionary *jsonDict = responseObject[@"beans"];
                  if (jsonDict) {
                      [weakSelf handerDataSourceFromJsonDict:jsonDict];
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [weakSelf.activityView stopAnimating];
                  [weakSelf.collectionView reloadEmptyDataSet];
              }];
}

- (void)handerDataSourceFromJsonDict:(NSDictionary *)jsonDict
{
    NSArray *abroadMall = jsonDict[@"beans"];
    NSMutableArray *chinalMalls = [NSMutableArray new];
    [abroadMall enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StoreModel *model = [[StoreModel alloc] initWithJson:obj];
        [chinalMalls addObject:model];
    }];
    [self.dataSource addObject:chinalMalls];
    [self loadAbroadprodData];
}

- (void)loadAbroadprodData
{
    WEAKSELF
    [APIOperation GET:kDefaultAPI
           parameters:@{@"uid": kSortAbroadprodAPI}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [weakSelf.activityView stopAnimating];
                  NSDictionary *jsonDict = responseObject[@"beans"];
                  if (jsonDict) {
                      [weakSelf handerAbroadprodData:jsonDict];
                  }else {
                      [self.collectionView reloadData];
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [weakSelf.activityView stopAnimating];
                  [weakSelf.collectionView reloadEmptyDataSet];
              }];
}

- (void)handerAbroadprodData:(NSDictionary *)jsonDict
{
    NSArray *abroadMall = jsonDict[@"beans"];
    NSMutableArray *chinalMalls = [NSMutableArray new];
    [abroadMall enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StoreModel *model = [[StoreModel alloc] initWithJson:obj];
        [chinalMalls addObject:model];
    }];
    [self.dataSource addObject:chinalMalls];
    [self.collectionView reloadData];
}

#pragma mark - *** collectionView Delegate ***

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tempData = self.dataSource[indexPath.section];
    StoreModel *model = tempData[indexPath.row];

    SearchResultsViewController *resultsVC = [[SearchResultsViewController alloc] init];
    resultsVC.resyltStyle = ResultStyle_Sift;
    resultsVC.searchText = model.name;
    [self.navigation pushViewController:resultsVC animated:YES];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *tempArray = self.dataSource[section];
    if (section == 0) {
        if (tempArray.count > DefaultNum) {
            _interSectionNum = !_moreStoreInter ? DefaultNum : tempArray.count;
            return _interSectionNum;
        }else {
            _interSectionNum = tempArray.count;
            return _interSectionNum;
        }
    }
    if (tempArray.count > DefaultNum) {
        _outerSectionNum = !_moreStoreOuter ? DefaultNum : tempArray.count;
        return _outerSectionNum;
    }else {
        _outerSectionNum = tempArray.count;
        return _outerSectionNum;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.width, 45);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    NSArray *tempArray = self.dataSource[section];
    if (tempArray.count <= DefaultNum) {
        return CGSizeMake(self.width, 1);
    }
    return CGSizeMake(self.width, 45);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        return [self headerFromIndexPath:indexPath];
    }else {
        return [self footerFromIndexPath:indexPath];
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PLStoreCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSArray *tempData = self.dataSource[indexPath.section];
    BOOL bottom = YES;
    
    NSInteger num = 0;
    if (indexPath.section == 0) {
        num = _interSectionNum % 3;
    }else {
        num = _outerSectionNum % 3;
    }
    StoreModel *model = tempData[indexPath.row];
    if (num == 0) {
        num = 3;
    }
    if (indexPath.section == 0) {
        if ([tempData indexOfObject:model] >= _interSectionNum - num) {
            bottom = NO;
        }
    }else {
        if ([tempData indexOfObject:model] >= _outerSectionNum - num) {
            bottom = NO;
        }

    }
    cell.model = model;
    cell.isBottom = bottom;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.width / 3, 56);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - *** inter header and footer action ***

- (UICollectionReusableView *)headerFromIndexPath:(NSIndexPath *)indexPath
{
    StoreHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:ScreenStoreHeaderCellIdentifier
                                                                                 forIndexPath:indexPath];
    if (indexPath.section == 0) {
        headerView.title = @"国内商城";
    }else {
        headerView.title = @"国外商城";
    }
    return headerView;
}

- (UICollectionReusableView *)footerFromIndexPath:(NSIndexPath *)indexPath
{
    StoreFooterView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                          withReuseIdentifier:ScreenStoreFooterCellIdentifier
                                                                                 forIndexPath:indexPath];
    NSArray *tempArray = self.dataSource[indexPath.section];
    if (tempArray.count <= DefaultNum) {
        if (indexPath.section == 0) {
            footerView.title = @"";
        }else {
            footerView.title = @"";
        }
        return footerView;
    }
    if (indexPath.section == 0) {
        if (_moreStoreInter) {
            footerView.title = @"收起";
        }else {
            footerView.title = @"查看更多国内商城";
        }
        WEAKSELF
        footerView.moreAction = ^{
            _moreStoreInter = !_moreStoreInter;
            [weakSelf.collectionView reloadData];
        };
    }else {
        if (_moreStoreOuter) {
            footerView.title = @"收起";
        }else {
            footerView.title = @"查看更多国外商城";
        }
        WEAKSELF
        footerView.moreAction = ^{
            _moreStoreOuter = !_moreStoreOuter;
            [weakSelf.collectionView reloadData];
        };
        
    }
    return footerView;
}

#pragma mark - *** DZNEmptyDataSetSource && Delegate ***

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"点击屏幕，重新加载" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    return str;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    [self loadDataFromSever];
}

#pragma mark - *** getter ***

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = -.5;
        flowLayout.minimumInteritemSpacing = -.5;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"PLStoreCell" bundle:nil]
          forCellWithReuseIdentifier:CellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"StoreHeaderView" bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:ScreenStoreHeaderCellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"StoreFooterView" bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                 withReuseIdentifier:ScreenStoreFooterCellIdentifier];
        
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;

        [self addSubview:_collectionView];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView autoPinEdgesToSuperviewEdges];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityView];
        _activityView.translatesAutoresizingMaskIntoConstraints = NO;
        [_activityView autoCenterInSuperview];
    }
    return _activityView;
}

@end
