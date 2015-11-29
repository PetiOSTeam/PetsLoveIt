//
//  ScreenSoretedView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ScreenSoretedView.h"
#import "StoreModel.h"
#import "SoretedHeaderView.h"
#import "PLSoretedCell.h"
#import "ScreecSoretedEntity.h"

static NSString * CellIdentifier = @"GradientCell";
static NSString * ScreenStoreHeaderCellIdentifier = @"GradientHeader";
static NSString * ScreenStoreFooterIdentifier = @"ScreenStoreFooterIdentifier";

@interface ScreenSoretedView() <UICollectionViewDataSource, UICollectionViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) ScreecSoretedEntity *screecSoretedModel;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation ScreenSoretedView

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
    [APIOperation GET:kDefaultAPI parameters:@{@"uid": kClassInfosAPI}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [weakSelf.activityView stopAnimating];
                  [weakSelf handerDataFromJsonDict:responseObject];

              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [weakSelf.activityView stopAnimating];
                  [weakSelf.collectionView reloadEmptyDataSet];
              }];
}

- (void)handerDataFromJsonDict:(NSDictionary *)jsonDict
{
    self.screecSoretedModel = [[ScreecSoretedEntity alloc] initWithJson:jsonDict];
    [self.collectionView reloadData];
}

#pragma mark - *** collectionView Delegate ***

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    BeansEntity *beansEntity = self.screecSoretedModel.beans[section];
    return beansEntity.subsorts.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.screecSoretedModel.beans.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.width, 64);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.width, 1);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        return [self headerFromIndexPath:indexPath];
    }else if ([kind isEqual:UICollectionElementKindSectionFooter]) {
        SoretedHeaderView *footer = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                withReuseIdentifier:ScreenStoreFooterIdentifier
                                                                                       forIndexPath:indexPath];
        [footer addTopBorderWithColor:kLineColor andWidth:.5];
        return footer;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PLSoretedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                    forIndexPath:indexPath];
    
    BeansEntity *beansEntity = self.screecSoretedModel.beans[indexPath.section];
    SubsortsEntity *subsortsEntity = beansEntity.subsorts[indexPath.row];
    cell.subsortsEntity = subsortsEntity;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.width / 4, 56);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - *** inter header and footer action ***

- (UICollectionReusableView *)headerFromIndexPath:(NSIndexPath *)indexPath
{
    SoretedHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:ScreenStoreHeaderCellIdentifier
                                                                                 forIndexPath:indexPath];
    BeansEntity *beansEntity = self.screecSoretedModel.beans[indexPath.section];
    headerView.titleLabel.text = beansEntity.name;
    [headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:beansEntity.sortIcon] placeholderImage:[UIImage imageNamed:@"timeline_image_loading"]];
    return headerView;
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
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"PLSoretedCell" bundle:nil]
          forCellWithReuseIdentifier:CellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"SoretedHeaderView" bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:ScreenStoreHeaderCellIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ScreenStoreFooterIdentifier];
        
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        
        [self addSubview:_collectionView];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView autoPinEdgesToSuperviewEdges];
    }
    return _collectionView;
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
