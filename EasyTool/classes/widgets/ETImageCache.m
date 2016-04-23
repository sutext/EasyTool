//
//  ETImageCache.m
//  EasyTool
//
//  Created by supertext on 16/2/19.
//  Copyright © 2016年 icegent. All rights reserved.
//

#import <EasyTools/ETImageCache.h>
#import <EasyTools/UIImageView+AFNetworking.h>
#import <EasyTools/AFImageDownloader.h>
@interface ETImageCache()
@property(nonatomic,weak)AFAutoPurgingImageCache *imageCache;
@end
@implementation ETImageCache
+(instancetype)sharedCache
{
    static dispatch_once_t onceToken;
    static ETImageCache *_sharedCache;
    dispatch_once(&onceToken, ^{
        _sharedCache=[[super allocWithZone:nil] init];
    });
    return _sharedCache;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedCache];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageCache = [UIImageView sharedImageDownloader].imageCache;
    }
    return self;
}
- (void)addImage:(UIImage *)image withIdentifier:(NSString *)identifier
{
    [self.imageCache addImage:image withIdentifier:identifier];
}
- (BOOL)removeImageWithIdentifier:(NSString *)identifier
{
    return [self.imageCache removeImageWithIdentifier:identifier];
}
- (void)clearMemery
{
    [self.imageCache removeAllImages];
}
-(void)clearDisk
{
    [[AFImageDownloader defaultURLCache] removeAllCachedResponses];
}
- (nullable UIImage *)imageWithIdentifier:(NSString *)identifier
{
    return [self.imageCache imageWithIdentifier:identifier];
}
-(UInt64)memoryCapacity
{
    return self.imageCache.memoryCapacity;
}
-(UInt64)memoryUsage
{
    return self.imageCache.memoryUsage;
}
-(UInt64)preferredMemoryUsageAfterPurge
{
    return self.imageCache.preferredMemoryUsageAfterPurge;
}
@end
