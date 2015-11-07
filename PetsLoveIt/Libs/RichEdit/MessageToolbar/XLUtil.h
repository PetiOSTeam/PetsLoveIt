//
//  XLUtil.h
//  XLUtility
//
//  Created by Destiny on 12-10-19.
//  Copyright (c) 2012年 Destiny. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *deviceString();
/*打印字体册*/
void gainFontFamilyNames(void);

/*保存一个数据到本地*/
void saveMessageToLocal(NSString *message, NSString *key);

/*通过key读取一个本地的数据*/
NSString* loadMessageFromLocal(NSString *key);

// file managerment 文件管理
NSString*       filePathAtDocument(NSString *filename);
NSString*       filePathAtMainBundle(NSString *filename);
NSURL*          fileURL(NSString *path);
bool            isFileExistAtPath(NSString *filePath);

// simple read & write plist file 简单的阅读  &&  写入plist
NSArray*        arrayFromMainBundle(NSString *fileName);
//NSDictionary*   dictionaryFromMainBundle(NSString *fileName);
NSDictionary*   dictionaryAtMainBundle(NSString *filename);

NSArray*        loadArrayFromDocument(NSString *filename);
NSDictionary*   loadDictionaryFromDocument(NSString *filename);
UIImage*        getImageFromDocument(NSString *imageName);
BOOL            isDocumentHaveImage(NSString *filename);


BOOL            saveArrayToDocument(NSString *filename, NSArray *array);
BOOL            saveDictionaryToDocument(NSString *filename, NSDictionary *dictionary);
BOOL            saveDataToDocument(NSString *filename, NSData *data);
void            saveImageToDocument(UIImage *image, NSString *key);


// encoding    编码
NSString*       encodeURL(NSString *string);
NSString*       stringUsingEncodingUTF8(NSData *data);
NSString*       stringUsingEncoding(NSData *data, NSStringEncoding encoding);
NSData*         dataUsingEncodingUTF8(NSString *string);
NSData*         dataUsingEncoding(NSString *string, NSStringEncoding encoding);

// device
NSString*       deviceName(void);
NSString*       deviceModel(void);
NSString*       deviceSystemName(void);
NSString*       deviceSystemVersion(void);
bool            isRetinaDisplay(void);
void            deviceInfo(void);

// regular expressions
bool            isEmailFormat(NSString *email);
bool            isMobileFormat(NSString *mobile);
bool            isAccountFormat(NSString *account);
bool            isPasswordFormat(NSString *password);

// open URL
void openURL(NSURL *url);
void openRateURL(NSString *appId);
void openTelURL(NSString *tel);

// others
void            showAlertBox(NSString *title, NSString *message);
NSString*       currTime(void);
void            localNotification(void);

// NSCoder
bool            archive(id object, NSString *path);
id              unarchive(NSString *path);

id              unarchiveObjectFromPath(NSString *path);
id              unarchiveObjectFromPath(NSString *path);

/*添加一个通知*/
void            addNotification(id observer, SEL sel, NSString *name, id obj);
/*删除一个通知*/
void            removeNotification(id observer, NSString *name, id obj);


/*判断输入的是否是数字 以及位数来判定大小*/
BOOL            isPartialStringValid(NSString *partialString);

/*判断_obj对象是否和_str的类名的类是同一个类*/
BOOL isSameClass(Class _class, NSString * _str2);
extern void instanceClass(id *_obj, NSString *_controllerName);

/******************************************
 *@Description:四舍五入
 *@Return:返回int
 ******************************************/
int numberWithRounding(float number);

NSString    *pathInCacheDirectory(NSString *fileName);
bool        createDirInCache(NSString *dirName);
bool        deleteDirInCache(NSString *dirName, NSString *fileName);
bool        saveImageToCacheDir(NSString *directoryPath, UIImage *image, NSString *imageName, NSString *imageType);
NSData      *loadImageData(NSString *directoryPath, NSString *imageName);
BOOL        isFileExistsAtPath(NSString *fileName);

//取出tableview多余的线
void setExtraCellLineHidden(UITableView *tableView);
//调整tableView的偏移
void handleOpenCellOffsetWithIndexPath(NSIndexPath *indexPath, UITableView *tableView);

float tableViewOffsetFrom(UITableView *tableView, NSIndexPath *indexPath, float keyboardHeight, CGRect superFrame, float buttomBarHeight,float replyHeight);

