//
//  PetWebViewController.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/16.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CommonViewController.h"

@interface PetWebViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) NSString *htmlUrl;
@end
