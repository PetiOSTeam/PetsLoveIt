//
//  PetWebViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/16.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "PetWebViewController.h"

@interface PetWebViewController ()

@end

@implementation PetWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareViewAndData];
}
- (void)prepareViewAndData{
    self.title = @"特快直达";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.kaola.com/product/12639.html?tag=280df79997466a23721b62ba2d51c0b3&__da_hQ7qPI_hJPsVS"]]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleBordered target:self action:@selector(clickedLeftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem.title = @"取消";
}

-(void)clickedLeftBarButtonItemAction{
    [self dismissViewControllerAnimated:YES completion:^{}];
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
