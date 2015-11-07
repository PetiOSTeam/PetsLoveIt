//
//  PhotoUtils.m
//  TeamWork
//
//  Created by sumeng on 5/11/15.
//  Copyright (c) 2015 Shenghuo. All rights reserved.
//

#import "PhotoUtils.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FileUtils.h"

#define kPhotoUtilsDir @"PhotoUtils"
#define kPhotoUtilsFileMaxSize 1024*1024  //1M

@implementation PhotoUtils

#pragma mark - public

+ (void)saveToFiles:(NSArray *)assets thumbMode:(PhotoUtilsThumbMode)thumbMode thumbSize:(CGSize)thumbSize complete:(void (^)(NSArray *infos))complete
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *infos = [[NSMutableArray alloc] initWithCapacity:assets.count];
        for (id asset in assets) {
            if (![asset isKindOfClass:[ALAsset class]]) {
                [infos addObject:asset];
            }else{
                @autoreleasepool {
                    id obj = [asset valueForProperty:ALAssetPropertyType];
                    if (!obj) {
                        continue;
                    }
                    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                    if (assetRep != nil) {
                        CGImageRef imgRef = [assetRep fullResolutionImage];
                        UIImageOrientation orientation = (UIImageOrientation)[assetRep orientation];
                        UIImage *img = [UIImage imageWithCGImage:imgRef
                                                           scale:1.0f
                                                     orientation:orientation];
                        CGSize size = [self bestSize:img.size];
                        if (!CGSizeEqualToSize(size, img.size)) {
                            img = [img resize:size contentMode:UIViewContentModeScaleAspectFill];
                        }
                        img = [UIImage fixOrientation:img];
                        NSString *path = [self temporary];
                        NSData *imgData = UIImageJPEGRepresentation(img, kPhotoUtilsCompressionQuality);
                        if (imgData.length > kPhotoUtilsFileMaxSize) {
                            UIImage *tmpImg = [UIImage imageWithData:imgData];
                            imgData = UIImageJPEGRepresentation(tmpImg, 0.5);
                        }
                        [imgData writeToFile:path atomically:YES];
                        
                        UIImage *thumbImage = [self thumb:img mode:thumbMode size:thumbSize];
                        
                        if (thumbImage) {
                            [infos addObject:@{kPhotoUtilsAsset:asset,
                                               kPhotoUtilsImagePath:path,
                                               kPhotoUtilsThumbImage:thumbImage}];
                        }
                        else {
                            [infos addObject:@{kPhotoUtilsAsset:asset,
                                               kPhotoUtilsImagePath:path}];
                        }
                    }
                }
            }
        }
        if (complete != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(infos);
            });
        }
    });
}

+ (void)saveToFiles:(NSArray *)assets complete:(void (^)(NSArray *infos))complete {
    [self saveToFiles:assets thumbMode:PhotoUtilsThumbModeAspectFill thumbSize:CGSizeMake(100, 100) complete:complete];
}

+ (void)saveToFile:(UIImage *)image thumbMode:(PhotoUtilsThumbMode)thumbMode thumbSize:(CGSize)thumbSize complete:(void (^)(NSDictionary *info))complete
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *img = image;
        CGSize size = [self bestSize:img.size];
        if (!CGSizeEqualToSize(size, img.size)) {
            img = [img resize:size contentMode:UIViewContentModeScaleAspectFill];
        }
        img = [UIImage fixOrientation:img];
        NSString *path = [self temporary];
        NSData *imgData = UIImageJPEGRepresentation(img, kPhotoUtilsCompressionQuality);
        if (imgData.length > kPhotoUtilsFileMaxSize) {
            UIImage *tmpImg = [UIImage imageWithData:imgData];
            imgData = UIImageJPEGRepresentation(tmpImg, 0.5);
        }
        [imgData writeToFile:path atomically:YES];
        
        UIImage *thumbImage = [self thumb:image mode:thumbMode size:thumbSize];
        
        NSDictionary *info = nil;
        if (thumbImage) {
            info = @{kPhotoUtilsImagePath:path,
                     kPhotoUtilsThumbImage:thumbImage};
        }
        else {
            info = @{kPhotoUtilsImagePath:path};
        }
        
        if (complete != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(info);
            });
        }
    });
}

+ (void)saveToFile:(UIImage *)image complete:(void (^)(NSDictionary *info))complete {
    [self saveToFile:image thumbMode:PhotoUtilsThumbModeAspectFill thumbSize:CGSizeMake(100, 100) complete:complete];
}

+ (void)clearFiles {
    [[FileUtils shared] remove:[self cacheDir]];
}

#pragma mark - private

+ (NSString *)cacheDir {
    NSString *dir = [[FileUtils shared].tmpDir stringByAppendingPathComponent:kPhotoUtilsDir];
    [[FileUtils shared] mkdir:dir];
    return dir;
}

+ (NSString *)temporary {
    NSString *path = [[[FileUtils shared] temporary:[self cacheDir]] stringByAppendingPathExtension:@"jpg"];
    return path;
}

+ (BOOL)isLongPhoto:(CGSize)size {
    if (size.width == 0 || size.height == 0) {
        return NO;
    }
    return (size.height / size.width >= kPhotoUtilsLongPhotoScale
            || size.width / size.height >= kPhotoUtilsLongPhotoScale);
}

+ (CGSize)bestSize:(CGSize)size {
    if (size.width == 0 || size.height == 0) {
        return size;
    }
    CGSize bs = CGSizeMake(size.width, size.height);
    if ([self isLongPhoto:size]) {
        if (size.width >= size.height
            && size.height > kPhotoUtilsLongPhotoMinSlide)
        {
            bs.height = kPhotoUtilsLongPhotoMinSlide;
            bs.width = size.width / size.height * kPhotoUtilsLongPhotoMinSlide;
        }
        else if (size.height >= size.width
                 && size.width > kPhotoUtilsLongPhotoMinSlide)
        {
            bs.width = kPhotoUtilsLongPhotoMinSlide;
            bs.height = size.height / size.width * kPhotoUtilsLongPhotoMinSlide;
        }
    }
    else {
        if (size.width >= size.height
            && size.width > kPhotoUtilsMaxSlide)
        {
            bs.width = kPhotoUtilsMaxSlide;
            bs.height = size.height / size.width * kPhotoUtilsMaxSlide;
        }
        else if (size.height >= size.width
                 && size.height > kPhotoUtilsMaxSlide)
        {
            bs.height = kPhotoUtilsMaxSlide;
            bs.width = size.width / size.height * kPhotoUtilsMaxSlide;
        }
    }
    return bs;
}

+ (UIImage *)thumb:(UIImage *)image mode:(PhotoUtilsThumbMode)mode size:(CGSize)size {
    if (image == nil) {
        return nil;
    }
    
    if (mode == PhotoUtilsThumbModeNone) {
        return nil;
    }
    else if (mode == PhotoUtilsThumbModeAspectFit) {
        return [image resize:size contentMode:UIViewContentModeScaleAspectFit];
    }
    else if (mode == PhotoUtilsThumbModeAspectFill) {
        return [image resize:size contentMode:UIViewContentModeScaleAspectFill];
    }
    else if (mode == PhotoUtilsThumbModeSizeFit) {
        CGSize sz = size;
        if (image.size.width/image.size.height >= size.width/size.height) {
            sz.width = size.width;
            sz.height = image.size.height / image.size.width * size.height;
        }
        else {
            sz.width = image.size.width / image.size.height * size.width;
            sz.height = size.height;
        }
        return [image resize:sz contentMode:UIViewContentModeScaleAspectFit];
    }
    else {
        return nil;
    }
}

@end
