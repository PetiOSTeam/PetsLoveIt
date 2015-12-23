//
//  UserSettingVC.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/29.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "UserSettingVC.h"
#import "BindEmailViewController.h"
#import "BindMobileViewController.h"
#import "AddressViewController.h"

@interface UserSettingVC ()<UITableViewDataSource,UITableViewDelegate>
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
    return 2;
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
//            cell.textLabel.text = @"绑定邮箱";
//            LocalUserInfoModelClass *userInfo = [AppCache getUserInfo];
//            if ([userInfo.email length]>0) {
//                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 15)];
//                [label setTextColor:mRGBToColor(0x999999)];
//                [label setFont:[UIFont systemFontOfSize:13]];
//                [label setTextAlignment:NSTextAlignmentRight];
//                [label setText:@"已绑定"];
//                label.right = mScreenWidth - 10;
//                label.center = CGPointMake(label.center.x, 27);
//                [cell.contentView addSubview:label];
//            }else{
//                UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
//                arrow.image = [UIImage imageNamed:@"rightArrowIcon"];
//                arrow.right = mScreenWidth - 10;
//                arrow.center = CGPointMake(arrow.center.x, 27);
//                [cell.contentView addSubview:arrow];
//            }
//            
//        }
//            break;
//        case 1:
//        {
            cell.textLabel.text = @"绑定手机";
            LocalUserInfoModelClass *userInfo = [AppCache getUserInfo];
            if ([userInfo.mobile length]>0) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 15)];
                [label setTextColor:mRGBToColor(0x999999)];
                [label setFont:[UIFont systemFontOfSize:13]];
                [label setTextAlignment:NSTextAlignmentRight];
                [label setText:@"已绑定"];
                label.right = mScreenWidth - 10;
                label.center = CGPointMake(label.center.x, 27);
                [cell.contentView addSubview:label];
            }else{
                UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
                arrow.image = [UIImage imageNamed:@"rightArrowIcon"];
                arrow.right = mScreenWidth - 10;
                arrow.center = CGPointMake(arrow.center.x, 27);
                [cell.contentView addSubview:arrow];
            }
            
        }
            break;
        case 1:
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LocalUserInfoModelClass *userInfo = [AppCache getUserInfo];
    if (indexPath.row ==0  && [userInfo.mobile length]==0) {
//        BindEmailViewController *vc = [BindEmailViewController new];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if (indexPath.row == 1 && [userInfo.mobile length]==0){
        BindMobileViewController *vc = [BindMobileViewController new];
        [self.navigationController pushViewController:vc animated:YES];

    }else if (indexPath.row == 1){
        AddressViewController *vc = [AddressViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
