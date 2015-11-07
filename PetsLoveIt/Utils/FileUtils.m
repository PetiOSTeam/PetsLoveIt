//
//  FileUtils.m
//  TeamWork
//
//  Created by sumeng on 5/11/15.
//  Copyright (c) 2015 Shenghuo. All rights reserved.
//

#import "FileUtils.h"

@interface FileUtils () {
    NSFileManager* _fmgr;
}

@end

@implementation FileUtils

+ (instancetype)shared {
    static id obj = nil;
    @synchronized(self) {
        if (obj == nil) {
            obj = [[self alloc] init];
        }
    }
    return obj;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _fmgr = [NSFileManager defaultManager];
        
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSArray* caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        // 获得写入的根目录
        _bundleDir = [[NSBundle mainBundle].resourcePath copy];
        _documentDir = [dirs.lastObject copy];
        _cacheDir = [caches.lastObject copy];
        _tmpDir = [NSTemporaryDirectory() copy];
    }
    return self;
}

- (BOOL)mkdir:(NSString *)dir {
    return [self mkdir:dir intermediate:NO];
}

- (BOOL)mkdir:(NSString*)dir intermediate:(BOOL)intermediate {
    return [_fmgr createDirectoryAtPath:dir withIntermediateDirectories:intermediate attributes:nil error:nil];
}

- (BOOL)exists:(NSString*)path {
    return [_fmgr fileExistsAtPath:path];
}

- (BOOL)existsDir:(NSString*)dir {
    BOOL isDir;
    BOOL ret = [_fmgr fileExistsAtPath:dir isDirectory:&isDir];
    return (ret && dir);
}

- (BOOL)existsFile:(NSString*)path {
    BOOL isDir;
    BOOL ret = [_fmgr fileExistsAtPath:path isDirectory:&isDir];
    return (ret && !isDir);
}

- (BOOL)remove:(NSString *)path {
    NSError* err = nil;
    BOOL ret = [_fmgr removeItemAtPath:path error:&err];
    return ret;
}

- (NSString *)temporary:(NSString *)dir {
    NSString *file = [FileUtils UUID];
    if (dir && dir.length > 0) {
        [self mkdir:dir];
        return [dir stringByAppendingPathComponent:file];
    }
    else {
        return [_tmpDir stringByAppendingPathComponent:file];
    }
}

- (NSString*)temporary {
    return [self temporary:nil];
}

+ (NSString *)UUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

@end
