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
#import "MoreViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "TWImagePicker.h"
#import "LoginViewController.h"
#import "MyCommentViewController.h"

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,TWImagePickerDelegate>
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

@property (nonatomic,strong) UIPickerView *imageQualityPickerView;
@property (nonatomic,strong) UIView *pickerView;

@property (strong,nonatomic) NSString * imageQualityStr;
@property (strong,nonatomic) NSString * sdImageCacheSize;



@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareViewAndData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadUserInfoViewAndData];
    
    float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
    NSString *cacheSize = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
    _sdImageCacheSize = cacheSize;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) prepareViewAndData{
    
    _imageQualityStr = [mUserDefaults objectForKey:kImageQualityKey];
    if (!_imageQualityStr) {
        _imageQualityStr = @"标清";
    }
    
    
    [self.view setBackgroundColor:mRGBToColor(0xf5f5f5)];
    [self.headerView setBackgroundColor:mRGBToColor(0xf5f5f5)];
    
    self.tableView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight-49) ;
    self.headerContainerView.width = mScreenWidth;
    
    self.nameLabel.center = CGPointMake(mScreenWidth/2, self.nameLabel.center.y);
    self.levelLabel.center = CGPointMake(mScreenWidth/2, self.levelLabel.center.y);
    
    self.avatarImageView.center = CGPointMake(mScreenWidth/2, self.avatarImageView.center.y);
    self.avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAvatar)];
    [self.avatarImageView addGestureRecognizer:tapOnAvatar];
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
    
    self.menuView1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnMenuView1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCommentVC)];
    [self.menuView1 addGestureRecognizer:tapOnMenuView1];
    
    self.menuView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnMenuView2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCollectVC)];
    [self.menuView2 addGestureRecognizer:tapOnMenuView2];
    
    self.menuView3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnMenuView3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGradeVC)];
    [self.menuView3 addGestureRecognizer:tapOnMenuView3];
    
    self.menuView4.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnMenuView4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBLVC)];
    [self.menuView4 addGestureRecognizer:tapOnMenuView4];
    
    self.menuView5.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnMenuView5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showArticleVC)];
    [self.menuView5 addGestureRecognizer:tapOnMenuView5];
    
    self.menuView6.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnMenuView6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMsgVC)];
    [self.menuView6 addGestureRecognizer:tapOnMenuView6];
    
    [self.headerContainerView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    self.menuContainerView.layer.borderColor = kLayerBorderColor.CGColor;
    self.menuContainerView.layer.borderWidth = kLayerBorderWidth;
    [self.menuContainerView addBorderWithFrame:CGRectMake(0, self.menuContainerView.height/2-1, mScreenWidth, 1) andColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.menuContainerView addBorderWithFrame:CGRectMake(mScreenWidth/3, 0, 1, self.menuContainerView.height) andColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    [self.menuContainerView addBorderWithFrame:CGRectMake(mScreenWidth/3*2, 0, 1, self.menuContainerView.height) andColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    self.menuContainerView.height = 220;
    
    self.headerView.height = self.menuContainerView.bottom +10;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    
    //[self.view addSubview:self.pickerView];
    
    [self.view addSubview:self.navigationBarView];
    self.navigationBarView.alpha = 0;
    [self loadUserInfoViewAndData];
    
}

-(void) showCommentVC{
    MyCommentViewController *vc = [MyCommentViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void) showCollectVC{
    
}
-(void) showGradeVC{
    
}
-(void) showBLVC{
    
}
-(void) showArticleVC{
    
}

- (void) showMsgVC{
    
}

-(UIView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, mScreenHeight, mScreenWidth, 170)];
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        _imageQualityPickerView = [[UIPickerView alloc] init];
        _imageQualityPickerView.top = 0;
        _imageQualityPickerView.width = mScreenWidth;
        _imageQualityPickerView.dataSource = self;
        _imageQualityPickerView.delegate = self;
        [_imageQualityPickerView reloadAllComponents];
        [_pickerView addSubview:_imageQualityPickerView];

        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setFrame:CGRectMake(0, 0, 50, 44)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:mRGBToColor(0x999999) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView addSubview:cancelBtn];
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [okBtn setFrame:CGRectMake(mScreenWidth-50, 0, 50, 44)];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [okBtn setTitleColor:mRGBToColor(0x333333) forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(okPickerView) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView addSubview:okBtn];
        [_pickerView addTopBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    }
    return _pickerView;
}

-(void)okPickerView{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self hidePickerView];
}

-(void)showPickerView{
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.top = mScreenHeight - _pickerView.height - 49;
    }];
}

-(void)hidePickerView{
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.top = mScreenHeight ;
    }];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (row) {
        case 0:
            return @"标清";
            break;
        case 1:
            return @"高清";
            break;
        default:
            break;
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row == 0) {
        _imageQualityStr = @"标清";
    }else{
        _imageQualityStr = @"高清";
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return  40;
}


- (void) chooseAvatar{
    if (![AppCache getUserInfo]) {
        LoginViewController *vc = [LoginViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [self setHeadImage];
    
}

-(void)setHeadImage
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:mWindow];
}

- (void)uploadAvatar:(NSDictionary*) params{
    [SVProgressHUD showWithStatus:@"正在上传头像，请稍后" maskType:SVProgressHUDMaskTypeClear];
    NSString *urlString = @"getSrvcore.action";
    WEAKSELF
    [APIOperation uploadMedia:urlString parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            NSString *userAvatar = [responseData objectForKey:@"user_icon"];
            LocalUserInfoModelClass *localUserInfo = [AppCache getUserInfo];
            localUserInfo.user_icon = userAvatar;
            [AppCache cacheObject:localUserInfo forKey:HLocalUserInfo];
            [weakSelf.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userAvatar] placeholderImage:kDefaultHeadImage];
            
        }else{
            [SVProgressHUD dismiss];
            mAlertAPIErrorInfo(error);
        }
    }];
}

#pragma mark - action Sheet
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        TWImagePicker *picker = [[TWImagePicker alloc]initWithDelegate:self];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowEditing = YES;
        [picker executeInViewController:self];
    } else if (buttonIndex == 1) {
        TWImagePicker *picker = [[TWImagePicker alloc]initWithDelegate:self];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.maximumNumberOfSelection = 1;
        picker.allowEditing = YES;
        [picker executeInViewController:self];
    }
}

- (void)imagePicker:(TWImagePicker *)picker successed:(NSArray *)infos
{
    NSDictionary *item = [infos firstObject];
    NSString *imagePath = [item objectForKey:kPhotoUtilsImagePath];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    NSDictionary* params = @{
                             @"uid":@"bindUser",
                             @"file" : image
                             };
    
    [self performSelector:@selector(uploadAvatar:) withObject:params afterDelay:0.5f];
    //    [self uploadAvatar:params];
}


- (void) loadUserInfoViewAndData{
    if (![AppCache getUserInfo]) {
        self.nameLabel.text = @"Hi , 你好";
        self.navBarTitleLabel.text = @"Hi , 你好";
        self.levelLabel.text = @"登录签到抽大奖";
        self.avatarImageView.image = [UIImage imageNamed:@"defaultUserAvatar"];
        [self.signButton setTitle:@"登录" forState:UIControlStateNormal];
        [self.signButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"Hi , %@",[AppCache getUserName]];
        self.navBarTitleLabel.text =[NSString stringWithFormat:@"Hi , %@",[AppCache getUserName]] ;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[AppCache getUserAvatar]] placeholderImage:[UIImage imageNamed:@"defaultUserAvatar"]];
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

    if (self.pickerView.top < mScreenHeight) {
        [self hidePickerView];
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
    
    return 7;
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
            UISwitch *switchBtn = [[UISwitch alloc] init];
            switchBtn.right = mScreenWidth - 10;
            switchBtn.center = CGPointMake(switchBtn.center.x, 22);
            [switchBtn addTarget:self action:@selector(pushSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:switchBtn];
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"推送设置";
            cell.imageView.image= [UIImage imageNamed:@"tssz_my_icon"];
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            arrow.image = [UIImage imageNamed:@"rightArrowIcon"];
            arrow.right = mScreenWidth - 10;
            arrow.center = CGPointMake(arrow.center.x, 22);
            [cell.contentView addSubview:arrow];

        }
            break;
        case 2:
        {
            cell.textLabel.text = @"签到提醒";
            cell.imageView.image= [UIImage imageNamed:@"qdtx_my_icon"];
            UISwitch *switchBtn = [[UISwitch alloc] init];
            switchBtn.right = mScreenWidth - 10;
            switchBtn.center = CGPointMake(switchBtn.center.x, 22);
            [switchBtn addTarget:self action:@selector(signSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:switchBtn];
            
        }
            break;
//        case 3:
//        {
//            cell.textLabel.text = @"移动网络图片质量";
//            cell.imageView.image= [UIImage imageNamed:@"tpzl_my_icon"];
//            UILabel *imageQualityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
//            [imageQualityLabel setTextColor:mRGBToColor(0x497fbf)];
//            [imageQualityLabel setFont:[UIFont systemFontOfSize:13]];
//            [imageQualityLabel setTextAlignment:NSTextAlignmentRight];
//            [imageQualityLabel setText:_imageQualityStr];
//            imageQualityLabel.right = mScreenWidth - 10;
//            imageQualityLabel.center = CGPointMake(imageQualityLabel.center.x, 22);
//            [cell.contentView addSubview:imageQualityLabel];
//        }
            break;
        case 3:
        {
            cell.textLabel.text = @"清除缓存";
            cell.imageView.image= [UIImage imageNamed:@"qchc_my_icon"];
            UILabel *imageCacheLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 15)];
            [imageCacheLabel setTextColor:mRGBToColor(0x999999)];
            [imageCacheLabel setFont:[UIFont systemFontOfSize:13]];
            [imageCacheLabel setTextAlignment:NSTextAlignmentRight];
            [imageCacheLabel setText:_sdImageCacheSize];
            imageCacheLabel.right = mScreenWidth - 10;
            imageCacheLabel.center = CGPointMake(imageCacheLabel.center.x, 22);
            [cell.contentView addSubview:imageCacheLabel];
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"个人设置";
            cell.imageView.image= [UIImage imageNamed:@"grsz_my_icon"];
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            arrow.image = [UIImage imageNamed:@"rightArrowIcon"];
            arrow.right = mScreenWidth - 10;
            arrow.center = CGPointMake(arrow.center.x, 22);
            [cell.contentView addSubview:arrow];
        }
            break;
        case 5:
        {
            cell.textLabel.text = @"有奖建议";
            cell.imageView.image= [UIImage imageNamed:@"yjjy_my_icon"];
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            arrow.image = [UIImage imageNamed:@"rightArrowIcon"];
            arrow.right = mScreenWidth - 10;
            arrow.center = CGPointMake(arrow.center.x, 22);
            [cell.contentView addSubview:arrow];
        }
            break;
        case 6:
        {
            cell.textLabel.text = @"更多";
            cell.imageView.image= [UIImage imageNamed:@"gd_my_icon"];
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            arrow.image = [UIImage imageNamed:@"rightArrowIcon"];
            arrow.right = mScreenWidth - 10;
            arrow.center = CGPointMake(arrow.center.x, 22);
            [cell.contentView addSubview:arrow];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void) pushSwitchAction:(id)sender{
    
}

- (void) signSwitchAction:(id)sender{
    
}

- (void) cleanSDImageCache{
    
    float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
    [mAppUtils showHint:clearCacheName];
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    _sdImageCacheSize = @"0.00K";
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
//        case 3:
//            [self showPickerView];
//            break;
        case 3:
            [self cleanSDImageCache];
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
        {
            MoreViewController *vc  = [MoreViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
