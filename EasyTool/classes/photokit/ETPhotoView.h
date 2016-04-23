//
//  ETPhotoView.h
//  EasyTool
//
//  Created by supertext on 15/1/16.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ETPhotoObject;
@class ETPhotoConfig;
@protocol ETPhotoViewDelegate;


NS_CLASS_AVAILABLE_IOS(7_0)@interface ETPhotoView : UIView

-(instancetype)initWithPhoto:(ETPhotoObject *)photo config:(nullable ETPhotoConfig *)config;

@property(nonatomic,strong,readonly)            ETPhotoObject               * photo;
@property(nonatomic,strong,readonly)            ETPhotoConfig               * config;
@property(nonatomic,strong,readonly)            UIImage                     * image;//the readonly image .if image loaded return it otherwish return nil
@property(nonatomic,weak,readonly)              id<ETPhotoViewDelegate>     delegate;
@property(nonatomic,readonly,getter=isZooming)  BOOL                        zooming;
@property(nonatomic,getter=isZoomEnable)        BOOL                        zoomEnable;
@property(nonatomic,getter=canLongpress)        BOOL                        longpressEnable;
@property(nonatomic,getter=canAutoShrink)       BOOL                        autoShrink;
/*!
 *  @author 15-02-03 22:02:17
 *
 *  @brief  you may call this method before photo show in the screen to preload the iamge.
 */
-(void)preloadImage;
/*!
 *  @author 15-02-03 22:02:05
 *
 *  @brief  zoom to 1
 *
 *  @param animated need animation
 */
-(void)restoreAnimated:(BOOL)animated;
/*!
 *  @author 15-02-03 22:02:25
 *
 *  @brief  the switch of zoom function . if zoomEnable==YES restore and animated param will be ignore
 *
 *  @param zoomEnable can zoom
 *  @param restore    restore zoom state
 *  @param animated   need animation when restore
 */
-(void)setZoomEnable:(BOOL)zoomEnable restore:(BOOL)restore animated:(BOOL)animated;
/*!
 *  @author 15-04-08 17:04:01
 *
 *  @brief  show the zoomview if image dos't loaded ,load it.
 */
-(void)showZoomView;
/*!
 *  @author 15-02-09 15:02:55
 *
 *  @brief  to make the big zoomview scale to a small one whith animation
 */
-(void)hideZoomView;
@end

@protocol ETPhotoViewDelegate <NSObject>
@optional
/*!
 *  @author 15-02-09 14:02:56
 *
 *  @brief  happened when you call [ETPhotoView showZoomviewAnimated:].
 *
 *  @param photoView        the sender view
 *  @param zoomView         the imageView for scale in photoView
 *  @param isOriginAnimator is the origin point animator or not
 *  @param error            have some error when load remote image or not
 */
-(void)photoView:(ETPhotoView *)photoView zoomViewWillAppear:(UIImageView *)zoomView originAnimator:(BOOL)isOriginAnimator;
-(void)photoView:(ETPhotoView *)photoView zoomViewDidAppear:(UIImageView *)zoomView originAnimator:(BOOL)isOriginAnimator error:(nullable NSError *)error;
/*!
 *  @author 15-02-09 15:02:47
 *
 *  @brief  happend affter you call [ETPhotoView hideZoomView:] or autoShrink happened.
 *
 *  @param photoView the sender view
 *  @param zoomView  the content image view for zoom
 */
-(void)photoView:(ETPhotoView *)photoView zoomViewWillDisappear:(UIImageView *)zoomView;
-(void)photoView:(ETPhotoView *)photoView zoomViewDidDisappear:(UIImageView *)zoomView;
/*!
 *  @author 15-02-09 12:02:33
 *
 *  @brief  the long press action . if you want to receive this message you must call [ETPhotoView setLongpressEnable:YES]
 *
 *  @param photoView the sender view
 *  @param point     the longpressed point in photoview
 */
-(void)photoView:(ETPhotoView *)photoView longPressedAtpoint:(CGPoint)point;
/*!
 *  @author 15-02-09 12:02:35
 *
 *  @brief  the tap action
 *
 *  @param photoView the sender view
 *  @param point     the tap point in photoview
 */
-(void)photoView:(ETPhotoView *)photoView clickedAtpoint:(CGPoint)point;
/*!
 *  @author 15-02-09 12:02:02
 *
 *  @brief  the action when you scale across 1. this method will be call at any scale across 1
 *
 *  @param photoView the photo view
 *  @param increasing  is increasing or decreasing
 */
-(void)photoView:(ETPhotoView *)photoView scaleAcrossCriticalIncreasing:(BOOL)increasing;
/*!
 *  @author 15-02-10 12:02:34
 *
 *  @brief  the action when zoom animation did stop.
 *
 *  @param photoView the sender view
 *  @param scale     the scale when stop
 */
-(void)photoView:(ETPhotoView *)photoView zoomCompletedAtscale:(CGFloat)scale;
/*!
 *  @author 15-02-09 12:02:53
 *
 *  @brief  the action when any change of scale.this method will be call when the zoom gesture happened.
 *
 *  @param photoView  the sender view
 *  @param scale      the current scale
 *  @param increasing the scale direction : increasing or decreasing
 */
-(void)photoView:(ETPhotoView *)photoView zoomingAtscale:(CGFloat)scale increasing:(BOOL)increasing;
@end

NS_ASSUME_NONNULL_END