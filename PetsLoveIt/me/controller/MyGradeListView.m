//
//  MyGradeListView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MyGradeListView.h"
#import "GradeDetailViewController.h"

static NSString * CellIdentifier = @"GradientCell";

@interface MyGradeListView () <UICollectionViewDataSource, UICollectionViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, assign) BOOL isNotData;

@property (nonatomic, strong) NSMutableArray *gradeModels;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) GradeStyle gradeStyle;


@end

@implementation MyGradeListView

- (id)initWithFrame:(CGRect)frame
          withStyle:(GradeStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
        self.gradeStyle = style;
        [self loadDataFromSever];
    }
    return self;
}

- (void)loadDataFromSever
{
    _isNotData = NO;
    NSString *uid;
    if (self.gradeStyle == GradeStyleNew) {
        uid = @"getIntegralChanges";
    }else {
    
        uid = @"getUserIntegralChanges";
    }
    
    NSDictionary *parameter = @{@"uid": uid,
                                @"startNum": @0,
                                @"limit": @5,
                                };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = @"加载中...";
    WEAKSELF
    [APIOperation GET:@"getCoreSv.action"
           parameters:parameter
         onCompletion:^(id responseData, NSError *error) {
             [hud hide:YES];
             if (responseData) {
                 NSDictionary *jsonData = responseData[@"beans"];
                 NSArray *beans = jsonData[@"beans"];
                 [weakSelf handerDataFromJsonData:beans];
             }else {
                 weakSelf.isNotData = NO;
                 [weakSelf.collectionView reloadEmptyDataSet];
             }
         }];
}

- (void)handerDataFromJsonData:(NSArray *)data
{
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GradeModel *model = [[GradeModel alloc] initWithJson:obj];
        [self.gradeModels addObject:model];
    }];
    if (self.gradeModels.count == 0) {
        self.isNotData = YES;
    }
    [self.collectionView reloadData];
}

#pragma mark - *** collectionView Delegate ***

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gradeModels.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GradeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                           forIndexPath:indexPath];
    GradeModel *model = self.gradeModels[indexPath.row];
    WEAKSELF
    [cell setGradeModel:model
              withStyle:self.gradeStyle
     GtadeExchangeBlock:^(GradeModel *gradeModel) {
         
         GradeDetailViewController *gradeVC = [[GradeDetailViewController alloc] initWithNibName:@"GradeDetailViewController"
                                                                                          bundle:nil];
         gradeVC.gradeModel = gradeModel;
         [weakSelf.navigation pushViewController:gradeVC animated:YES];
     }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.width - 30) / 2, 225);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - *** DZNEmptyDataSetSource && Delegate ***

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:_isNotData ? @"暂无兑换记录" : @"点击屏幕，重新加载" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    return str;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return !_isNotData;
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
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"GradeCell" bundle:nil]
          forCellWithReuseIdentifier:CellIdentifier];
        
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        
        [self addSubview:_collectionView];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView autoPinEdgesToSuperviewEdges];
    }
    return _collectionView;
}

- (NSMutableArray *)gradeModels
{
    if (!_gradeModels) {
        _gradeModels = [[NSMutableArray alloc] init];
    }
    return _gradeModels;
}

@end
