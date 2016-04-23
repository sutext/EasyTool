//
//  ETImageCache.h
//  EasyTool
//
//  Created by supertext on 16/2/19.
//  Copyright © 2016年 icegent. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class UIImage;
@interface ETImageCache : NSObject
+(instancetype)sharedCache;
@property (nonatomic, readonly) UInt64 memoryCapacity;
@property (nonatomic, readonly) UInt64 preferredMemoryUsageAfterPurge;
@property (nonatomic, readonly) UInt64 memoryUsage;
-(void)clearMemery;
-(void)clearDisk;
/**
 Adds the image to the cache with the given identifier.
 
 @param image The image to cache.
 @param identifier The unique identifier for the image in the cache.
 */
- (void)addImage:(UIImage *)image withIdentifier:(NSString *)identifier;

/**
 Removes the image from the cache matching the given identifier.
 
 @param identifier The unique identifier for the image in the cache.
 
 @return A BOOL indicating whether or not the image was removed from the cache.
 */
- (BOOL)removeImageWithIdentifier:(NSString *)identifier;
/**
 Returns the image in the cache associated with the given identifier.
 
 @param identifier The unique identifier for the image in the cache.
 
 @return An image for the matching identifier, or nil.
 */
- (nullable UIImage *)imageWithIdentifier:(NSString *)identifier;
@end
NS_ASSUME_NONNULL_END