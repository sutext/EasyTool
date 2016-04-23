//
//  ETPhotoViewController.h
//  EasyTool
//
//  Created by supertext on 15/2/6.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EasyTools/ETPhotoChildController.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ETPhotoViewScrollOrientation) {
    ETPhotoViewScrollOrientationHorizontal = 0,
    ETPhotoViewScrollOrientationVertical = 1,
};
@class ETPhotoObject;
NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETPhotoViewController : UIViewController<ETPhotoViewDelegate>

-(instancetype)initWithPhotos:(NSArray<__kindof ETPhotoObject *> *)photos startIndex:(NSUInteger)startIndex;
@property(nonatomic,strong,readonly)    NSOrderedSet                   *photoObjects;
@property(nonatomic,strong,readonly)    ETPhotoChildController         *currPage;
@property(nonatomic,strong,nullable)    UIColor                        *backgroundColor;
@property(nonatomic,readonly)           NSUInteger                     currentIndex;
@property(nonatomic,getter=isFullscreen)BOOL                           fullscreen;
/*!
 *  @author 15-04-10 16:04:47
 *
 *  @brief  remove current photo. if the photoObjects is empity affter remove the leftItemAction: will be call.
 */
-(void)deleteCurrent;
/*!
 *  @author 15-02-10 21:02:51
 *
 *  @brief  to add an other group of photos the current dataSorce array;
 *
 *  @param photos array of ETPhotoObject
 */
-(void)appendPhotos:(NSArray<__kindof ETPhotoObject *> *)photos;
/*!
 *  @author 15-03-13 14:03:05
 *
 *  @brief  add an other group of photos at index 0;
 *
 *  @param photos array of ETPhotoObject
 */
-(void)insertPhotos:(NSArray<__kindof ETPhotoObject *> *)photos;
/**--call these method to scroll to where you want without gesture--*/
-(void)scrollTonext:(BOOL)animated;
-(void)scrollToprev:(BOOL)animated;
-(void)scrollToindex:(NSInteger)index animated:(BOOL)animated;
@end

/*!
 *  @author 15-02-09 19:02:01
 *
 *  @brief  subclass can implement these methods to do something
 *  @note   all of these methods is overwrite point.
 */
@interface ETPhotoViewController(abstractMethods)

+(Class)photovcClass;// default is ETPhotoViewController class
+(ETPhotoViewScrollOrientation)orientation;//config the scroll orientation default is ETPhotoViewScrollOrientationHorizontal
+(nullable ETPhotoConfig *)configuration;//default is nil;
/*!
 *  @author 15-02-10 21:02:05
 *
 *  @brief the action of right navigationitem. default implement is :[self.navigationController popViewControllerAnimated:YES];
 *
 *  @param sender sender
 */
-(void)leftItemAction:(nullable id)sender;
/*!
 *  @author 15-02-27 10:02:27
 *
 *  @brief the action of right navigationitem .  default is empity implement.
 *
 *  @param sender the item
 */
-(void)rightItemAction:(nullable id)sender;
/*!
 *  @author 15-02-27 10:02:05
 *
 *  @brief  called when photoViewController have been initialized. you can do something initialization for page here.
 *
 *  @param createdPage the new photoViewController.
 */

-(void)prepareForPage:(ETPhotoChildController *)createdPage;

-(void)willTransmitFromPage:(ETPhotoChildController *)fromPage
                  fromIndex:(NSUInteger)fromIndex
                     toPage:(ETPhotoChildController *)toPage
                    toIndex:(NSUInteger)toIndex;//default is empity implement

-(void)didTransmitFromPage:(ETPhotoChildController *)fromPage
                 fromIndex:(NSUInteger)fromIndex
                    toPage:(ETPhotoChildController *)toPage
                   toIndex:(NSUInteger)toIndex;//default is empity implement
@end
NS_ASSUME_NONNULL_END