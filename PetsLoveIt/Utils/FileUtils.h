//
//  FileUtils.h
//  TeamWork
//
//  Created by sumeng on 5/11/15.
//  Copyright (c) 2015 Shenghuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

@property (nonatomic, copy, readonly) NSString *bundleDir;
@property (nonatomic, copy, readonly) NSString *documentDir;
@property (nonatomic, copy, readonly) NSString *cacheDir;
@property (nonatomic, copy, readonly) NSString *tmpDir;

+ (instancetype)shared;

- (BOOL)mkdir:(NSString *)dir;
- (BOOL)mkdir:(NSString *)dir intermediate:(BOOL)intermediate;

- (BOOL)exists:(NSString *)path;
- (BOOL)existsDir:(NSString *)dir;
- (BOOL)existsFile:(NSString *)path;

- (BOOL)remove:(NSString *)path;

- (NSString *)temporary:(NSString *)dir;
- (NSString *)temporary;

@end
