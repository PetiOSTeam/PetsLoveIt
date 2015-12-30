//
//  MyCollectViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/24.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MyCollectViewController.h"
#import "CorePagesView.h"
#import "NewsListTVC.h"
#import "CarefulSelectViewController.h"
#import "ShareOrderViewController.h"
#import "DiscountViewController.h"
#import "MassTaoViewController.h"
#import "ExperienceViewController.h"
#import "NewsViewController.h"
#import "TaoPetViewController.h"
#import "TaoPetViewController.h"

@interface MyCollectViewController ()<MyCollectDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) CorePagesView *pagesView;
@property (nonatomic,strong) UIView *menuView;

@end

@implementation MyCollectViewController{
    UIButton *allSelectBtn;
    UIButton *rightNaviButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}

- (void)prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"我的收藏";
    [self addNavRightBtn];
    [self setPageViews];
}

- (void)addNavRightBtn{
    rightNaviButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNaviButton.frame = CGRectMake(mScreenWidth-52, 30, 44, 34);
    rightNaviButton.center = CGPointMake(rightNaviButton.center.x, 42);
    [rightNaviButton setTitle:@"编辑" forState:UIControlStateNormal];
    [rightNaviButton setTitle:@"取消" forState:UIControlStateSelected];
    [rightNaviButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightNaviButton setTitleColor:mRGBToColor(0xff4401) forState:UIControlStateNormal];
    [rightNaviButton addTarget:self action:@selector(editCollectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:rightNaviButton];
}

- (void)editCollectAction:(id)sender{
    UIButton *button = sender;
    button.selected = !button.selected;
    BOOL selected = button.selected;

    self.pagesView.scrollView.scrollEnabled = self.pagesView.pagesBarView.userInteractionEnabled= !selected;
    CoreLTVC *currentVC = self.pagesView.currentVC;
    [currentVC showSelectView:selected];
    if (!selected) {
        allSelectBtn.selected = NO;
        [currentVC.seletedArray removeAllObjects];
    }
    [self showMenuView:selected];
}

-(void) showMenuView:(BOOL) show{
    if (show) {
        [UIView animateWithDuration:0.3 animations:^{
            self.menuView.top = mScreenHeight-49;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.menuView.top = mScreenHeight;
        }];
    }
    
}

-(UIView *)menuView{
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, mScreenHeight, mScreenWidth, 49)];
        [_menuView setBackgroundColor:mRGBToColor(0xffffff)];
        [_menuView addTopBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
        allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [allSelectBtn setFrame:CGRectMake(0, 0, 100, _menuView.height)];
        [allSelectBtn setImage:[UIImage imageNamed:@"unChooseIcon"] forState:UIControlStateNormal];
        [allSelectBtn setImage:[UIImage imageNamed:@"chooseIcon"] forState:UIControlStateSelected];
        [allSelectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 100-25-12)];
        [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
        [allSelectBtn setTitleColor:mRGBToColor(0xff4401) forState:UIControlStateNormal];
        [allSelectBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [allSelectBtn addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:allSelectBtn];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setFrame:CGRectMake(0, 0, 100, _menuView.height)];
        deleteBtn.center = CGPointMake(mScreenWidth/2, _menuView.height/2);
        [deleteBtn setImage:[UIImage imageNamed:@"deleteChooseIcon"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteSelectAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_menuView addSubview:deleteBtn];
        [self.view addSubview:_menuView];
    }
    return _menuView;
}

- (void)allSelectAction:(id)sender{
    UIButton *button = sender;
    button.selected = !button.selected;
    BOOL selected = button.selected;
    id currentVC = self.pagesView.currentVC;
    CoreLTVC *vc = currentVC;
    [vc selectAllData:selected];

}

- (void)deleteSelectAction{
    CoreLTVC *currentVC = self.pagesView.currentVC;
    if (currentVC.seletedArray.count ==0 ) {
        mAlertView(@"提示", @"请选择您要删除的收藏");
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确定要删除吗？"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        CoreLTVC *currentVC = self.pagesView.currentVC;
        NSMutableString *proIds = [NSMutableString new];
        for (NSString *proId in currentVC.seletedArray) {
            [proIds appendString:proId];
            [proIds appendString:@","];
        }
        NSDictionary *params = @{
                                 @"uid":@"delUsercollect",
                                 @"collectId":proIds
                                 };
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeNone];
        [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                
                rightNaviButton.selected = NO;
                BOOL selected = rightNaviButton.selected;
                self.pagesView.scrollView.scrollEnabled = self.pagesView.pagesBarView.userInteractionEnabled= !selected;
                CoreLTVC *currentVC = self.pagesView.currentVC;
                [currentVC.seletedArray removeAllObjects];
                [currentVC showSelectView:selected];
                [self showMenuView:selected];
                [currentVC reloadDataWithheaderViewStateRefresh];
            }
        }];
    }
}

#pragma mark - MyCollect delegate
-(void)selectAllCollect:(BOOL)selectAll{
    allSelectBtn.selected = selectAll;
}

- (void)setPageViews{
    
    NSMutableArray *pageModels = [NSMutableArray new];
    NSArray *topicArray = @[@"白菜",@"优惠",@"海淘",@"淘宠",@"晒单",@"经验",@"资讯"];
    for (int i=0; i<topicArray.count; i++) {
        CoreLTVC *vc;
        if (i==1){
            vc = [DiscountViewController new];

        }else if (i==2){
            vc = [MassTaoViewController new];
        }else if (i==3){
            vc = [TaoPetViewController new];
        }
        else if (i ==4) {
            vc = [ShareOrderViewController new];
        } else if (i==5){
            vc = [ExperienceViewController new];
        }else if (i==6){
            vc = [NewsViewController new];
        }else if (i==0) {
            vc = [CarefulSelectViewController new];
            
        }
        vc.isCollect = YES;
        vc.delegate = self;
        CorePageModel *pageModel=[CorePageModel model:vc pageBarName:topicArray[i]];
        [pageModels addObject:pageModel];
        
    }
    _pagesView=[CorePagesView viewWithOwnerVC:self pageModels:pageModels pageWidth:mScreenWidth isHomePage:YES];
    _pagesView.top = 64;
    [self.pagesView.pagesBarView setBackgroundColor:mRGBToColor(0xfeffff)];
    [self.pagesView.scrollView setBackgroundColor:mRGBToColor(0xffffff)];
    [self.view addSubview:self.pagesView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
