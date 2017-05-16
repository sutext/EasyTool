//
//  ETSideViewController.h
//  EasyTool
//
//  Created by supertext on 14-10-15.
//  Copyright (c) 2014年 icegent. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ETLayoutViewStatus)
{
    ETLayoutViewStatusNormal,
    ETLayoutViewStatusLeftshowing,
    ETLayoutViewStatusLeftshowed,
    ETLayoutViewStatusLefthiding,
    ETLayoutViewStatusRightshowing,
    ETLayoutViewStatusRightshowed,
    ETLayoutViewStatusRighthiding,
};

typedef NS_ENUM(NSInteger, ETLayoutViewDisplayMode)
{
    ETLayoutViewDisplayModeBackground,
    ETLayoutViewDisplayModeCover,
    ETLayoutViewDisplayModeDefault = ETLayoutViewDisplayModeBackground,
};

NS_CLASS_AVAILABLE_IOS(7_0)

@interface ETLayoutViewController : UIViewController<UIGestureRecognizerDelegate>

-(instancetype)initWithRootViewController:(UIViewController *)      rootViewController;//the desined contructor!!
@property (nonatomic,strong,readonly)   UIViewController            *rootViewController;
@property (nonatomic,strong,readonly)   UIPanGestureRecognizer      *panGestureRecognizer;//you can't change the panGestureRecognizer's delegate in any case!!!
@property (nonatomic,strong,nullable)   UIViewController            *leftViewController;
@property (nonatomic,strong,nullable)   UIViewController            *rightViewController;
@property (nonatomic,readonly)          ETLayoutViewStatus          status;
@property (nonatomic)                   ETLayoutViewDisplayMode     leftDisplayMode;
@property (nonatomic)                   ETLayoutViewDisplayMode     rightDisplayMode;
@property (nonatomic)                   NSTimeInterval              animationDuration;
@property (nonatomic,getter=canDisplayShadow) BOOL                  displayShadow;
/*!
 *  @author 15-03-12 14:03:13
 *
 *  @brief  relative to the baseview left-top point. use for set  the leftViewController max position
 *          default vaule is (240,64)
 *          if leftDisplayModle == ETLayoutViewDisplayModleCover leftDisplayVector.y will be ignore
 */
@property (nonatomic) CGVector                                  leftDisplayVector;
/*!
 *  @author 15-03-12 14:03:47
 *
 *  @brief  relative to the baseview right-top point .use for set the rightViewController max show position
 *          default vaule is (80,64)
 *          if rightDisplayModle == ETLayoutViewDisplayModleCover rightDisplayVector.y will be ignore
 */
@property (nonatomic) CGVector                                  rightDisplayVector;

/*------thes method may called by user  for control the status by himself-----*/
- (void)setPanGestureEnable:(BOOL)enable;//enable the gesture or not. default is yes
- (void)showLeftViewController:(BOOL)animated;//show the left controller . if the leftViewController is nil or the status isn't ETLayoutViewStatusNormal nothing happend.
- (void)showRightViewController:(BOOL)animated;//show the right controller.if the rightViewController is nil the status isn't ETLayoutViewStatusNormal nothing happend
- (void)dismissCurrentController:(BOOL)animated;//dismiss current showed controller if status is neither ETLayoutViewStatusLeftshowed nor ETLayoutViewStatusRightshowed  nothing happend.
/*----------------------------------------------------------------------------*/

@end
@interface ETLayoutViewController (customAnimationSuport)
/*!
 *  @author 15-03-12 15:03:42
 *
 *  @brief  subclass implement this method to add some conjoined animation during layout animating.
 *
 *  @param offset        if left controller showing the offset is relative to the leftside of bounds otherwise relative to the rightside.
 *  @param animationView the current animationview
 *  @param status        the current layout status
 */
- (void)layoutSubviewWithOffset:(CGFloat)offset maxOfsset:(CGFloat)maxofsset atView:(UIView *)animationView status:(ETLayoutViewStatus)status;
@end

NS_ASSUME_NONNULL_END
