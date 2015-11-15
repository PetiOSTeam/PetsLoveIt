//
//  NetworkAPI.h
//  iOSAppFramework
//
//  Created by kongjun on 14-5-22.
//  Copyright (c) 2014年 junfrosttong. All rights reserved.
//

#ifndef iOSAppFramework_NetworkAPI_h
#define iOSAppFramework_NetworkAPI_h
#define kBaseURL                    @"http://www.youbicaifu.com"
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



#define AppInit         @"/app/init"
#define AllMarketList   @"/market/allMarketPrice"
#define MarketStockPrice @"/market/marketStockPrice"
#define StockDetail @"/market/stockPrice"
#define StockKLineMinute @"/market/kLineM"
#define StockKLineDay @"/market/kLineD"
#define UserReg @"/user/reg"
#define UserSendCode @"/user/sendCode"
#define UserLogin @"/user/login"
#define UserCollectStock @"/user/collectStockList"
#define CollectStockAdd @"/user/collectStockAdd"
#define CollectStockDel  @"/user/collectStockDel"
#define FeaturedTopicsTitleList @"/article/getAllArticleSort"
#define FeaturedTopicsList @"/article/getArticleList"
#define TopicDetail @"/article/getArticleInfo"

#define AllNewsSort @"/news/getAllNewsSort"
#define AnnouncementList @"/news/getNewsList" 
#define AnnounceDetail @"/news/getNewsInfo"

#define AllDynamicList @"/topic/dongtai"
#define MyAtDynamicList @"/topic/dongtaiMyAt"
#define AddDynamic @"/topic/dongtaiAdd"
#define UserDongtai @"/topic/userDongtai"

#define GetTopicInfo @"/topic/getTopicInfo"

#define AddComment @"/topic/commentAdd"
#define upAddTopic  @"/user/loveTopicAdd"
#define upDeleteTopic @"/user/loveTopicDel"

#define TopicDelete @"/topic/topicDel"

#define AddForward @"/topic/forwardAdd"
#define CommentList @"/topic/getCommentList"

#define UploadAvatar @"/user/uploadIcon"
#define Mobile_change_my_password @"/user/editPassword"
#define UserSign @"/user/sign"

#define GetPersonInfo @"/user/view"
#define UserAtUserAdd @"/user/UserAtUserAdd"
#define UserAtUserDel @"/user/UserAtUserDel"

#define GetAtUserList @"/user/getAtUserList"
#define GetUserFansList @"/user/getUserFansList"

#define GetCheckUserList @"/user/getCheckUserList"
#define AtAllCheckUser @"/user/AtAllCheckUser"

#define QueryUserByName @"/user/queryUserByName"

#define UpdateUserData @"/user/update"
#define UpdateIsPublic @"/user/updateIsPublic"

#define UpdateTags @"/user/updateTags"

#define SendUserMessage @"/message/addMessage"

#define AboutUs @"/help/aboutUs"
#define HelpList @"/help/getNewUserHelpList"
#define MyMsgList @"/message/getMessageList"

#define ReadMyMsg @"/message/read"
#define AllReadMyMsg  @"/message/readAll"
#define DelMyMsg @"/message/del"

#define PushSort        @"/app/newsPushSort"
#define TopicCommentNum @"/topic/getCommentNum"

#define UserAdvice @"/user/liuyan"
#define ApplyToCheck @"/user/applyToCheck"
#define ApplyTolevel @"/user/applyTolevel"

#define opLogin @"/user/opLogin"

#endif
