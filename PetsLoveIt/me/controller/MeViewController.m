//
//  MeViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/21.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MeViewController.h"
#import "YYText.h"
#import "LoginViewController.h"

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerContainerView;
@property (weak, nonatomic) IBOutlet UIView *menuContainerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet YYLabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UIButton *ruleButton;

@property (weak, nonatomic) IBOutlet UIView *menuView1;
@property (weak, nonatomic) IBOutlet UIView *menuView2;
@property (weak, nonatomic) IBOutlet UIView *menuView3;
@property (weak, nonatomic) IBOutlet UIView *menuView4;
@property (weak, nonatomic) IBOutlet UIView *menuView5;
@property (weak, nonatomic) IBOutlet UIView *menuView6;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *menuImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *menuImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *menuImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *menuImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *menuImageView5;
@property (weak, nonatomic) IBOutlet UIImageView *menuImageView6;


@property (strong, nonatomic)  UIView *navigationBarView;
@property (strong, nonatomic)  UILabel *navBarTitleLabel;


@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareViewAndData];
}

- (void) prepareViewAndData{
    
    [self.view setBackgroundColor:mRGBToColor(0xf5f5f5)];
    [self.headerView setBackgroundColor:mRGBToColor(0xf5f5f5)];
    
    self.tableView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight-49) ;
    self.headerContainerView.width = mScreenWidth;
    
    self.nameLabel.center = CGPointMake(mScreenWidth/2, self.nameLabel.center.y);
    self.levelLabel.center = CGPointMake(mScreenWidth/2, self.levelLabel.center.y);
    
    self.avatarImageView.center = CGPointMake(mScreenWidth/2, self.avatarImageView.center.y);
    self.avatarImageView.userInteractionEnabled = YES;
    self.avatarImageView.layer.cornerRadius = 30;
    self.signButton.center =  CGPointMake(mScreenWidth/2, self.signButton.center.y);
    self.signButton.layer.cornerRadius = 18;
    self.ruleButton.left = self.ruleLabel.left = self.signButton.right + 36;
    self.menuContainerView.top = self.headerContainerView.bottom + 10;
    self.menuView1.width = self.menuView2.width = self.menuView3.width = self.menuView4.width=self.menuView5.width = self.menuView6.width = mScreenWidth/3;
    self.menuImageView1.center = CGPointMake(self.menuView1.width/2, self.menuImageView1.center.y);
    self.menuImageView2.center = CGPointMake(self.menuView2.width/2, self.menuImageView2.center.y);
    self.menuImageView3.center = CGPointMake(self.menuView3.width/2, self.menuImageView3.center.y);
    self.menuImageView4.center = CGPointMake(self.menuView4.width/2, self.menuImageView4.center.y);
    self.menuImageView5.center = CGPointMake(self.menuView5.width/2, self.menuImageView5.center.y);
    self.menuImageView6.center = CGPointMake(self.menuView6.width/2, self.menuImageView6.center.y);
    
    self.menuView2.left = self.menuView1.right;
    self.menuView3.left = self.menuView2.right;
    self.menuView5.left = self.menuView4.right;
    self.menuView6.left = self.menuView5.right;
    
    self.menuView4.top = self.menuView1.bottom;
    self.menuView5.top = self.menuView2.bottom;
    self.menuView6.top = self.menuView3.bottom;
    
    [self.headerContainerView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    self.menuContainerView.layer.borderColor = kLayerBorderColor.CGColor;
    self.menuContainerView.layer.borderWidth = kLayerBorderWidth;
    [self.menuContainerView addBorderWithFrame:CGRectMake(0, self.menuContainerView.height/2-1, mScreenWidth, 1) andColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.menuContainerView addBorderWithFrame:CGRectMake(mScreenWidth/3, 0, 1, self.menuContainerView.height) andColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.menuContainerView addBorderWithFrame:CGRectMake(mScreenWidth/3*2, 0, 1, self.menuContainerView.height) andColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    self.menuContainerView.height = 220;
    
    self.headerView.height = self.menuContainerView.bottom +10;
    self.tableView.tableHeaderView = self.headerView;
    
    [self.view addSubview:self.navigationBarView];
    self.navigationBarView.alpha = 0;
    
    if (![AppCache getUserInfo]) {
        self.nameLabel.text = @"Hi 你好";
        self.navBarTitleLabel.text = @"Hi 你好";
        self.levelLabel.text = @"登录签到抽大奖";
        [self.signButton setTitle:@"登录" forState:UIControlStateNormal];
        [self.signButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.nameLabel.text = [AppCache getUserName];
        self.navBarTitleLabel.text = [AppCache getUserName];

        self.levelLabel.text = @"";
        [self.signButton setTitle:@"签到送金币" forState:UIControlStateNormal];
        [self.signButton addTarget:self action:@selector(signAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(UIView *)navigationBarView{
    if (!_navigationBarView) {
        _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 64)];
        
        [_navigationBarView setBackgroundColor:mRGBToColor(0xff4401)];
        
        _navBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, mScreenWidth-60, 24)];
        [_navBarTitleLabel setTextColor:[UIColor whiteColor]];
        [_navBarTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [_navigationBarView addSubview:_navBarTitleLabel];
    }
    return _navigationBarView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 20 ) {
        if (offsetY > 100) {
            self.navigationBarView.alpha = 1;
        }else{
            self.navigationBarView.alpha = offsetY/100;
        }
    }else{
        self.navigationBarView.alpha = 0;
    }
}

- (void) loginAction{
    LoginViewController *vc = [LoginViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) signAction{
    
}

- (IBAction)showRuleVC:(id)sender {
    
}

#pragma mark -
#pragma mark UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"meSettingCell"];
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"每日精选推送";
            cell.imageView.image= [UIImage imageNamed:@"mrjxts_my_icon"];
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"推送设置";
            cell.imageView.image= [UIImage imageNamed:@"grsz_my_icon"];
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"签到提醒";
            cell.imageView.image= [UIImage imageNamed:@"grsz_my_icon"];
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"移动网络图片质量";
            cell.imageView.image= [UIImage imageNamed:@"tpzl_my_icon"];
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"清除缓存";
            cell.imageView.image= [UIImage imageNamed:@"qchc_my_icon"];
        }
            break;
        case 5:
        {
            cell.textLabel.text = @"个人设置";
            cell.imageView.image= [UIImage imageNamed:@"grsz_my_icon"];
        }
            break;
        case 6:
        {
            cell.textLabel.text = @"有奖建议";
            cell.imageView.image= [UIImage imageNamed:@"yjjy_my_icon"];
        }
            break;
        case 7:
        {
            cell.textLabel.text = @"更多";
            cell.imageView.image= [UIImage imageNamed:@"gd_my_icon"];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
