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
#import "MyCollectViewController.h"
#import "MyGradeViewController.h"
#import "MyBLViewController.h"
#import "MyArticleViewController.h"
#import "MyMsgViewController.h"
#import "AwardRulesViewController.h"
#import "PushSettingViewController.h"
#import "UserSettingVC.h"
#import "AdviceViewController.h"
#import "APService.h"
#import "SigninbubbleButton.h"
#import "CAAnimation+CoreRefresh.h"
#import "ShakeremindView.h"
#import "GoodsDetailViewController.h"
@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,TWImagePickerDelegate,UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerContainerView;
@property (weak, nonatomic) IBOutlet UIView *menuContainerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic)  YYLabel *levelLabel;

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
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
/** 积分实时数据 */
@property (strong, nonatomic) NSString *integralstr;
@property (strong, nonatomic) NSString *signinnum;
@property (strong, nonatomic)  UIView *navigationBarView;
@property (strong, nonatomic)  UILabel *navBarTitleLabel;


@property (nonatomic,strong) UIPickerView *imageQualityPickerView;
@property (nonatomic,strong) UIView *pickerView;

@property (strong,nonatomic) NSString * imageQualityStr;
@property (strong,nonatomic) NSString * sdImageCacheSize;
/** 点击投稿后显示的提醒 */
@property (weak,nonatomic) UIView *remindview;
/** 点击投稿后遮盖 */
@property (strong,nonatomic) UIView *maskview;

@end

@implementation MeViewController{
    UIImageView *dotImage;
    UIImageView *dotOnMsgImage;
    UIImageView *dotOnCommentImage;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self refreshtheintegral];
    [self prepareViewAndData];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshtheintegral) name:@"refreshtheintegral" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshtheintegral];
    [self loadUserInfoViewAndData];
    
    float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
    NSString *cacheSize = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
    _sdImageCacheSize = cacheSize;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) showRedDotViewWithmenuViewNum:(int)num{
      if (!dotOnMsgImage) {
        dotOnMsgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redDotIcon"]];
        dotOnMsgImage.backgroundColor = [UIColor clearColor];
        dotOnMsgImage.frame = CGRectMake((mScreenWidth/12)*3 , 15, 6, 6);
        
    }
    if (!dotOnCommentImage) {
        dotOnCommentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redDotIcon"]];
        dotOnCommentImage.backgroundColor = [UIColor clearColor];
        dotOnCommentImage.frame = CGRectMake((mScreenWidth/12)*3 , 15, 6, 6);
        
    }
    if (num == 1) {
        [self.menuView1 addSubview:dotOnCommentImage];
        return;
    }
    if (num == 6) {
        [self.menuView6 addSubview:dotOnMsgImage];
        return;
    }
    
   
}

- (void) hideRedDotViewWithmenuViewNum:(int)num{
    if (num == 1) {
        [dotOnCommentImage removeFromSuperview];
        return;
    }
    if (num == 6) {
       [dotOnMsgImage removeFromSuperview];
        return;
    }

}

- (void) prepareViewAndData{
    
    _imageQualityStr = [mUserDefaults objectForKey:kImageQualityKey];
    if (!_imageQualityStr) {
        _imageQualityStr = @"标清";
    }

    _levelLabel = [YYLabel new];
    _levelLabel.font = [UIFont systemFontOfSize:12];
    _levelLabel.textColor = mRGBToColor(0x333333);
    _levelLabel.userInteractionEnabled = YES;
    _levelLabel.numberOfLines = 0;
    [_levelLabel setTextAlignment:NSTextAlignmentCenter];
    _levelLabel.frame = CGRectMake(8, self.nameLabel.bottom+7, mScreenWidth-16    ,20);
    
    [self.headerView addSubview:_levelLabel];
    
    
    [self.view setBackgroundColor:mRGBToColor(0xf5f5f5)];
    [self.headerView setBackgroundColor:mRGBToColor(0xf5f5f5)];
    
    self.tableView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight-49) ;
    self.headerContainerView.width = mScreenWidth;
    
    self.nameLabel.center = CGPointMake(mScreenWidth/2, self.nameLabel.center.y);
    self.levelLabel.center = CGPointMake(mScreenWidth/2, self.levelLabel.center.y);
    
    self.avatarImageView.center = CGPointMake(mScreenWidth/2, self.avatarImageView.center.y);
    self.avatarImageView.userInteractionEnabled = YES;
    self.photoImageView.right = self.avatarImageView.right ;
    UITapGestureRecognizer *tapOnAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAvatar)];
    [self.avatarImageView addGestureRecognizer:tapOnAvatar];
    self.avatarImageView.layer.cornerRadius = 30;
    self.avatarImageView.clipsToBounds = YES;
    self.signButton.center =  CGPointMake(mScreenWidth/2, self.signButton.center.y);
    self.signButton.layer.cornerRadius = 18;

    self.ruleButton.left = self.ruleLabel.left = self.signButton.right + 10;
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

-(void) showLoginVC{
        LoginViewController *vc = [LoginViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    
}

-(void) showCommentVC{
    if (![AppCache getUserInfo]) {
        [self showLoginVC];
        return;
    }

    MyCommentViewController *vc = [MyCommentViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void) showCollectVC{
    if (![AppCache getUserInfo]) {
        [self showLoginVC];
        return;
    }
    MyCollectViewController *vc = [MyCollectViewController new];
    [self.navigationController pushViewController:vc animated:YES];

}
-(void) showGradeVC{
    if (![AppCache getUserInfo]) {
        [self showLoginVC];
        return;
    }
    MyGradeViewController *vc = [MyGradeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void) showBLVC{
    if (![AppCache getUserInfo]) {
        [self showLoginVC];
        return;
    }
    MyBLViewController *vc = [MyBLViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 点击投稿后弹出提醒的相关方法
-(void) showArticleVC{
    ShakeremindView *remindview = [[ShakeremindView alloc]initWithFrame:CGRectMake(0, 0, 230, 160)];
    remindview.center = CGPointMake(mScreenWidth/2, mScreenHeight/2);
    remindview.lable1.text = @"研发中，敬请期待";
    remindview.lable1.font = [UIFont systemFontOfSize:16];
    [remindview.lelftButton setTitle:@"确定" forState:UIControlStateNormal];
    [remindview.lelftButton addTarget:self  action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    remindview.hidesrightButton = YES;
    remindview.lable1.center = CGPointMake(remindview.width/2,remindview.height/2 -20);
    // 添加动画
    [self addanimationWithShakeView:remindview];

    
}
- (void)addanimationWithShakeView:(UIView *)remindview
{
    [self.tabBarController.view addSubview:self.maskview];
    [self.tabBarController.view addSubview:remindview];
    self.maskview.alpha = 0;
    remindview.bottom = 0;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.remindview = remindview;
        self.remindview.center = CGPointMake(mScreenWidth/2, mScreenHeight/2);
        self.maskview.alpha = 0.7;
        
}];
  
    
}
- (UIView *)maskview{
    if (!_maskview) {
        _maskview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        [_maskview setBackgroundColor:[UIColor blackColor]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
        [_maskview addGestureRecognizer:tap];
       ;
    }
    return _maskview;
}
- (void)cancelAction{
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.maskview removeFromSuperview];
        [self.remindview removeFromSuperview];
    }];
}

#pragma mark -
- (void) showMsgVC{
    if (![AppCache getUserInfo]) {
        [self showLoginVC];
        return;
    }
    MyMsgViewController *vc  =[MyMsgViewController new];
    [self.navigationController pushViewController:vc animated:YES];

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

- (void)imagePicker:(TWImagePicker *)picker successed:(NSArray *)infos
{
    NSDictionary *item = [infos firstObject];
    NSString *imagePath = [item objectForKey:kPhotoUtilsImagePath];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    NSDictionary* params = @{
                             @"uid":@"bindUserIcon",
                             @"fileParamKeyName":@"userIcon",
                             @"file" : image
                             };
    
    [self performSelector:@selector(uploadAvatar:) withObject:params afterDelay:0.5f];
    //    [self uploadAvatar:params];
}

- (void) getNewMsg{
    
    __block NSDictionary *params =@{@"uid":@"getUserSystemMsg",
                            @"msgType":@"2"
                            };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            __block int kNewSysMsgCount = [[[responseData objectForKey:@"beans"] objectForKey:@"newNumber"] intValue];
            params =@{@"uid":@"getUserSystemMsg",
                      @"msgType":@"1"
                      };
            [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
                if (!error) {
                    int kNewUserMsgCount = [[[responseData objectForKey:@"beans"] objectForKey:@"newNumber"] intValue];
                    if (kNewSysMsgCount + kNewUserMsgCount >0) {
                        [self showRedDotViewWithmenuViewNum:6];
                    }else{
                        [self hideRedDotViewWithmenuViewNum:6];
                        
                    }
                }
            }];
        }
    }];
  
           NSDictionary *params2 =@{@"uid":@"getNew2MeComment",
                    };
    [APIOperation GET:@"common.action" parameters:params2 onCompletion:^(id responseData, NSError *error) {
        if (!error) {
           
                [self showRedDotViewWithmenuViewNum:1];
          
           
        }else{
            [self hideRedDotViewWithmenuViewNum:1];
            
        }
    }];
    
    [self refreshremind];
}

- (void) getUserInfoFromServer{
    NSDictionary *params =@{@"uid":@"getLoginInfo"};
    [APIOperation GET:@"getCoreSv.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            NSString *userAvatar = [[responseData objectForKey:@"bean"] objectForKey:@"userIcon"];
            LocalUserInfoModelClass *localUserInfo = [AppCache getUserInfo];
            localUserInfo.user_icon = userAvatar;
            [AppCache cacheObject:localUserInfo forKey:HLocalUserInfo];
            
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userAvatar] placeholderImage:kDefaultHeadImage];
        }
    }];
}

- (void)uploadAvatar:(NSDictionary*) params{
    [SVProgressHUD showWithStatus:@"正在上传头像，请稍后" maskType:SVProgressHUDMaskTypeClear];
    NSString *urlString = @"getSrvcore.action";
    //WEAKSELF
    [APIOperation uploadMedia:urlString parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            self.photoImageView.image = [UIImage imageNamed:@"colorPhotoIcon"];
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            NSString *userAvatar = [[responseData objectForKey:@"bean"] objectForKey:@"userIcon"];
            LocalUserInfoModelClass *localUserInfo = [AppCache getUserInfo];
            localUserInfo.user_icon = userAvatar;
            [AppCache cacheObject:localUserInfo forKey:HLocalUserInfo];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SDImageCache sharedImageCache] clearMemory];
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userAvatar] placeholderImage:kDefaultHeadImage];
                    //获取user详情，确保万无一失
                    [self getUserInfoFromServer];
                }];
                
            });
            
            
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




- (void) loadUserInfoViewAndData{
    LocalUserInfoModelClass *userInfo = [AppCache getUserInfo];
    if (!userInfo) {
        [self.signButton removeTarget:self action:@selector(signAction) forControlEvents:UIControlEventTouchUpInside];
        self.ruleLabel.hidden = YES;
        self.ruleButton.hidden = YES;
        self.nameLabel.text = @"哈喽，你还没有登录哦";
        self.navBarTitleLabel.text = @"Hi , 你好";
        self.levelLabel.text = @"快来登录和小伙伴们一起互动吧";
        self.photoImageView.hidden = YES;
        _levelLabel.width = 200;
        [_levelLabel setTextAlignment:NSTextAlignmentCenter];
        _levelLabel.center  = CGPointMake(mScreenWidth/2, _levelLabel.center.y);
        self.avatarImageView.image = [UIImage imageNamed:@"defaultUserAvatar"];
        [self.signButton setTitle:@"登录" forState:UIControlStateNormal];
        [self.signButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self getNewMsg];//获取是否有新消息
        [self.signButton removeTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        self.ruleLabel.hidden = NO;
        self.ruleButton.hidden = NO;
        self.nameLabel.text = [NSString stringWithFormat:@"Hi , %@",[AppCache getUserName]];
        self.navBarTitleLabel.text =[NSString stringWithFormat:@"Hi , %@",[AppCache getUserName]] ;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[AppCache getUserAvatar]] placeholderImage:[UIImage imageNamed:@"defaultUserAvatar"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            self.photoImageView.image =[UIImage imageNamed:@"colorPhotoIcon"];
        }];
        self.photoImageView.hidden = NO;
        
        //self.levelLabel.text = @"";
        // 加载等级和积分
        [self loadingIntegralandrankWithData:userInfo];
        
        [self isSignin];
        
    }
    [self.tableView reloadData];

    
}
// 查询是否签到
- (void)isSignin
{
    
    NSDictionary *parameter = @{@"uid": @"getUserSign"};
    [APIOperation GET:@"common.action"
           parameters:parameter
         onCompletion:^(id responseData, NSError *error) {
             if (responseData) {
//                 NSLog(@"%@",responseData);
                 NSDictionary *data =  [responseData objectForKey:@"beans"];
                 NSString *continuousSign = data[@"continuousSign"];
                 NSString *issignin = data[@"isSign"];
                 if ([issignin isEqualToString:@"1"]) {
                     [self.signButton setTitle:[NSString stringWithFormat:@"已连续签到%i天",[continuousSign intValue]+1] forState:UIControlStateNormal];
                     [self.signButton addTarget:self action:@selector(signAction) forControlEvents:UIControlEventTouchUpInside];
                     
                 }else
                 {
                     [self.signButton setTitle:@"签到送积分" forState:UIControlStateNormal];
                    [self.signButton addTarget:self action:@selector(signAction) forControlEvents:UIControlEventTouchUpInside];

                 }
                 
                 
             }else {
                 
                [self.signButton addTarget:self action:@selector(signAction) forControlEvents:UIControlEventTouchUpInside];
                             }

         }];
 
}
- (void)signremindAction
{
    [mAppUtils showHint:@"今天已经签到过了!"];
}
// 加载等级和积分
- (void)loadingIntegralandrankWithData:(LocalUserInfoModelClass *)userInfo
{
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"等级: "];
    UIFont *font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *attachment = nil;
    int grade = [userInfo.userGrade intValue];

    int kingNum = grade/64;
    int sunNum = grade%64==0?0:grade%64/16;
    int moonNum = (grade%64==0||grade%16==0)?0:grade%16/4;
    int starNum = (grade%64==0||grade%16==0||grade%4==0)?0:grade%4;
    //如果等级为0，显示一个星星
    
    if (starNum == 0&&grade ==0) {
        starNum = 1;
    }
    
    for (int i=0; i<kingNum; i++) {
        UIImage *image = [UIImage imageNamed:@"kingIcon"];
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString: attachment];
    }
    for (int i=0; i<sunNum; i++) {
        UIImage *image = [UIImage imageNamed:@"sunIcon"];
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString: attachment];
    }
    for (int i=0; i<moonNum; i++) {
        UIImage *image = [UIImage imageNamed:@"moonIcon"];
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString: attachment];
    }
    for (int i=0; i<starNum; i++) {
        // UIImage attachment
        UIImage *image = [UIImage imageNamed:@"starIcon"];
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString: attachment];
    }
    //积分
    NSMutableAttributedString *userIntegral;
    if (!self.integralstr) {
        self.integralstr = userInfo.userIntegral;
    }
    userIntegral = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  积分: %@",self.integralstr]];
   
    
    [text appendAttributedString:userIntegral];
    
    [_levelLabel setTextAlignment:NSTextAlignmentCenter];
    _levelLabel.attributedText = text;
    CGSize size = CGSizeMake(mScreenWidth-16, 20);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
    _levelLabel.width = layout.textBoundingSize.width;
    _levelLabel.center  = CGPointMake(mScreenWidth/2, _levelLabel.center.y);
  
}
- (void)refreshData
{
    
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
    
    NSDictionary *params = @{
                             @"uid":@"saveUserSign",
                             @"signClien":@"iOS"
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            NSString *signinnum = [[responseData objectForKey:@"bean"] objectForKey:@"addIntegral"];
            NSString *rtnCode = [responseData objectForKey:@"rtnCode"];
            
            if ([rtnCode isEqualToString:@"0"]) {
                [mAppUtils showHint:@"今天已经签到过了!"];
                return ;
            }
            self.signinnum = [[responseData objectForKey:@"bean"] objectForKey:@"continuousSign"];
            SigninbubbleButton *signbubble = [[SigninbubbleButton alloc]initWithframe:self.signButton.frame andSigninNum:signinnum];
            [self.signButton.superview addSubview:signbubble];
            [self.signButton setTitle:[NSString stringWithFormat:@"已连续签到%i天",[self.signinnum intValue]+1] forState:UIControlStateNormal];
            [self refreshtheintegral];
            [self.signButton removeTarget:self action:@selector(signAction) forControlEvents:UIControlEventTouchUpInside];
            [self refreshtheintegral];
            LocalUserInfoModelClass *userInfo = [AppCache getUserInfo];
            userInfo.todaySigned = @"1";
            mAppDelegate.loginUser = userInfo;
            [AppCache cacheObject:userInfo forKey:HLocalUserInfo];
           
            
        }else{
            [mAppUtils showHint:@"今天已经签到过了!"];
        }
    }];
}

- (IBAction)showRuleVC:(id)sender {
    AwardRulesViewController *vc  = [AwardRulesViewController new];
    vc.navTitle = @"规则说明";
    vc.desc = @"《宠物爱这个》注册用户，每天签到可获得积分奖励。积分可用于兑换实物奖励，相当于真金白银。连续签到，第一天+1，第二天+2，第三天+3，以此类推；以周为单位，满7天系统重置，重新循环第一天+1，第二天+2，第三天+3……连续不间断签到满30天，将有惊喜奖励。\n\n奖品发放\n\n1、签到获得的积分可用于兑换实物奖励，如实填写收货信息后；我们的客服人员会电话联系核实后，给您发放。\n\n2、虚拟类奖品所有电子码使用期限及兑换规则请参照合作方对应活动使用规范\n\n3、请保证您提供的领奖信息清晰准确，如果因领奖信息有误、不完整或不清晰而导致奖品未能及时收到而导致奖品不能正常发放的情况，视为您放弃；\n\n4、本活动快递奖品的收货地址仅限中国大陆地区；\n\n5、活动奖品以您收到的实物为准。\n\n 免责说明\n\n签到、抽奖秉着公平、公正、公开、真实的原则，我司声明以下免责条款，参加活动前请用户仔细阅读条款，所有活动、奖励与苹果公司无关 。\n\n本次活动最终解释权归《宠物爱这个》所有";
    [self.navigationController pushViewController:vc animated:YES];
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
            NSString *careSelectFlag = [mUserDefaults objectForKey:kCareSelectPushSwitch];
            if ([careSelectFlag intValue] == 1) {
                [switchBtn setOn:YES];
            }else{
                [switchBtn setOn:NO];
            }
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
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(128, 17, 100, 14)];
            [label setTextColor:[UIColor lightGrayColor]];
            [label setFont:[UIFont systemFontOfSize:12]];

            [label setText:@"(每日10点提醒)"];
            [cell.contentView addSubview:label];
            
            NSString *switchBtnFlag = [mUserDefaults objectForKey:kSignAlarmSwitch];
            if ([switchBtnFlag intValue] == 1) {
                [switchBtn setOn:YES];
            }else{
                [switchBtn setOn:NO];
            }

            
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
            UILabel *imageCacheLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 15)];
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
    UISwitch *switchBtn = sender;
    if (switchBtn.isOn) {
        [mUserDefaults setObject:@"1" forKey:kCareSelectPushSwitch];
        [APService setTags:[NSSet setWithObject:@"m01"] alias:@"" callbackSelector:nil object:nil];
    }else{
        [mUserDefaults setObject:@"0" forKey:kCareSelectPushSwitch];
        [APService setTags:[NSSet set] alias:@"" callbackSelector:nil object:nil];
    }
    [mUserDefaults synchronize];
    
}

- (void) signSwitchAction:(id)sender{
    UISwitch *switchBtn = sender;
    if (![AppCache getUserInfo]) {
        [self showLoginVC];
        [switchBtn setOn:!switchBtn.isOn];
        return;
    }
    if (switchBtn.isOn) {
        [mUserDefaults setObject:@"1" forKey:kSignAlarmSwitch];
        [self scheduleSignAlarm];
    }else{
        [mUserDefaults setObject:@"0" forKey:kSignAlarmSwitch];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}
- (void) scheduleSignAlarm{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
    NSDate* nowDate = [NSDate date];
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)fromDate:nowDate];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate* today = [cal dateByAddingComponents:components toDate:nowDate options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:10];
    [components setMinute:0];
    [components setSecond:0];
    NSDate* fireDate = [cal dateByAddingComponents:components toDate:today options:0];
    if ([fireDate compare:nowDate] == NSOrderedAscending) {
        [components setHour:10+24];
        [components setMinute:0];
        [components setSecond:0];
        fireDate = [cal dateByAddingComponents:components toDate:today options:0];
    }
    NSLog(@"%@",fireDate);
    localNotification.fireDate = fireDate;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    NSString *contentStr = @"亲，签到打卡时间到了，快去赚取积分吧";
    localNotification.alertBody = contentStr;
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:contentStr,@"content", nil];
    localNotification.userInfo = infoDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
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
        {
            
        }
            break;
        case 1:
        {
            PushSettingViewController *vc = [PushSettingViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
        {
            if (![AppCache getUserInfo]) {
                [self showLoginVC];
                return;
            }
            
            UserSettingVC *vc = [UserSettingVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            if (![AppCache getUserInfo]) {
                [self showLoginVC];
                return;
            }
            AdviceViewController *vc = [AdviceViewController new];

            [self.navigationController pushViewController:vc animated:YES];
        }
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
#pragma mark - 定时器刷新最新消息
- (void)refreshremind
{
    NSDictionary *parameter = @{@"uid": @"getUserNewMsgCommentNum"};
    [APIOperation GET:@"common.action"
           parameters:parameter
         onCompletion:^(id responseData, NSError *error) {
             if (responseData) {
                 
                 NSString *newMsgNum = [[responseData objectForKey:@"bean"]objectForKey:@"newMsgNum"];
                 if ([newMsgNum intValue]> 0) {
                         if (!dotImage) {
                             dotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redDotIcon"]];
                     
                             dotImage.backgroundColor = [UIColor clearColor];
                             CGRect tabFrame = self.tabBarController.tabBar.frame;
                     
                             CGFloat x = ceilf(0.86 * tabFrame.size.width);
                     
                             CGFloat y = ceilf(0.2 * tabFrame.size.height);
                             dotImage.frame = CGRectMake(x, y, 6, 6);
                         }
                          [self.tabBarController.tabBar addSubview:dotImage];
                     self.NewMsgFlag = YES;
                     
                 }else {
                     [dotImage removeFromSuperview];
                     self.NewMsgFlag = NO;
                 }
             }
             
         }];
}
- (void)refreshremindWithTimer
{
    // 利用定时器获得用户的未读数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(getMsgWithTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)getMsgWithTimer
{

    
    if (self.NewMsgFlag == YES) {
        return;
    }
    [self refreshremind];
}
#pragma mark - 通知中心

- (void)refreshtheintegral{
    
    NSDictionary *parameter = @{@"uid": @"getLoginInfo"};
    [APIOperation GET:@"getCoreSv.action"
           parameters:parameter
         onCompletion:^(id responseData, NSError *error) {
             if (responseData) {
                LocalUserInfoModelClass *userInfo = [AppCache getUserInfo];
                 NSDictionary *userdic = [responseData objectForKey:@"bean"];
                 if (userdic.count>0) {
                     NSString *realtimeintegral = userdic[@"userIntegral"];
                     
                     if (realtimeintegral) {
                         _integralstr = [[NSString alloc]initWithString:realtimeintegral];
                     }
                     
                     [self loadingIntegralandrankWithData:userInfo];
                 }
                
                 
             }else {
                 
             }
         }];
    
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
