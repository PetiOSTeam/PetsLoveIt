//
//  CommonViewController.m
//  TeamWork
//
//  Created by kongjun on 14-6-16.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()<UIAlertViewDelegate>

@property (nonatomic, copy) TWBarButtonItemActionBlock barbuttonItemAction;
@property (nonatomic, copy) TWBarButtonItemActionBlock barbuttonItemFirstAction;
@property (nonatomic, copy) TWBarButtonItemActionBlock barbuttonItemSecondAction;
@property (nonatomic, copy) TWBarButtonItemActionBlock barbuttonItemThirdAction;

@end

@implementation CommonViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)clickedBarButtonItemAction
{
    if (self.barbuttonItemAction) {
        self.barbuttonItemAction();
    }
}

- (void)clickedBarButtonItemFirstAction
{
    if (self.barbuttonItemFirstAction) {
        self.barbuttonItemFirstAction();
    }
}
- (void)clickedBarButtonItemSecondAction
{
    if (self.barbuttonItemSecondAction) {
        self.barbuttonItemSecondAction();
    }
}

- (void)clickedBarButtonItemThirdAction
{
    if (self.barbuttonItemThirdAction) {
        self.barbuttonItemThirdAction();
    }
}

#pragma mark - Public Method
- (void)configureBarbuttonItemStyle:(TWBarbuttonItemStyle)style action:(TWBarButtonItemActionBlock)action
{
    //clear button items
    [self.navigationItem setRightBarButtonItems:nil];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, mNavBarHeight, mNavBarHeight)];
    [button setTitleColor:kNaviTitleColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickedBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    switch (style) {
        case TWBarButtonItemStylePublish:{
            [button setImage:nil forState:UIControlStateNormal];
            [button setTitle:@"发表" forState:UIControlStateNormal];
            //[button.titleLabel setFont:[UIFont systemFontOfSize:13]];
            break;
        }
        case TWBarButtonItemStyleSubmit:{
            [button setImage:nil forState:UIControlStateNormal];
            [button setTitle:@"提交" forState:UIControlStateNormal];
            break;
        }
        case TWBarbuttonItemStyleShare:{
            [button setImage:[UIImage imageNamed:@"Image_share"] forState:UIControlStateNormal];
            [button setTitle:@"分享" forState:UIControlStateNormal];
            [button setWidth:60];
            break;
        }
        case TWBarbuttonItemStyleSendMsg:{
            [button setImage:nil forState:UIControlStateNormal];
            [button setTitle:@"发送" forState:UIControlStateNormal];
            break;
        }
        case TWBarButtonItemStyleRecommendUser:{
            [button setTitle:@"圈友" forState:UIControlStateNormal];
            break;
        }
        case TWBarbuttonItemStyleSearchUser:{
            [button setTitle:@"查找圈友" forState:UIControlStateNormal];
            button.width = 60;
            button.height = 25;
            [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
            button.layer.borderColor = kLayerBorderColor.CGColor;
            button.layer.borderWidth = kLayerBorderWidth;
            button.layer.cornerRadius = 5;
            break;
        }
        case TWBarbuttonItemStyleAllRead:{
            [button setTitle:@"全部已读" forState:UIControlStateNormal];
            button.width = 60;
            button.height = 25;
            [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
            button.layer.borderColor = kLayerBorderColor.CGColor;
            button.layer.borderWidth = kLayerBorderWidth;
            button.layer.cornerRadius = 5;

            break;
        }
        case TWBarbuttonItemStyleNone: {
            self.navigationItem.rightBarButtonItem = nil;
            break;
        }
        case TWBarbuttonItemStyleSearch:{
            [button setTitle:@"🔍" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    self.barbuttonItemAction = action;
}

- (void)configureBarbuttonItemStyle:(TWBarbuttonItemStyle)style action1:(TWBarButtonItemActionBlock)action1 action2:(TWBarButtonItemActionBlock)action2{
    
    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(0, 0, 30, mNavBarHeight)];
    [button1 addTarget:self action:@selector(clickedBarButtonItemFirstAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    
    UIButton* button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(0, 0, 30, mNavBarHeight)];
    [button2 addTarget:self action:@selector(clickedBarButtonItemSecondAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:buttonItem2,buttonItem1,nil] ];
    
    switch (style) {
        
        case TWBarbuttonItemStyleNone:
            [self.navigationItem setRightBarButtonItems:nil];
            break;
        default:
            break;
    }
    self.barbuttonItemFirstAction = action1;
    self.barbuttonItemSecondAction = action2;
}

- (void)configureBarbuttonItemStyle:(TWBarbuttonItemStyle)style action1:(TWBarButtonItemActionBlock)action1 action2:(TWBarButtonItemActionBlock)action2 action3:(TWBarButtonItemActionBlock)action3{
    
    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(0, 0, 30, mNavBarHeight)];
    [button1 addTarget:self action:@selector(clickedBarButtonItemFirstAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    
    UIButton* button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(0, 0, 30, mNavBarHeight)];
    [button2 addTarget:self action:@selector(clickedBarButtonItemSecondAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    UIButton* button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setFrame:CGRectMake(0, 0, 30, mNavBarHeight)];
    [button3 addTarget:self action:@selector(clickedBarButtonItemThirdAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem3 = [[UIBarButtonItem alloc] initWithCustomView:button3];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:buttonItem3,buttonItem2,buttonItem1,nil] ];
    switch (style) {
    
        case TWBarbuttonItemStyleNone:
            [self.navigationItem setRightBarButtonItems:nil];
            break;
        default:
            break;
    }
    self.barbuttonItemFirstAction = action1;
    self.barbuttonItemSecondAction = action2;
    self.barbuttonItemThirdAction = action3;
}

- (void)setupBackgroundImage:(UIImage*)backgroundImage
{
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)pushNewViewController:(UIViewController*)newViewController
{
    [self.navigationController pushViewController:newViewController animated:YES];
}

- (void)viewDidEnterCurrentView
{
   
    
}
- (void)viewHeightThatFits:(CGFloat)height
{
}

- (void)TWViewWillAppear:(BOOL)animated
{
}

- (void)TWViewWillDisappear:(BOOL)animated
{
}

- (void)TWViewDidAppear:(BOOL)animated
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [SVIndicator dismiss];
}

- (void)backButtonClicked:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [mNotificationCenter removeObserver:self];
    NSLog(@"dealloc %@",NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
