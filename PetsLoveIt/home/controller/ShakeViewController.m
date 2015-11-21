//
//  ShakeViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/14.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ShakeViewController.h"

@interface ShakeViewController ()
@property (nonatomic,strong) UIImageView *bgImageView;
@end

@implementation ShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareViewAndData];
}

- (void) prepareViewAndData{
    [self.view addSubview:self.bgImageView];
    [self setupNavbarButtons];
    
}
- (void)setupNavbarButtons
{
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(0, 30, 44, 34);
    [buttonBack setImage:[UIImage imageNamed:@"whiteBackBarButtonIcon"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:buttonBack];
}

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _bgImageView.image = [UIImage imageNamed:@"shakeBgImage"];
    }
    return _bgImageView;
}

- (void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
