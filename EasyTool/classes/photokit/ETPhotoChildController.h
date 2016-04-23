//
//  ETPhotoChildController.h
//  EasyTool
//
//  Created by supertext on 15/1/16.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EasyTools/ETPhotoView.h>

NS_ASSUME_NONNULL_BEGIN

@class ETPhotoViewController;
NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETPhotoChildController : UIViewController<ETPhotoViewDelegate>
/*!
 *  @author 15-02-27 13:02:44
 *
 *  @brief the desinged constructor
 *
 *  @param photo  must be non-nil
 *  @param config if nil defaultConfig will be use
 *
 *  @return the new instance
 */
-(instancetype)initWithPhoto:(ETPhotoObject *)photo config:(nullable ETPhotoConfig *)config;
@property(nonatomic,strong,readonly)ETPhotoView *photoView;
@end

@interface ETPhotoChildController (ETPhotoViewController)
@property(nonatomic,weak,readonly)ETPhotoViewController *photoController;//when itself is created by ETPhotoViewController .return it.
@end

NS_ASSUME_NONNULL_END