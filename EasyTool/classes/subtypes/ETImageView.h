//
//  ETImageView.h
//  EasyTool
//
//  Created by supertext on 14-6-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETImageView : UIImageView
@property(nonatomic,copy,nullable)void (^tapAction)(ETImageView *imageView);
@end

@interface ETImageView(imageLoader)
/*!
 *  @author 15-01-15 14:01:33
 *
 *  @brief  the pakging for SD
 *
 *  @param url          url whitch can be remote or local .
 *  @param placeholder  the placeholder image
 *  @param complteBlock call back
 */
-(void)setImageWithURL:(nullable NSString *)url
           placeholder:(nullable UIImage*)placeholder
         completedBlock:(nullable void (^)(UIImage * _Nullable image,NSError * _Nullable error,ETImageView *imageView)) complteBlock;
/*!
 *  @author 15-03-02 14:03:19
 *
 *  @brief  load the origin image from system photo album
 *
 *  @param asset          PHAsset object
 *  @param placeholder    placeholder image
 *  @param completedBlock the call back
 */
-(void)setImageWithAsset:(nullable PHAsset *)asset
             placeholder:(nullable UIImage*)placeholder
          completedBlock:(nullable void (^)(UIImage * _Nullable image,NSError * _Nullable error))completedBlock NS_AVAILABLE_IOS(8_0);
/*!
 *  @author 15-03-02 14:03:09
 *
 *  @brief  load the thumb image from system photo album
 *
 *  @param asset          the PHAsset
 *  @param placeholder    the placeholder
 *  @param targetSize     the thumb target size
 *  @param completedBlock the call back
 */
-(void)setThumbWithAsset:(nullable PHAsset *)asset
             placeholder:(nullable UIImage*)placeholder
              targetSize:(CGSize)targetSize
          completedBlock:(nullable void (^)(UIImage * _Nullable image,NSError * _Nullable error))completedBlock NS_AVAILABLE_IOS(8_0);
@end
NS_ASSUME_NONNULL_END