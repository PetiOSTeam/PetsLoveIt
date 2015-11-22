//
//  NetworkAPI.h
//  iOSAppFramework
//
//  Created by kongjun on 14-5-22.
//  Copyright (c) 2014年 junfrosttong. All rights reserved.
//

#ifndef iOSAppFramework_NetworkAPI_h
#define iOSAppFramework_NetworkAPI_h
#define kBaseURL                    @"http://121.42.51.60:8088/petweb/actions/"
#define UMENG_APPKEY                @"56484222e0f55ad4db009b90"
#define UMENG_channelId             @"petiOSAppStore"

static NSString *const iVersioniOSAppStoreURLFormat = @"https://itunes.apple.com/us/app/you-bi-cai-fu/id1043407423?mt=8&uo=4";
static NSString *const appStoreID = @"1043407423";

#define QQSDKAppID @"1104902660"
#define QQAppKey   @"DE1hR1uJxDpFAQ9c"

#define WXAppId    @"wxf89553206e1e0280"
#define WXAppSecret @"7da19cc88065e0460b111994491f28c9"

#define SinaAppId @"3440491783"
#define SinaAppSecret @"ed3df3d26e9a609a3c2e93bc4d929fb5"


#define testUrl  @"getPraiseInfo"
#define FeaturedTopicsList @""


/**
 *  分类筛选
 *
 *  @return json
 */
#define kSortClassAPI   @"getSource.action"

/**
 *  热门关键词
 *
 *  @return json
 */
#define kHotwordsAPI    @"getSource.action"

#endif
