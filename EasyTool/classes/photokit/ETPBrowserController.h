//
//  ETPBrowserController.h
//  EasyTool
//
//  Created by supertext on 15/3/2.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <EasyTools/ETPhotoViewController.h>

NS_ASSUME_NONNULL_BEGIN

@class ETPhotoBrowser;

NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETPBrowserController : ETPhotoViewController
@property(nonatomic,weak,readonly)ETPhotoBrowser *browser;
@end

@class ETPhotoChildController;
/*!
 *  @author 15-03-02 15:03:39
 *
 *  @brief  these method is the implementation for ETPhotoViewController . if subclass overwrite these must call super
 *          these mehtod should never be called directly;
 */
@interface ETPBrowserController (implementedMethods)
-(void)prepareForPage:(ETPhotoChildController *)createdPage;
-(void)leftItemAction:(id)sender;
-(void)photoView:(ETPhotoView *)photoView zoomViewDidAppear:(UIImageView *)zoomView originAnimator:(BOOL)isOriginAnimator error:(nullable NSError *)error;
-(void)photoView:(ETPhotoView *)photoView zoomViewWillDisappear:(UIImageView *)zoomView;
-(void)photoView:(ETPhotoView *)photoView zoomViewDidDisappear:(UIImageView *)zoomView;
-(void)photoView:(ETPhotoView *)photoView clickedAtpoint:(CGPoint)point;
-(void)photoView:(ETPhotoView *)photoView scaleAcrossCriticalIncreasing:(BOOL)increasing;
-(void)photoView:(ETPhotoView *)photoView zoomingAtscale:(CGFloat)scale increasing:(BOOL)increasing;
@end

/*!
 *  @author 15-04-10 17:04:27
 *
 *  @brief  subclass overwrite thses methods to do some configuration
 */
@interface ETPBrowserController (configurations)
+(BOOL)autoCreateNavigation;
@end
NS_ASSUME_NONNULL_END