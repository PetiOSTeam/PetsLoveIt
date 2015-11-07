//
//  TWImagePicker.h
//  TeamWork
//
//  Created by sumeng on 15/5/18.
//  Copyright (c) 2015年 Shenghuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoUtils.h"

#define kTWImagePickerRecentInterval 20.0f

@protocol TWImagePickerDelegate;

@interface TWImagePicker : NSObject

@property (nonatomic, weak) id<TWImagePickerDelegate> delegate;
@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;
@property (nonatomic, assign) BOOL allowEditing;
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) CGSize thumbSize;
@property (nonatomic, assign) PhotoUtilsThumbMode thumbMode;
@property (nonatomic, strong) NSArray *selectedInfos;
@property (nonatomic, copy) NSString *saveDir;

- (id)initWithDelegate:(id<TWImagePickerDelegate>)delegate;
- (void)executeInViewController:(UIViewController *)vc;
- (void)executeFromAssets:(NSArray *)assets;

+ (void)clearTempFiles;

+ (void)getRecentPhoto:(void (^)(NSDictionary *info))result;

@end

@protocol TWImagePickerDelegate <NSObject>

- (void)imagePicker:(TWImagePicker *)picker successed:(NSArray *)infos;

@optional

- (void)imagePickerDidCancel:(TWImagePicker *)picker;

@end