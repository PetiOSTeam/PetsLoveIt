//
//  TWImagePicker.m
//  TeamWork
//
//  Created by sumeng on 15/5/18.
//  Copyright (c) 2015年 Shenghuo. All rights reserved.
//

#import "TWImagePicker.h"
#import "CTAssetsPickerController.h"
#import "SVProgressHUD.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import "FileUtils.h"
#import <Photos/Photos.h>
#import "XLUtil.h"

#define kImagePickerMaxCount 9
#define kImagePickerDir @"PhotoUtils"
#define kImagePickerFileMaxSize 1024*1024  //1M
#define kImagePickerThumbDefaultSize CGSizeMake(150, 150)

@interface TWImagePicker () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, CTAssetsPickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *infos;

@end

@implementation TWImagePicker

- (id)init {
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id<TWImagePickerDelegate>)delegate {
    self = [super init];
    if (self) {
        _sourceType = UIImagePickerControllerSourceTypeCamera;
        _allowEditing = NO;
        _maximumNumberOfSelection = kImagePickerMaxCount;
        _thumbSize = CGSizeMake(100, 100);
        _thumbMode = PhotoUtilsThumbModeAspectFill;
        _infos = [[NSMutableArray alloc] init];
        
        _delegate = delegate;
    }
    return self;
}

#pragma mark - Public

static void *__s_image_picker_key;

- (void)executeInViewController:(UIViewController *)vc {
    if (_sourceType == UIImagePickerControllerSourceTypeCamera) {
#if TARGET_IPHONE_SIMULATOR
        [mAppUtils showHint:@"模拟器不支持拍照"];
        return;
#elif TARGET_OS_IPHONE
        
        if(CURRENT_SYS_VERSION >=7.0){
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)  //无权限
            {
                showAlertBox(@"邮币财富没有获得使用相机的权限，请前往设置->隐私->相机->打开邮币财富的权限。", nil);
                return;
            }
        }
        
        if ([UIImagePickerController isSourceTypeAvailable:_sourceType]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = _sourceType;
            picker.delegate = self;
            picker.allowsEditing = _allowEditing;
            [vc presentViewController:picker animated:YES completion:nil];
            
            objc_setAssociatedObject(picker, &__s_image_picker_key, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"暂时无法访问照像机"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
#endif
    }
    else if (_sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        if ([UIImagePickerController isSourceTypeAvailable:_sourceType]) {
            if (_allowEditing && _maximumNumberOfSelection == 1) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = _sourceType;
                picker.delegate = self;
                picker.allowsEditing = _allowEditing;
                [vc presentViewController:picker animated:YES completion:nil];
                
                objc_setAssociatedObject(picker, &__s_image_picker_key, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            else {
                CTAssetsPickerController* picker = [[CTAssetsPickerController alloc] init];
                picker.maximumNumberOfSelection = [self maximumNumberOfSelection];
                picker.assetsFilter = [ALAssetsFilter allPhotos];
                picker.delegate = self;
//                picker.selectedAssets = [self selectedAssets];
                picker.notDismissImagePicker = YES;
                [vc presentViewController:picker animated:YES completion:nil];
                
                objc_setAssociatedObject(picker, &__s_image_picker_key, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"暂时无法访问图库"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)executeFromAssets:(NSArray *)assets {
    [self compressAssets:assets complete:^(NSArray *infos) {
        if (_delegate && [_delegate respondsToSelector:@selector(imagePicker:successed:)]) {
            [_delegate imagePicker:self successed:infos];
        }
    }];
}

+ (void)clearTempFiles {
    [[FileUtils shared] remove:[self cacheDir]];
}

#pragma mark - RecentPhoto

+ (void)getRecentPhoto:(void (^)(NSDictionary *info))result {
    [self getLastPhoto:^(ALAsset *asset) {
        if (asset && [self isRecentPhoto:asset]) {
            if (result) {
                ALAssetRepresentation *representation = [asset defaultRepresentation];
                UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                UIImage *thumbImage = [TWImagePicker thumb:image mode:PhotoUtilsThumbModeSizeFit size:kImagePickerThumbDefaultSize];
                
                NSDictionary *info = @{kPhotoUtilsAsset:asset,
                                       kPhotoUtilsThumbImage:thumbImage};
                if (result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        result(info);
                    });
                }

            }
        }
        else {
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    result(nil);
                });
            }
        }
    }];
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,
                  ^{
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

+ (void)getLastPhoto:(void (^)(ALAsset *asset))result {
    ALAssetsLibrary *library = [self defaultAssetsLibrary];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *innerStop) {
                
                if (asset) {
                    if (result) {
                        result(asset);
                    }
                    
                    *stop = YES; *innerStop = YES;
                }
            }];
        }
        
    } failureBlock:^(NSError *error) {
        if (result) {
            result(nil);
        }
    }];
}

+ (BOOL)isRecentPhoto:(ALAsset *)asset {
    NSDate *currentDate = [NSDate date];
    NSDate *photoDate = [asset valueForProperty:ALAssetPropertyDate];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:photoDate];
    if (interval <= kTWImagePickerRecentInterval) {
        NSURL *photoUrl = [asset valueForProperty:ALAssetPropertyAssetURL];
        NSString *photoUrlStr = [photoUrl absoluteString];
        NSString *recentPhotoUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"TWImagePickerRecentPhotoUrl"];
        [[NSUserDefaults standardUserDefaults] setObject:photoUrlStr forKey:@"TWImagePickerRecentPhotoUrl"];
        return !(recentPhotoUrl && [recentPhotoUrl isEqualToString:photoUrlStr]);
    }
    return NO;
}

#pragma mark - Private

- (NSInteger)maximumNumberOfSelection {
    return kImagePickerMaxCount - _selectedInfos.count;
//    NSInteger num = kImagePickerMaxCount;
//    for (id obj in _selectedInfos) {
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *info = obj;
//            if ([info objectForKey:kPhotoUtilsAsset] == nil) {
//                num--;
//            }
//        }
//        else {
//            num--;
//        }
//    }
//    return num;
}

- (NSMutableArray *)selectedAssets {
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    for (id obj in _selectedInfos) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *info = obj;
            ALAsset *asset = [info objectForKey:kPhotoUtilsAsset];
            if (asset != nil) {
                [assets addObject:asset];
            }
        }
    }
    return assets;
}

- (NSArray *)newAssets:(NSArray *)assets {
    NSMutableArray *newAssets = [[NSMutableArray alloc] init];
    for (ALAsset *asset in assets) {
        BOOL duplicate = NO;
        for (id obj in _selectedInfos) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *info = obj;
                ALAsset *aAsset = [info objectForKey:kPhotoUtilsAsset];
                if ([asset.defaultRepresentation.filename isEqualToString:aAsset.defaultRepresentation.filename])
                {
                    duplicate = YES;
                    break;
                }
            }
        }
        if (!duplicate) {
            [newAssets addObject:asset];
        }
    }
    return newAssets;
}


+ (NSString *)cacheDir {
    NSString *dir = [[FileUtils shared].tmpDir stringByAppendingPathComponent:kImagePickerDir];
    [[FileUtils shared] mkdir:dir];
    return dir;
}

- (NSString *)temporary {
    NSString *dir = [TWImagePicker cacheDir];
    if (_saveDir && _saveDir.length > 0) {
        [[FileUtils shared] mkdir:_saveDir];
        dir = _saveDir;
    }
    NSString *path = [[[FileUtils shared] temporary:dir] stringByAppendingPathExtension:@"jpg"];
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

- (void)compressAssets:(NSArray *)assets complete:(void (^)(NSArray *infos))complete {
    [SVProgressHUD showWithStatus:@"处理中..." maskType:SVProgressHUDMaskTypeClear];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *infos = [[NSMutableArray alloc] initWithCapacity:assets.count];
        for (ALAsset *asset in assets) {
            @autoreleasepool {
                ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                if (assetRep != nil) {
                    UIImage *img = [UIImage imageWithCGImage:[assetRep fullScreenImage]];
                    if ([TWImagePicker isLongPhoto:img.size]) {
                        UIImageOrientation orientation = (UIImageOrientation)[assetRep orientation];
                        img = [UIImage imageWithCGImage:[assetRep fullResolutionImage]
                                                  scale:1.0f
                                            orientation:orientation];
                    }
                    
                    CGSize size = [TWImagePicker bestSize:img.size];
                    if (!CGSizeEqualToSize(size, img.size)) {
                        img = [img resize:size contentMode:UIViewContentModeScaleAspectFill];
                    }
                    img = [UIImage fixOrientation:img];
                    NSString *path = [self temporary];
                    NSData *imgData = UIImageJPEGRepresentation(img, kPhotoUtilsCompressionQuality);
                    [imgData writeToFile:path atomically:YES];
                    
                    UIImage *thumbImage = nil;
                    if (_thumbMode == PhotoUtilsThumbModeAspectFill) {
                        thumbImage = [UIImage imageWithCGImage:[asset thumbnail]];
                    }
                    else {
                        thumbImage = [TWImagePicker thumb:img mode:_thumbMode size:_thumbSize];
                    }
                    
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (complete) {
                complete(infos);
            }
        });
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        //save successful
    }
    else {
        //save failed
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [SVProgressHUD showWithStatus:@"处理中..." maskType:SVProgressHUDMaskTypeClear];
    UIImage *image = nil;
    if (picker.allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //save image to album
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *img = image;
        CGSize size = [TWImagePicker bestSize:img.size];
        if (!CGSizeEqualToSize(size, img.size)) {
            img = [img resize:size contentMode:UIViewContentModeScaleAspectFill];
        }
        img = [UIImage fixOrientation:img];
        NSString *path = [self temporary];
        NSData *imgData = UIImageJPEGRepresentation(img, kPhotoUtilsCompressionQuality);
        [imgData writeToFile:path atomically:YES];
        
        UIImage *thumbImage = [TWImagePicker thumb:image mode:_thumbMode size:_thumbSize];
        
        NSDictionary *info = nil;
        if (thumbImage) {
            info = @{kPhotoUtilsImagePath:path,
                     kPhotoUtilsThumbImage:thumbImage};
        }
        else {
            info = @{kPhotoUtilsImagePath:path};
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (_delegate && [_delegate respondsToSelector:@selector(imagePicker:successed:)]) {
                [_delegate imagePicker:self successed:@[info]];
            }
            [picker dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    if (_delegate && [_delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
        [_delegate imagePickerDidCancel:self];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CTAssetsPickerControllerDelegate

- (void)assetsPickerController:(CTAssetsPickerController*)picker didFinishPickingAssets:(NSArray*)assets
{
    [self compressAssets:assets complete:^(NSArray *infos) {
        if (_delegate && [_delegate respondsToSelector:@selector(imagePicker:successed:)]) {
            [_delegate imagePicker:self successed:infos];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker {
    if (_delegate && [_delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
        [_delegate imagePickerDidCancel:self];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
