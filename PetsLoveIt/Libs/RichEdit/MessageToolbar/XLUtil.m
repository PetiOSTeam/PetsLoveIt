//
//  XLUtil.m
//  XLUtility
//
//  Created by Destiny on 12-10-19.
//  Copyright (c) 2012年 Destiny. All rights reserved.
//

#import "XLUtil.h"
#import "sys/utsname.h"

NSString *deviceString()
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}


void gainFontFamilyNames(void)
{
    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    NSLog(@"[familyNames count]===%lu",(unsigned long)[familyNames count]);
    for(indFamily=0;indFamily<[familyNames count];++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        for(indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"Font name: %@",[fontNames objectAtIndex:indFont]);
        }
    }
}

void saveMessageToLocal(NSString *message, NSString *key)
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:message forKey:key];
    [defaults synchronize];
}

NSString* loadMessageFromLocal(NSString *key)
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *salesName = [defaults objectForKey:key];
    return salesName;
}

/**
 * Get path of the file in the document folder.||获得Document里面的一个文件的路径
 */
NSString* filePathAtDocument(NSString *filename)
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [pathArray objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:filename];
    NSLog(@"filePath:%@", filePath);
    return filePath;
}

/**
 * Get path of the file in main bundle || 得到路劲中的文件主要的Bundle
 */
NSString* filePathAtMainBundle(NSString *filename)
{
    NSArray *components = [filename componentsSeparatedByString:@"."];
    //    assert([components count]==2);
    NSString *prefix = [components objectAtIndex:0];
    NSString *suffix = [components objectAtIndex:1];
    
    return [[NSBundle mainBundle] pathForResource:prefix ofType:suffix];
}

/**
 * Get file URL from path 从路径获得文件URL
 */
NSURL* fileURL(NSString *path)
{
    return [[NSURL alloc] initFileURLWithPath:path];
}

/**
 * Check if file is already exist at path 如果文件已经存在检查在路径
 */
bool isFileExistAtPath(NSString *filePath)
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    const bool isExist = [fileManager fileExistsAtPath:filePath];
    
    if (!isExist){
        NSLog(@"%@ not exist!", filePath);
    }
    
    return isExist;
}

# pragma mark - Easy way to read and write plist file 阅读&& 获取plist文件

/**
 * Get array from plist file in main bundle  判断是否存在文件 若存在便取出赋予新的数组
 */
NSArray* arrayFromMainBundle(NSString *filename)
{
    NSArray *arrayForReturn = nil;
    NSString *path = filePathAtMainBundle(filename);
    
    if (isFileExistAtPath(path)){
        arrayForReturn = [NSArray arrayWithContentsOfFile:path];
    }
    return arrayForReturn;
}

/**
 * Get dictionary from plist file in main bundle判断是否存在文件 若存在便取出赋予新的字典 用于取值
 */
NSDictionary* dictionaryAtMainBundle(NSString *filename)
{
    NSDictionary *dictionaryForReturn = nil;
    NSString *path = filePathAtMainBundle(filename);
    
    if (isFileExistAtPath(path)){
        dictionaryForReturn = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return dictionaryForReturn;
}

/*plist中取数组*/
NSArray* loadArrayFromDocument(NSString *filename)
{
    NSString *path = filePathAtDocument(filename);
    //    NSLog(@"path:%@", path);
    return [NSArray arrayWithContentsOfFile:path];
}

/*plist中取字典*/
NSDictionary* loadDictionaryFromDocument(NSString *filename)
{
    NSString *path = filePathAtDocument(filename);
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

UIImage*  getImageFromDocument(NSString *imageName)
{
    NSString *path = filePathAtDocument(imageName);
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

//本地是否有相关文件 不限于图片
BOOL isDocumentHaveImage(NSString *filename) {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths        objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filepath]) {
        return YES;
    }
    return NO;
}

/*储存一个数组到本地*/
BOOL saveArrayToDocument(NSString *filename, NSArray *array)
{
    NSString *path = filePathAtDocument(filename);
    //    NSLog(@"path:%@", path);
    return [array writeToFile:path atomically:YES];
}

/*储存一个字典到本地*/
BOOL saveDictionaryToDocument(NSString *filename, NSDictionary *dictionary)
{
    NSString *path = filePathAtDocument(filename);
    return [dictionary writeToFile:path atomically:YES];
}

BOOL saveDataToDocument(NSString *filename, NSData *data)
{
    NSString *path = filePathAtDocument(filename);
    return [data writeToFile:path atomically:YES];
}

/*储存一个图片到本地沙盒*/
void saveImageToDocument(UIImage *image, NSString *key)
{
    [UIImagePNGRepresentation(image) writeToFile:filePathAtDocument(key) atomically:YES];
}

#pragma mark - encoding 将字符串编码
NSString* encodeURL(NSString *string)
{
    //	NSString *newString = [NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))) autorelease];
    //	if (newString) {
    //		return newString;
    //	}
    return @"";
}

/*将data转换成UTF8编码*/
NSString* stringUsingEncodingUTF8(NSData *data)
{
    return [[NSString alloc] initWithData:data	encoding:NSUTF8StringEncoding];
}

NSString* stringUsingEncoding(NSData *data, NSStringEncoding encoding)
{
    return [[NSString alloc] initWithData:data	encoding:encoding];
}

/*将一个字符串转换成data编码*/
NSData* dataUsingEncodingUTF8(NSString *string)
{
    return dataUsingEncoding(string, NSUTF8StringEncoding);
}

NSData* dataUsingEncoding(NSString *string, NSStringEncoding encoding)
{
    return [string dataUsingEncoding:encoding];
}

#pragma mark - device
/*查看设备配置*/
void deviceInfo(void)
{
    NSLog(@"Device Name: %@", [UIDevice currentDevice].name);
    NSLog(@"Device Model: %@", [UIDevice currentDevice].model);
    NSLog(@"System Name: %@", [UIDevice currentDevice].systemName);
    NSLog(@"System Version: %@", [UIDevice currentDevice].systemVersion);
    NSLog(@"Retina Display: %@", isRetinaDisplay()?@"YES":@"NO");
}


NSString* deviceName(void)
{
    return [UIDevice currentDevice].name;
}

NSString* deviceModel(void)
{
    return [UIDevice currentDevice].model;
}

NSString* deviceSystemName(void)
{
    return [UIDevice currentDevice].systemName;
}

NSString* deviceSystemVersion(void)
{
    return [UIDevice currentDevice].systemVersion;
}

bool isRetinaDisplay(void)
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00);
}

#pragma mark - 检查数据的格式（邮箱 手机...）
/*邮箱格式*/
bool isEmailFormat(NSString *email)
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码格式*/
bool isMobileFormat(NSString *mobile)
{
    NSString *mobileRegex = @"[0-9]{6,13}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [emailTest evaluateWithObject:mobile];
}

/*账号格式*/
bool isAccountFormat(NSString *account)
{
    NSString *accountRegex = @"[A-Z0-9a-z_ ]{3,30}";
    NSPredicate *accountTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", accountRegex];
    return [accountTest evaluateWithObject:account];
}

/*密码格式*/
bool isPasswordFormat(NSString *password)
{
    NSString *formatRegex = @"[A-Z0-9a-z]{6,20}";
    NSPredicate *formatTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", formatRegex];
    return [formatTest evaluateWithObject:password];
}

# pragma mark - open URL
/*打开一个URL*/
void openURL(NSURL *url)
{
    [[UIApplication sharedApplication] openURL:url];
}

/*进入itunes指定app下载页面*/
void openRateURL(NSString *appId)
{
    NSString* url = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", appId];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:url]];
}

void openTelURL(NSString *tel)
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", tel]];
    [[UIApplication sharedApplication] openURL:url];
}

/*警告提醒框*/
void showAlertBox(NSString *title, NSString *message)
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil];
    [alertView show];
}

/*当前时间*/
NSString* currTime(void)
{
    NSDate *now = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:now];
    NSInteger y = [dd year];
    NSInteger m = [dd month];
    NSInteger d = [dd day];
    //    NSString *weekday = [NSString  weekday];
    //    int week = [dd weekday];
    
    NSInteger hour = [dd hour];
    NSInteger minute = [dd minute];
    NSInteger second = [dd second];
    
    return [NSString stringWithFormat:@"%ld-%ld-%ld%ld:%ld:%ld", (long)y, (long)m, (long)d, (long)hour, (long)minute, (long)second];
}

#pragma mark - local notification
/*本地通知*/
void localNotification(void)
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;//应用程序右上角的数字=0（消失）
    [[UIApplication sharedApplication] cancelAllLocalNotifications];//取消所有的通知
    //------通知；
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {//判断系统是否支持本地通知
        notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:10];//本次开启立即执行的周期
        notification.repeatInterval=kCFCalendarUnitDay;//循环通知的周期
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=@"Pop up message!";//弹出的提示信息
        notification.applicationIconBadgeNumber=1; //应用程序的右上角小数字
        notification.soundName= UILocalNotificationDefaultSoundName;//本地化通知的声音
        notification.alertAction = NSLocalizedString(@"距離對嗎？？！", nil);  //弹出的提示框按钮
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
    }
}

# pragma mark - NSCoder
/*存档*/
bool archive(id object, NSString *path)
{
    NSData *data;
    data = [NSKeyedArchiver archivedDataWithRootObject:object];
    return [data writeToFile:path atomically:YES];
}

/*输入路径 解压文件*/
id unarchiveObjectFromPath(NSString *path)
{
    NSData *data=[NSData dataWithContentsOfFile:path];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

/*添加一个通知监视*/
void addNotification(id observer, SEL sel, NSString *name, id obj)
{
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:sel
                                                 name:name
                                               object:obj];
}
/*结束通知*/
void removeNotification(id observer, NSString *name, id obj)
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                    name:name
                                                  object:obj];
}


/*判断输入的是否是数字 以及位数来判定大小*/
BOOL isPartialStringValid(NSString *partialString)
{
    //    int count = [partialString intValue];
    //    if (count > 100000) {
    //        alert(@"数值太大请重新输入");
    //        return NO;
    //    }
    
    NSInteger length = [partialString length];
    
    int index = 0;
    for (index = 0; index < length; index++)
    {
        unichar endCharacter = [partialString characterAtIndex:index];
        if (endCharacter >= '0' && endCharacter <= '9')
            continue;
        else
            //            alert(@"请输入0~9的数字！");
            return NO;
    }
    
    return YES;
}

/*判断两个类名是否相同*/
BOOL isSameClass(Class _class, NSString * _str2)
{
    if([_class isSubclassOfClass:NSClassFromString(_str2)])
    {
        return YES;
    }
    else
        return NO;
}

extern void instanceClass(id *_obj, NSString *_controllerName)
{
    *_obj = [[NSClassFromString(_controllerName) alloc] init];
}

/******************************************
 *@Description:四舍五入
 *@Return:返回int
 ******************************************/
int numberWithRounding(float number)
{
    NSString *str_number = [NSString stringWithFormat:@"%f", number];
    NSArray *components = [str_number componentsSeparatedByString:@"."];
    assert(components.count == 2);
    int ingteger = [[components objectAtIndex:0] intValue];
    int decimals = [[[components objectAtIndex:1] substringToIndex:1] intValue];
    if (decimals >= 5) {
        ingteger++;
    }
    return ingteger;
}

NSString* pathInCacheDirectory(NSString *fileName)
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}

bool createDirInCache(NSString *dirName)
{
    NSString *imageDir = pathInCacheDirectory(dirName);
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    bool isCreated = false;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return isCreated;
}

bool deleteDirInCache(NSString *dirName, NSString *fileName)
{
    NSString *imageDir = pathInCacheDirectory(dirName);
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    bool isDeleted = false;
    if ( isDir == YES && existed == YES )
    {
        NSString *path = [NSString stringWithFormat:@"%@/%@", imageDir, fileName];
        BOOL isImage = [fileManager fileExistsAtPath:path isDirectory:&isDir];
        if ( isImage == YES )
        {
            isDeleted = [fileManager removeItemAtPath:path error:nil];
        }
    }
    return isDeleted;
}

bool saveImageToCacheDir(NSString *directoryPath, UIImage *image, NSString *imageName, NSString *imageType)
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    bool isSaved = false;
    if ( isDir == YES && existed == YES )
    {
        if ([[imageType lowercaseString] isEqualToString:@"png"])
        {
            isSaved = [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
        }
        else if ([[imageType lowercaseString] isEqualToString:@"jpg"] || [[imageType lowercaseString] isEqualToString:@"jpeg"])
        {
            isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
        }
        else
        {
            NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", imageType);
        }
    }
    return isSaved;
}

NSData* loadImageData(NSString *directoryPath, NSString *imageName)
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dirExisted = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if ( isDir == YES && dirExisted == YES )
    {
        NSString *imagePath = [directoryPath stringByAppendingString : imageName];
        BOOL fileExisted = [fileManager fileExistsAtPath:imagePath];
        if (!fileExisted) {
            return NULL;
        }
        NSData *imageData = [NSData dataWithContentsOfFile : imagePath];
        return imageData;
    }
    else
    {
        return NULL;
    }
}

void setExtraCellLineHidden(UITableView *tableView)
{
    UIView *view =[ [UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

void handleOpenCellOffsetWithIndexPath(NSIndexPath *indexPath, UITableView *tableView)
{
    CGRect _frame = [tableView rectForRowAtIndexPath:indexPath];
    float maxY = CGRectGetMaxY(_frame);
    float offsetY = maxY - tableView.contentOffset.y;
    if (offsetY > tableView.height) {
        float posY = tableView.contentOffset.y + (offsetY - tableView.height);
        [tableView setContentOffset:CGPointMake(0, posY) animated:YES];
    }
}

float tableViewOffsetFrom(UITableView *tableView, NSIndexPath *indexPath, float keyboardHeight, CGRect superFrame, float buttomBarHeight,float replyHeight)
{
    //当前tableViewCell的Frame
    if (!indexPath) {
        return 0;
    }
    CGRect _frame = [tableView rectForRowAtIndexPath:indexPath];
    NSLog(@"_frame:%@", NSStringFromCGRect(_frame));
    float offsetY = 0;
    NSLog(@"tableView.contentOffset.y:%f", tableView.contentOffset.y);
    //当前cell的frameY轴减去tableView的y轴坐标
    float currentFrameY = _frame.origin.y - tableView.contentOffset.y;
    NSLog(@"currentFrameY:%f", currentFrameY);
    //加上当前cell的高度＝当前cell底部到顶部的距离
    currentFrameY += replyHeight==0?_frame.size.height:replyHeight;
    
    offsetY = superFrame.size.height-(keyboardHeight+currentFrameY);
    offsetY = tableView.contentOffset.y-offsetY ;
//    currentFrameY += (superFrame.size.height - tableView.frame.size.height - buttomBarHeight);
    NSLog(@"superFrame.size.height - tableView.frame.size.height:%f", superFrame.size.height - tableView.frame.size.height);
//    if ((superFrame.size.height - currentFrameY) > keyboardHeight || (superFrame.size.height - currentFrameY) < keyboardHeight) {
//        float offset1 = superFrame.size.height - keyboardHeight;
//        float offset2 = superFrame.size.height - currentFrameY;
//        float sum = offset1 - offset2;
//        offsetY = _frame.origin.y - sum;
//    }
    NSLog(@"offsetY:%f", offsetY);

    return offsetY;
}


