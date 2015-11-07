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
#define UMENG_APPKEY                @"560603b6e0f55a557c00450e"

static NSString *const iVersioniOSAppStoreURLFormat = @"https://itunes.apple.com/us/app/you-bi-cai-fu/id1043407423?mt=8&uo=4";
static NSString *const appStoreID = @"1043407423";

#define QQSDKAppID @"1104747343"
#define WXAppId    @"wx48000a55fa8aab5d"
#define WXAppSecret @"fef3e591dbb0a7ea9f5740a7d3cb4e06"

#define SinaAppId @"2983639920"
#define SinaAppSecret @"149ff6096df921fcb7829872601322c3"



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
