//
//  AppCache.h
//  iOSAppFramework
//
//  Created by kongjun on 14-5-22.
//  Copyright (c) 2014年 junfrosttong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LocalUserInfoModelClass;
@class StockModel;
@interface AppCache : NSObject

+(void) clearCache;

+(NSString *) UserCollectStockCacheDirectory;

+(NSMutableArray*) getCachedUserCollectStockItems;
+(void) cacheUserCollectStockItems:(NSArray*) stockItems;

+(void) setStockUserCollect:(StockModel *)stock collect:(BOOL)isStockCollected;

//判断该股票是否为自选股票
+(BOOL) isStockUserCollect:(NSString *)stockCode  marketId:(NSString *)marketId;

//获取本地缓存的userInfo
+(LocalUserInfoModelClass *) getUserInfo;
//将Object 缓存到userDefault中
+(void) cacheObject:(id)object forKey:(NSString *)key;
+(NSString *) getUserId;
+(NSString *) getMobile;
+(NSString *) getToken;
+(NSString *) getUserAvatar;
+(NSString *) getUserName;

+ (NSArray *)getUserTags;

+(NSString *) getUserPoint;

+ (void)setRSAPublicKey:(NSString *)key;
+ (NSString *)getRSAPublicKey;

+ (void)setServerUDID:(NSString *)udid;
+ (NSString *)getServerUDID;


+(void) setAppDeviceToken:(NSString *) deviceToken;
+(NSString *) getAppDeviceToken;

+ (NSMutableArray *)getSearchUserHistoryArray;
+(void) cacheSearchUserHistoryItems:(NSArray*) items;

+ (NSMutableArray *)getMarketArray;
+(void) cacheMarketItems:(NSArray*) items;

+ (NSMutableArray *)getSearchStockHistoryArray;
+(void) cacheSearchStockHistoryItems:(NSArray*) items;

@end
