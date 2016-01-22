//
//  NetworkAPI.h
//  iOSAppFramework
//
//  Created by kongjun on 14-5-22.
//  Copyright (c) 2014年 junfrosttong. All rights reserved.
//

#ifndef iOSAppFramework_NetworkAPI_h
#define iOSAppFramework_NetworkAPI_h
/** 测试版*/
//#define kBaseURL                    @"http://61.155.210.60:9090/petweb/actions/"
/** 正式版*/
#define kBaseURL                    @"http://www.cwaizg.cn/petweb/actions/"

#define UMENG_APPKEY                @"56484222e0f55ad4db009b90"
#define UMENG_channelId             @"petiOSAppStore"

//JPush
#define JPush_APPKEY                @"8002c114b46259afedc5f914"

static NSString *const iVersioniOSAppStoreURLFormat = @"https://itunes.apple.com/us/app/chong-wu-ai-zhe-ge/id1071760062?mt=8";
static NSString *const appStoreID = @"1071760062";

#define QQSDKAppID @"1104902660"
#define QQAppKey   @"DE1hR1uJxDpFAQ9c"

#define WXAppId    @"wxf89553206e1e0280"
#define WXAppSecret @"7da19cc88065e0460b111994491f28c9"

#define SinaAppId @"3440491783"
#define SinaAppSecret @"ed3df3d26e9a609a3c2e93bc4d929fb5"


#define testUrl  @"getPraiseInfo"
#define FeaturedTopicsList @""


/**
 *  默认接口参数
 */
#define kDefaultAPI   @"getSource.action"


/**
 *  分类筛选
 *
 *  @return json
 */
#define kSortChinaprodAPI       @"getChianprodMall" //国内
#define kSortAbroadprodAPI      @"getAbroadprodMall" //国外

/**
 *  分类信息
 *
 *  @return json
 */
#define kClassInfosAPI  @"getSortInfos"

/**
 *  获取热门关键词
 *
 *  @return json
 */
#define kHotWordsAPI    @"getHotWords"

/**
 *  搜索
 *
 *  @return json
 */
#define kSearchHotWordsAPI  @"getCoreSv.action"

#endif
