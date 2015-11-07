//
//  PhotoUtils.h
//  TeamWork
//
//  Created by sumeng on 5/11/15.
//  Copyright (c) 2015 Shenghuo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPhotoUtilsMaxSlide 1280.0f
#define kPhotoUtilsLongPhotoScale 3.0f
#define kPhotoUtilsLongPhotoMinSlide 960.0f
#define kPhotoUtilsCompressionQuality 0.7f

typedef enum _PhotoUtilsThumbMode {
    PhotoUtilsThumbModeNone = 0,
    PhotoUtilsThumbModeAspectFit = 1,
    PhotoUtilsThumbModeAspectFill = 2,
    PhotoUtilsThumbModeSizeFit = 3,
    
    PhotoUtilsThumbModeTotal
}PhotoUtilsThumbMode;

@interface PhotoUtils : NSObject

+ (void)saveToFiles:(NSArray *)assets complete:(void (^)(NSArray *infos))complete;

+ (void)saveToFiles:(NSArray *)assets thumbMode:(PhotoUtilsThumbMode)thumbMode thumbSize:(CGSize)thumbSize complete:(void (^)(NSArray *infos))complete;

+ (void)saveToFile:(UIImage *)image complete:(void (^)(NSDictionary *info))complete;

+ (void)saveToFile:(UIImage *)image thumbMode:(PhotoUtilsThumbMode)thumbMode thumbSize:(CGSize)thumbSize complete:(void (^)(NSDictionary *info))complete;

+ (void)clearFiles;

@end
