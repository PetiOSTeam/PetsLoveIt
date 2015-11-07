//
//  AppUtils.h
//  TeamWork
//
//  Created by kongjun on 14-7-10.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LocalUserInfoModelClass;
@class TaskMapClass;
@class TWFriendInfo;
@class TWGroupInfo;
@interface AppUtils : NSObject <UIAlertViewDelegate>

@property (nonatomic, strong) NSString *updateURL;
+ (id)sharedAppUtilsInstance;

- (void)setServerUDID:(NSString *)udid;
- (NSString *)getServerUDID;
- (NSString*) uuidString;
- (NSString *)getResolution;

//将图片压缩到合适的大小（最大尺寸1M）
- (NSData *)compressImageToProperSize:(UIImage *)image;

//按照比例缩放个人主页的封面的image
- (UIImage *)scaleHomePageCoverImage:(UIImage *)image;

- (void)showHint:(NSString *)hint;

-(BOOL)hasConnectivity;

-(void)sendSocketLocalNotification:(NSString *)alertBody;

- (NSString *)stringWithUUID;


//注销账户后的操作
-(void)appLogoutAction;

- (NSString *)urlEncodedString:(NSData *)src;

- (NSString *)calculateDefaultDESKEY;
- (NSString *)calculateDefaultDESIV;




- (NSString*)getDeviceType;
//获取mac地址
- (NSString*)getMacAddress;
// 屏幕分辨率,根据isWidth判断是返回宽还是高
- (NSString *)getResolution:(BOOL)isWidth;


@end
