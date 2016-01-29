//
//  PetWebViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/16.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "PetWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "GoodsModel.h"

@interface PetWebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>

@end

@implementation PetWebViewController{
    NJKWebViewProgressView *_webViewProgressView;
    NJKWebViewProgress *_webViewProgress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareViewAndData];
}
- (void)prepareViewAndData{
    self.title = @"直达链接";
    
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height ,
                                 navBounds.size.width,
                                 2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    
    [self.view addSubview:_webViewProgressView];

    if (self.htmlUrl) {
        _webViewProgressView.top=0;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlUrl]]];
    }
    if (self.isProduct) {
        _webViewProgressView.top=64;
        [self showNaviBarView];
        self.navBarTitleLabel.text = @"直达链接";
        self.webView.top = 64;
        self.webView.height = mScreenHeight - 64;
        if (self.proId) {
            [self getProductDetailById:self.proId];
        }

    }else{
       self.webView.height = mScreenHeight - 64;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleBordered target:self action:@selector(clickedLeftBarButtonItemAction)];
        self.navigationItem.leftBarButtonItem.title = @"取消";
    }
    
    
    
}

- (void) getProductDetailById:(NSString *)proId{
    NSDictionary *params = @{
                             @"uid":@"getProductByNodeId",
                             @"prodId":proId
                             };
    [APIOperation GET:@"getCoreSv.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        //[self hideLoadingView];
        if (!error) {
           GoodsModel *goodsModel = [[GoodsModel alloc] initWithDictionary:[responseData objectForKey:@"data"]] ;
            self.htmlUrl = goodsModel.goUrl;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlUrl]]];
        }else{
            
        }
    }];
}

-(void)clickedLeftBarButtonItemAction{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
    //self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
