//
//  UserSettingVC.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/29.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "UserSettingVC.h"

@interface UserSettingVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"个人设置";
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"meSettingCell"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.textLabel setTextColor:mRGBToColor(0x333333)];
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"绑定邮箱";
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            arrow.image = [UIImage imageNamed:@"rightArrowIcon"];
            arrow.right = mScreenWidth - 10;
            arrow.center = CGPointMake(arrow.center.x, 27);
            [cell.contentView addSubview:arrow];
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"绑定手机";
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            arrow.image = [UIImage imageNamed:@"rightArrowIcon"];
            arrow.right = mScreenWidth - 10;
            arrow.center = CGPointMake(arrow.center.x, 27);
            [cell.contentView addSubview:arrow];
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"设置收货地址";
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            arrow.image = [UIImage imageNamed:@"rightArrowIcon"];
            arrow.right = mScreenWidth - 10;
            arrow.center = CGPointMake(arrow.center.x, 27);
            [cell.contentView addSubview:arrow];
        }
            break;
            
            
        default:
            break;
    }
    return cell;
}

@end
