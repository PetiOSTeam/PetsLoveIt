//
//  PetWebViewController.h
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/16.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "CommonViewController.h"

@interface PetWebViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,assign) BOOL isProduct;
@property (strong,nonatomic) NSString *proId;
@property (strong,nonatomic) NSString *htmlUrl;
@end
