//
//  PushSettingViewController.m
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/29.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "PushSettingViewController.h"
#import "APService.h"
@interface PushSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PushSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"推送设置";
    self.tableView.tableFooterView = [UIView new];
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"开启推送";
            UISwitch *switchBtn = [[UISwitch alloc] init];
            switchBtn.right = mScreenWidth - 10;
            switchBtn.center = CGPointMake(switchBtn.center.x, 27);
            [switchBtn addTarget:self action:@selector(pushSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:switchBtn];
            BOOL flag = IOS_VERSION_8_OR_ABOVE ?  [[UIApplication sharedApplication].currentUserNotificationSettings types] == UIUserNotificationTypeNone : [[UIApplication sharedApplication]enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone ;
            if (flag) {
                [switchBtn setOn:NO];
            }else{
                [switchBtn setOn:YES];
            }
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"声音";
            UISwitch *switchBtn = [[UISwitch alloc] init];
            switchBtn.right = mScreenWidth - 10;
            switchBtn.center = CGPointMake(switchBtn.center.x, 27);
            [switchBtn addTarget:self action:@selector(voiceSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:switchBtn];
            
            NSString *switchBtnFlag = [mUserDefaults objectForKey:kPushVoice];
            if ([switchBtnFlag intValue] == 1) {
                [switchBtn setOn:YES];
            }else{
                [switchBtn setOn:NO];
            }
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"震动";
            UISwitch *switchBtn = [[UISwitch alloc] init];
            switchBtn.right = mScreenWidth - 10;
            switchBtn.center = CGPointMake(switchBtn.center.x, 27);
            [switchBtn addTarget:self action:@selector(shakeSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:switchBtn];
            
            NSString *switchBtnFlag = [mUserDefaults objectForKey:kPushShake];
            if ([switchBtnFlag intValue] == 1) {
                [switchBtn setOn:YES];
            }else{
                [switchBtn setOn:NO];
            }
            
        }
            break;
          
      
        default:
            break;
    }
    return cell;
}

- (void)pushSwitchAction:(id)sender{
    UISwitch *switchBtn = sender;
    [switchBtn setOn:!switchBtn.isOn];
    mAlertView(@"提示", @"请在iPhone的\"设置\" － \"通知\"中进行修改");
}

-(void)voiceSwitchAction:(id)sender{
    UISwitch *switchBtn = sender;
    [mUserDefaults setObject:[NSNumber numberWithBool:switchBtn.isOn] forKey:kPushVoice];
    [mUserDefaults synchronize];
}

-(void)shakeSwitchAction:(id)sender{
    UISwitch *switchBtn = sender;
    
    [mUserDefaults setObject:[NSNumber numberWithBool:switchBtn.isOn] forKey:kPushShake];
    [mUserDefaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
