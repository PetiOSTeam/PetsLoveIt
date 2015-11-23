//
//  AppCache.m
//  iOSAppFramework
//
//  Created by kongjun on 14-5-22.
//  Copyright (c) 2014年 junfrosttong. All rights reserved.
//

#import "AppCache.h"

#define kCommonStaleSeconds 10
#define kMenuStaleSeconds 10
#define kTaskItemsStaleSeconds 10



@interface AppCache (/*Private Methods*/)
+(NSString*) cacheDirectory;
+(NSString*) appVersion;
@end

@implementation AppCache

static NSMutableDictionary *memoryCache;
static NSMutableArray *recentlyAccessedKeys;
static int kCacheMemoryLimit;




//服务器端返回的UDID
+ (void)setServerUDID:(NSString *)udid
{
    [mAppUtils setServerUDID:udid];
}
+ (NSString *)getServerUDID
{
    NSString *serverUdid = [mAppUtils getServerUDID];
    return serverUdid==nil?@"":serverUdid;
}
//获取搜索stock的历史纪录
+ (NSMutableArray *)getSearchStockHistoryArray{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:@"SearchStockHistoryArray.archive"]];
}
+(void) cacheSearchStockHistoryItems:(NSArray*) items{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:items] toFile:@"SearchStockHistoryArray.archive"];
}

//获取搜索用户的历史纪录
+ (NSMutableArray *)getSearchUserHistoryArray{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:@"SearchUserHistoryArray.archive"]];
}
+(void) cacheSearchUserHistoryItems:(NSArray*) items{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:items] toFile:@"SearchUserHistoryArray.archive"];
}

//获取市场列表
+ (NSMutableArray *)getMarketArray{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:@"MarketArray.archive"]];
}
+(void) cacheMarketItems:(NSArray*) items{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:items] toFile:@"MarketArray.archive"];
}


//RSA的公钥
+ (void)setRSAPublicKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:RSA_PUBLICK_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getRSAPublicKey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:RSA_PUBLICK_KEY];
}

+(void) setAppDeviceToken:(NSString *) deviceToken {
    [mUserDefaults setValue:deviceToken forKey:kAppDeviceToken];
    [mUserDefaults synchronize];
}
+(NSString *) getAppDeviceToken{
    NSString *deviceToken = [mUserDefaults stringForKey:kAppDeviceToken];
    return deviceToken;
}

#pragma mark - 获取LocalCache存下来的userInfo
+(LocalUserInfoModelClass *) getUserInfo{
    NSData *userInfoData =  [mUserDefaults objectForKey:HLocalUserInfo];
    if (!userInfoData&&mAppDelegate.loginUser) {
         userInfoData = [NSKeyedArchiver archivedDataWithRootObject:mAppDelegate.loginUser];
        [mUserDefaults setObject:userInfoData forKey:HLocalUserInfo];
        [mUserDefaults synchronize];
    }
    LocalUserInfoModelClass *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userInfoData];
    return userInfo;
}
////将Object 缓存到userDefault中
+(void) cacheObject:(id) object forKey:(NSString *)key {
    
    if ([key isEqualToString:HLocalUserInfo]) {
        LocalUserInfoModelClass *kNewlocalUserInfo = (LocalUserInfoModelClass *)object;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:kNewlocalUserInfo];
        //使用NSData保存localUserInfo
        [mUserDefaults setObject:data forKey:key];
        [mUserDefaults synchronize];
    }else{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
        //使用NSData保存localUserInfo
        [mUserDefaults setObject:data forKey:key];
        [mUserDefaults synchronize];
    }
    
}

+(NSString *) getMobile {
    LocalUserInfoModelClass *userInfo = [self getUserInfo];
    NSString *mobile = [NSString stringWithFormat:@"%@",userInfo.mobile];
    if (!mobile) {
        mobile = @"";
    }
    return mobile;
}

+(NSString *) getUserId {
    LocalUserInfoModelClass *userInfo = [self getUserInfo];
    NSString *userId = [NSString stringWithFormat:@"%@",userInfo.uId];
    if (!userId) {
        userId = @"";
    }
    return userId;
}
+(NSString *) getToken{
    LocalUserInfoModelClass *userInfo = [self getUserInfo];
//    NSString *token = [NSString stringWithFormat:@"%@",userInfo.token];
//    if (!userInfo.token) {
//        token = @"";
//    }
//    return token;
    return @"";
}



+(NSString *) getUserAvatar {
    LocalUserInfoModelClass *userInfo = [self getUserInfo];
    NSString *useravatar = [NSString stringWithFormat:@"%@",userInfo.user_icon!=nil?userInfo.user_icon:@""];
    return useravatar;
}

+(NSString *) getUserName {
    LocalUserInfoModelClass *userInfo = [self getUserInfo];
    NSString *username = [NSString stringWithFormat:@"%@",userInfo.nickName];
    return username;
}




+(void) initialize
{
    NSString *cacheDirectory = [AppCache cacheDirectory];
    if(![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    //创建自选股票文件夹
    NSString *UserCollectStockCacheDirectory = [AppCache UserCollectStockCacheDirectory];
    if(![[NSFileManager defaultManager] fileExistsAtPath:UserCollectStockCacheDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:UserCollectStockCacheDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    double lastSavedCacheVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CACHE_VERSION"];
    double currentAppVersion = [[AppCache appVersion] doubleValue];
    
    if( lastSavedCacheVersion == 0.0f || lastSavedCacheVersion < currentAppVersion)
    {
        // assigning current version to preference
        [AppCache clearCache];
        
        [[NSUserDefaults standardUserDefaults] setDouble:currentAppVersion forKey:@"CACHE_VERSION"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    memoryCache = [[NSMutableDictionary alloc] init];
    recentlyAccessedKeys = [[NSMutableArray alloc] init];
    
    // you can set this based on the running device and expected cache size
    kCacheMemoryLimit = 10;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
}

+(void) dealloc
{
    memoryCache = nil;
    
    recentlyAccessedKeys = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    
}

+(void) saveMemoryCacheToDisk:(NSNotification *)notification
{
    for(NSString *filename in [memoryCache allKeys])
    {
        NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:filename];
        NSData *cacheData = [memoryCache objectForKey:filename];
        [cacheData writeToFile:archivePath atomically:YES];
    }
    
    [memoryCache removeAllObjects];
}

+(void) clearCache
{
    NSArray *cachedItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[AppCache cacheDirectory]
                                                                               error:nil];
    //清除archieve文件缓存
    for(NSString *path in cachedItems){
        NSString *absolutePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:path];
        [[NSFileManager defaultManager] removeItemAtPath:absolutePath error:nil];
    }
    
    //清除内存缓存
    [memoryCache removeAllObjects];
    [[YYImageCache sharedCache].memoryCache removeAllObjects];
    [[YYImageCache sharedCache].diskCache removeAllObjectsWithBlock:nil];
    
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearMemory];
//    //清除userDefault下的cache
    [mUserDefaults removeObjectForKey:HLocalUserInfo];//个人登录信息
    [mUserDefaults synchronize];
    mAppDelegate.loginUser = nil;

}

+(NSString*) appVersion
{
	CFStringRef versStr = (CFStringRef)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey);
	NSString *version = [NSString stringWithUTF8String:CFStringGetCStringPtr(versStr,kCFStringEncodingMacRoman)];
	
	return version;
}

+(NSString*) cacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
	return [cachesDirectory stringByAppendingPathComponent:@"AppCache"];
}

+(NSString *) UserCollectStockCacheDirectory
{
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [AppCache cacheDirectory];
	return [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"UserCollectStock_%@",[AppCache getUserId]]];
}

#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here

+(void) cacheData:(NSData*) data toFile:(NSString*) fileName
{
   
    
    [memoryCache setObject:data forKey:fileName];
    if([recentlyAccessedKeys containsObject:fileName])
    {
        [recentlyAccessedKeys removeObject:fileName];
    }
    
    [recentlyAccessedKeys insertObject:fileName atIndex:0];
    
    if([recentlyAccessedKeys count] > kCacheMemoryLimit)
    {
        NSString *leastRecentlyUsedDataFilename = [recentlyAccessedKeys lastObject];
        //直接将对象存入本地
        NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:fileName];
        [data writeToFile:archivePath atomically:YES];
        
        [recentlyAccessedKeys removeLastObject];
        [memoryCache removeObjectForKey:leastRecentlyUsedDataFilename];
    }
    
}

+(void) cacheUserCollectStock:(NSData *) data toFile:(NSString *) fileName
{
    
    NSString *archivePath = [[AppCache UserCollectStockCacheDirectory] stringByAppendingPathComponent:fileName];
    [data writeToFile:archivePath atomically:YES];
}

+(NSData*) dataForFile:(NSString*) fileName
{
    NSData *data = [memoryCache objectForKey:fileName];
    if(data) return data; // data is present in memory cache
    
	NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:fileName];
    data = [NSData dataWithContentsOfFile:archivePath];
    
    if(data)
        [self cacheData:data toFile:fileName]; // put the recently accessed data to memory cache
    
    return data;
}

+(NSData*) dataForLocalFile:(NSString*) fileName
{
    
    
	NSString *archivePath = [[AppCache UserCollectStockCacheDirectory] stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:archivePath];
    
    return data;
}




+(void) cacheMenuItems:(NSArray*) menuItems
{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:menuItems]
             toFile:@"MenuItems.archive"];
}

+(NSMutableArray*) getCachedMenuItems
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:@"MenuItems.archive"]];
}

+(BOOL) isMenuItemsStale
{
    // if it is in memory cache, it is not stale
    if([recentlyAccessedKeys containsObject:@"MenuItems.archive"])
        return NO;
    
	NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:@"MenuItems.archive"];
    
    NSTimeInterval stalenessLevel = [[[[NSFileManager defaultManager] attributesOfItemAtPath:archivePath error:nil] fileModificationDate] timeIntervalSinceNow];
    
    return stalenessLevel > kMenuStaleSeconds;
}
@end
