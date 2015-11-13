//
//  MacroDefine.h
//  smartcity
//
//  Created by kongjun on 13-10-21.
//  Copyright (c) 2013年 junfrost. All rights reserved.
//


#import "AppDelegate.h"

/*--------------------------------开发中常用到的宏定义--------------------------------------*/

#define IOS_VERSION_7_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? (YES):(NO))

//系统目录
#define kDocuments  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define kLibrary  [(NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)) firstObject]

#define APPUDID                         [NSString stringWithFormat:@"%@APPUDID",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]

//magical Record short hand
#define MR_SHORTHAND
//图片最大上传大小
#define kMaxImageUploadSize (1024*1024)
#define kMESImageQuality .9f //图片压缩比例
#define kMaxImageSize 1024

#define kBundleId   [[NSBundle mainBundle] bundleIdentifier]
//接口返回的错误消息的key
#define kMessage @"error"

#define RSA_PUBLICK_KEY                 @"RSA_PUBLICK_KEY"
#define kAppDeviceToken         @"AppDeviceToken"


/********************用于更新app版本************************/
#define kAppVersion @"version_teamwork"
#define kAppVersionForceUpdate @"versionForceUpdate_teamwork"
#define kAppDownloadUrl  @"downloadUrl_teamwork"



//----------方法简写-------
#define mAppDelegate        ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define mWindow             [[[UIApplication sharedApplication] windows] lastObject]
#define mKeyWindow          [[UIApplication sharedApplication] keyWindow]
#define mUserDefaults       [NSUserDefaults standardUserDefaults]
#define mNotificationCenter [NSNotificationCenter defaultCenter]
#define mAFHTTPClient       [AFHTTPClientUtil sharedClient]
#define mAFHTTPClientForiOS6OrLower [AFHTTPClientForiOS6OrLower sharedClient]
#define mAppUtils   [AppUtils sharedAppUtilsInstance]
#define mAlertAPIErrorInfo(error)  [mAppUtils showHint:[[error.userInfo objectForKey:ERRORMSG] length]>0 && [[error.userInfo objectForKey:ERRORMSG] length] < 30?[error.userInfo objectForKey:ERRORMSG] :kNetWorkUnReachableDesc]

#define nilOrJSONObjectForKey(JSON_, KEY_) [[JSON_ objectForKey:KEY_] isKindOfClass:[NSNull class]] ? @"" : [JSON_ objectForKey:KEY_]

#define kAlertDuplicatedLoginTag 1001



//转圈自动dimiss的时间
#define kSVDismissDuration  40

//字符常量
#define kUnSyncTaskStatusString @"同步..."
#define kUnSyncTaskStatus @"UnSyncStatus"
#define kNetWorkUnReachableDesc  @"服务出错或者当前网络连接失败"



// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

//颜色转换
#define mRGBColor(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define mRGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//rgb颜色转换（16进制->10进制）
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]


//简单的以AlertView显示提示信息
#define mAlertView(title, msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil]; \
[alert show];

#define ERRORMSG @"errorMsg"
#define ERRORCODE @"errorCode"



//----------页面设计相关-------

#define mNavBarHeight         (self.navigationController.navigationBar.height)
#define mTabBarHeight         (self.tabBarController.tabBar.height)
#define mStatusBarHeight      ([UIApplication sharedApplication].statusBarFrame.size.height)
#define mSlideBarHeight       40.0f
#define mScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight         ([UIScreen mainScreen].bounds.size.height)


//----------设备系统相关---------
#define mRetina   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define mIsiP5    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)
#define mIsPad    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define mIsiphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define mIos7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


// device verson float value
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//设置TableView cell选中时的颜色
#define kTableCellSelectedBGColor [UIColor colorWithRed:235.0/255.0 green:236.0/255.0 blue:238.0/255.0 alpha:1]
//layer border
#define kLayerBorderWidth 0.5f
#define kLayerBorderColor mRGBColor(200, 199, 204)

#define HLocalUserInfo @"HLocalUserInfo"
#define ReloadUserInfoNotify @"ReloadUserInfoNotify"

#define StockObjSortId @"1"     //股票
#define ObjSortId_Three @"3"  //评论｜动态
#define ObjSortId_Two @"2"  //话题
#define ObjSortId_Four @"4" //公告

//默认头像
#define kDefaultAppImage [UIImage imageNamed:@"timeline_image_loading"]
#define kImagePlaceHolder [UIImage imageNamed:@"timeline_image_loading"]
#define kDefaultHeadImage [UIImage imageNamed:@"Image_defaultPerson"]
#define kDefaultPersonAvatar @"Image_defaultPerson"
//字体基本色
#define kDefaultFontColor mRGBToColor(0xd0bc91)
#define kNaviTitleColor mRGBToColor(0x222222)
#define kThemeColor mRGBToColor(0xC4232D) //app使用的主题色（navi的背景）
#define kCellBgColor mRGBToColor(0xffffff)//cell背景色
//app基本色
#define kAppDefaultColor mRGBToColor(0xffffff)//app的页面背景色

#define kLineColor mRGBToColor(0xCECECB)//line背景色

#define mSystemVersion   ([[UIDevice currentDevice] systemVersion])
#define mCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
//用于版本升级的判断
#define mAPPVersionBuildCode      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//app的版本号
#define mAPPVersionNumber          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define mFirstLaunch     mAPPVersionBuildCode     //以系统版本来判断是否是第一次启动，包括升级后启动。
#define mFirstRun        @"firstRun"     //判断是否为第一次运行，升级后启动不算是第一次运行

#define SAFE_RELEASE(_obj) if (_obj != nil) {[_obj release]; _obj = nil;}

//--------调试相关-------

//ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
#define mSafeRelease(object)     [object release];  x=nil
#endif


#if mTargetOSiPhone
//iPhone Device
#endif

#if mTargetOSiPhoneSimulator
//iPhone Simulator
#endif

//获取appDelegate实例。
UIKIT_STATIC_INLINE AppDelegate *appDelegate()
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//网络是否连接

#define mNetworkReachable  [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]


//图片类型
#define kPhotoUtilsImagePath @"ImagePath"
#define kPhotoUtilsThumbImage @"ThumbImage"
#define kPhotoUtilsAsset @"Asset"


//通知notification
#define changeHeadImageNotify  @"changeHeadImageNotify"

//Des 默认key
#define kDefaultDesKey @"FhXXyeXDqxzfvy4jRdg4PbizmwwkCQQD"
#define mDefaultDesKey [mAppUtils calculateDefaultDESKEY]
#define mDefaultDesIV  [mAppUtils calculateDefaultDESIV]

