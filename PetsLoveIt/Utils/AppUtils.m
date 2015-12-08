//
//  AppUtils.m
//  TeamWork
//
//  Created by kongjun on 14-7-10.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import "AppUtils.h"
#import "LocalUserInfoModelClass.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <objc/runtime.h>

#define kAlertViewAppUpdateTag 1001
#define kAlertViewAppForceUpdateTag 1002


@implementation NSString(iVersion)

- (NSComparisonResult)compareVersion:(NSString *)version
{
    return [self compare:version options:NSNumericSearch];
}

- (NSComparisonResult)compareVersionDescending:(NSString *)version
{
    switch ([self compareVersion:version])
    {
        case NSOrderedAscending:
        {
            return NSOrderedDescending;
        }
        case NSOrderedDescending:
        {
            return NSOrderedAscending;
        }
        default:
        {
            return NSOrderedSame;
        }
    }
}

@end




@implementation AppUtils



+ (id)sharedAppUtilsInstance
{
    static AppUtils *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

//服务器端返回的UDID
- (void)setServerUDID:(NSString *)udid
{
    [[NSUserDefaults standardUserDefaults] setObject:udid forKey:APPUDID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getServerUDID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:APPUDID];
}

- (NSString *)getResolution
{
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat widthInPixel = screen.size.width * scaleFactor;
    CGFloat heightInPixel = screen.size.height * scaleFactor;
    return [NSString stringWithFormat:@"%.0fx%.0f", widthInPixel, heightInPixel];
}

//获取硬件uuid
- (NSString*) uuidString
{
    NSString *ident = [[NSUserDefaults standardUserDefaults] objectForKey:@"unique identifier stored for app"];
    if (!ident) {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        ident = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
        CFRelease(uuidStringRef);
        [[NSUserDefaults standardUserDefaults] setObject:ident forKey:@"unique identifier stored for app"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return ident==nil?@"":ident;
}

- (NSData *) compressImageToProperSize:(UIImage *)image{
    @autoreleasepool {
        NSData  *imageData    = UIImageJPEGRepresentation(image, kMESImageQuality);
        double   factor       = 0.8;
        //double   adjustment   = 1.0 / sqrt(2.0);  // or use 0.8 or whatever you want
        double   adjustment   = 1.0 ;  // or use 0.8 or whatever you want
        CGSize   size         = image.size;
        CGSize   currentSize  = size;
        UIImage *currentImage = image;
        
        CGFloat maxImageSize = kMaxImageSize;
        //对长图处理
        if (image.size.height > image.size.width) {//长大于宽
            CGFloat aspectRatio = image.size.height/image.size.width;
            if (aspectRatio > 3 && image.size.height > maxImageSize) {
                maxImageSize = image.size.height * 0.8;
            }
        }else if(image.size.height < image.size.width){//宽大于长
            CGFloat aspectRatio = image.size.width/image.size.height;
            if (aspectRatio > 3 && image.size.width > maxImageSize) {
                maxImageSize = image.size.width * 0.8;
            }
        }
        
        while (currentImage.size.width > maxImageSize || currentImage.size.height > maxImageSize)
        {
            factor      *= adjustment;
            currentSize  = CGSizeMake(roundf(currentSize.width * factor), roundf(currentSize.height * factor));
            currentImage = [currentImage  resizedImage:currentSize interpolationQuality:kMESImageQuality ];
            imageData    = UIImageJPEGRepresentation(currentImage, kMESImageQuality);
        }
        return imageData;
    }
}

- (UIImage *)scaleHomePageCoverImage:(UIImage *)image
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    } else {
        CGSize asize = image.size;
        CGSize oldsize = CGSizeMake(640, 330);
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        
        newimage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect)];
        
//        UIGraphicsBeginImageContext(asize);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
//        [image drawInRect:rect];
//        newimage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
    }
    return newimage;
}

//- (UIImage *) compressImage:(UIImage *)image ToSize:(CGSize) size{
//    @autoreleasepool {
//        UIImage *resultImage = image;
//        resultImage =
//    }
//}

- (void)showHint:(NSString *)hint{
    [SVProgressHUD dismiss];
    [SVIndicator dismiss];
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?80.f:80.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)hideHint{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [MBProgressHUD hideHUDForView:view animated:YES];
}


-(BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}

-(void)sendSocketLocalNotification:(NSString *)alertBody{
    NSDate *now=[NSDate new];
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    notification.fireDate=[now dateByAddingTimeInterval:0];
    notification.timeZone=[NSTimeZone defaultTimeZone];
    notification.alertBody=alertBody;
    //notification.soundName = @"default";
    [notification setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (NSString *)stringWithUUID{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    CFStringRef uuidStrRef = CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    
    NSString *uuidStr = (__bridge NSString *)uuidStrRef;
    CFRelease(uuidStrRef);
    
    return uuidStr;
}




//注销账户后的操作
-(void)appLogoutAction{
    //清除所有缓存
    
    [AppCache clearCache];
}

- (NSString *)urlEncodedString:(NSData *)src
{
    NSString *sourceString = [[NSString alloc] initWithData:src encoding:NSUTF8StringEncoding];
    
    CFStringRef s = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                            (CFStringRef)sourceString,
                                                            NULL,
                                                            CFSTR("!*'();:@&=+$,/?%#[]"),
                                                            kCFStringEncodingUTF8);
    NSString *resultString =[NSString stringWithFormat:@"%@", s];
    CFRelease(s);
    return resultString;
}

- (NSString *)calculateDefaultDESKEY
{
    NSString *serverDESKEY = kDefaultDesKey;
    if ([[AppCache getToken] length]>0) {
        serverDESKEY = [AppCache getToken];
    }
    NSString *updateServerDESKEY = [serverDESKEY stringByAppendingString:serverDESKEY];
    NSString *result = [[[updateServerDESKEY stringFromMD5] substringToIndex:24] lowercaseString];
    return result;
}

- (NSString *)calculateDefaultDESIV
{
    NSString *serverDESKEY = kDefaultDesKey;
    if ([[AppCache getToken] length]>0) {
        serverDESKEY = [AppCache getToken];
    }
    NSString *updateServerDESKEY = [serverDESKEY stringByAppendingString:serverDESKEY];
    NSString *result = [[[updateServerDESKEY stringFromMD5] substringToIndex:8] lowercaseString];
    return result;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == kAlertViewAppUpdateTag) {
        if (buttonIndex == 1) {
            [self openAppUpdateURL:self.updateURL];
        }
    }else if (alertView.tag == kAlertViewAppForceUpdateTag){
        if (buttonIndex == 0) {
            exit(0);
        }
        else if (buttonIndex == 1) {
            [self openAppUpdateURL:self.updateURL];
        }
    }
}

- (void) openAppUpdateURL:(NSString *)updateURL{
    //[mAppUtils appLogoutAction];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL]];
}

//获取设备类型
- (NSString*)getDeviceType
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = (char*)malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    return sDeviceModel;
}

// 屏幕分辨率,根据isWidth判断是返回宽还是高
- (NSString *)getResolution:(BOOL)isWidth
{
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat widthInPixel = screen.size.width * scaleFactor;
    CGFloat heightInPixel = screen.size.height * scaleFactor;
    if (isWidth) {
        return [NSString stringWithFormat:@"%.0f", widthInPixel];
    }else{
        return [NSString stringWithFormat:@"%.0f", heightInPixel];
    }
    
}

//Mac地址
- (NSString*)getMacAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    NSString *macAddress = [outstring uppercaseString];
    if (macAddress == nil || [macAddress isEqualToString:@"020000000000"])
    {
        
        macAddress=@"020000000000";
        //        NSString *uuidString = [mSystemConfigUtil uuidString ];
        //        if (uuidString)
        //        {
        //            macAddress = [uuidString substringWithRange:NSMakeRange(0, 12)];
        //        }
        //        else
        //        {
        //            macAddress = [[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] substringWithRange:NSMakeRange(0, 12)];
        //        }
        
    }
    return macAddress;
}


+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
