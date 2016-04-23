//
//  ETPhotoObject.h
//  EasyTool
//
//  Created by supertext on 14/12/15.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
/*!
 *  @author 15-01-27 19:01:05
 *
 *  @brief  data modleType
 */
typedef NS_ENUM(NSInteger, ETPhotoObjectType){
    /*!
     *  @author 15-01-27 19:01:05
     *
     *  @brief  image file in the local sandbox
     */
    ETPhotoObjectTypeLocal,
    /*!
     *  @author 15-01-27 19:01:05
     *
     *  @brief  image in the photo album
     */
    ETPhotoObjectTypeAlbum NS_ENUM_AVAILABLE_IOS(8_0),
    /*!
     *  @author 15-01-27 19:01:05
     *
     *  @brief  image in the remote server
     */
    ETPhotoObjectTypeRemote
};

@class PHAsset;
@protocol ETPhotoObjectDelegate;

NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETPhotoObject : NSObject<NSCopying>

-(instancetype)initWithAsset:(PHAsset *)asset NS_AVAILABLE_IOS(8_0);
-(instancetype)initWithImage:(UIImage *)image thumb:(UIImage *)thumb;
-(instancetype)initWithURL:(NSString *)imageURL thumbURL:(NSString *)thumbURL;

@property(nonatomic,weak)id<ETPhotoObjectDelegate> delegate;
@property(nonatomic,readonly)ETPhotoObjectType photoType;

@property(nonatomic,strong,readonly)PHAsset *asset NS_AVAILABLE_IOS(8_0);//ETPhotoObjectTypleAlbum

@property(nonatomic,strong,readonly)UIImage *image;//ETPhotoObjectTypleLocal
@property(nonatomic,strong,readonly)UIImage *thumb;//ETPhotoObjectTypleLocal

@property(nonatomic,strong,readonly)NSString *imageURL;//ETPhotoObjectTypleRemote
@property(nonatomic,strong,readonly)NSString *thumbURL;//ETPhotoObjectTypleRemote
@end

@protocol ETPhotoObjectDelegate <NSObject>

-(CGRect)orginalRectForPhoto:(ETPhotoObject *)photo;

@end
NS_ASSUME_NONNULL_END