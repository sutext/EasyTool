//
//  ETPhotoManager.m
//  EasyTool
//
//  Created by supertext on 15/1/30.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <EasyTools/ETPhotoManager.h>
#import <Photos/Photos.h>
#import <EasyTools/EasyTool.h>

@interface ETPhotoManager()
@property(nonatomic,strong)NSCache *thumbCache;
@property(nonatomic,strong)NSCache *imageCache;
@property(nonatomic,strong)NSOperationQueue *imageFetchQueue;
@end
@implementation ETPhotoManager
+(instancetype)sharedManager
{
    static dispatch_once_t onceToken = 0;
    static ETPhotoManager *_sharedManager;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[super allocWithZone:nil] init];
    });
    return _sharedManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.thumbCache=[[NSCache alloc] init];
        self.thumbCache.countLimit=50;
        self.imageCache=[[NSCache alloc] init];
        self.imageCache.countLimit=5;
        self.imageFetchQueue = [[NSOperationQueue alloc] init];
        self.imageFetchQueue.maxConcurrentOperationCount = 3;
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}
-(ETPhotoOperation *)dataWithAsset:(PHAsset *)asset completedBlock:(void (^)(NSData *, NSError *))completedBlock
{
    if (!completedBlock) {
        return nil;
    }
    if (!asset) {
        completedBlock(nil,[NSError errorWithDomain:@"ETPhotoAssetErrorDomain" code:-1 userInfo:@{@"error:":@"asset is nil"}]);
        return nil;
    }
    NSBlockOperation *opertaion = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOP = opertaion;
    [opertaion addExecutionBlock:^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        __block NSData *result;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            result = imageData;
        }];
        __strong  NSBlockOperation *strongOP = weakOP;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!strongOP.cancelled) {
                completedBlock(result,nil);
            }
        });
    }];
    [self.imageFetchQueue addOperation:opertaion];
    return opertaion;
}
-(ETPhotoOperation *)imageWithAsset:(PHAsset *)asset completedBlock:(void (^)(UIImage *, NSError *))completedBlock
{
    if (!completedBlock) {
        return nil;
    }
    if (!asset) {
        completedBlock(nil,[NSError errorWithDomain:@"ETPhotoAssetErrorDomain" code:-1 userInfo:@{@"error:":@"asset is nil"}]);
        return nil;
    }
    UIImage *image=[self.imageCache objectForKey:asset.localIdentifier];
    if (image) {
        completedBlock(image,nil);
        return nil;
    }
    NSBlockOperation *opertaion = [[NSBlockOperation alloc] init];
    
    __weak NSBlockOperation * weakOP = opertaion;
    
    CGFloat maxlenth = MAX(kETScreenHeight, kETScreenWith);
    [opertaion addExecutionBlock:^{
        NSError *error;
        UIImage *result = [self imageWithAsset:asset targetSize:CGSizeMake(maxlenth, maxlenth) error:&error];
        if (result) {
            [self.imageCache setObject:asset.localIdentifier forKey:image];
        }
        __strong  NSBlockOperation *strongOP = weakOP;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!strongOP.cancelled) {
                completedBlock(result,error);
            }
        });
    }];
    [self.imageFetchQueue addOperation:opertaion];
    return opertaion;
}
-(ETPhotoOperation *)thumbWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize completedBlock:(void (^)(UIImage *, NSError *))completedBlock
{
    return [self thumbWithAsset:asset sync:NO targetSize:targetSize completedBlock:completedBlock];
}
-(ETPhotoOperation *)thumbWithAsset:(PHAsset *)asset sync:(BOOL)sync targetSize:(CGSize)targetSize completedBlock:(void (^)(UIImage *, NSError *))completedBlock
{
    if (!completedBlock) {
        return nil;
    }
    if (!asset) {
        completedBlock(nil,[NSError errorWithDomain:@"ETPhotoAssetErrorDomain" code:-1 userInfo:@{@"error:":@"asset is nil"}]);
        return nil;
    }
    UIImage *image=[self.thumbCache objectForKey:asset.localIdentifier];
    if (image) {
        completedBlock(image,nil);
        return nil;
    }
    targetSize.width *=[UIScreen mainScreen].scale;
    targetSize.height*=[UIScreen mainScreen].scale;
    if (sync) {
        NSError *error;
        UIImage *image = [self imageWithAsset:asset targetSize:targetSize error:&error];
        completedBlock(image,error);
        return nil;
    }
    else
    {
        NSBlockOperation *opertaion = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOP = opertaion;
        [opertaion addExecutionBlock:^{
            NSError *error;
            UIImage *result = [self imageWithAsset:asset targetSize:targetSize error:&error];
            if (result) {
                [self.thumbCache setObject:asset.localIdentifier forKey:image];
            }
            __strong  NSBlockOperation *strongOP = weakOP;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!strongOP.cancelled) {
                    completedBlock(result,error);
                }
            });
        }];
        [self.imageFetchQueue addOperation:opertaion];
        return opertaion;
    }
}

-(UIImage *)imageWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize error:(NSError * __autoreleasing *)error
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    __block UIImage *image;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:0 options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            image = result;
        }
        else
        {
            if (error) {
                *error =[NSError errorWithDomain:@"ETPhotoAssetErrorDomain" code:-1 userInfo:info];
            }
        }
    }];
    return image;
}
@end
