//
//  UIImage+easyTools.h
//  EasyTool
//
//  Created by supertext on 14-6-6.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ETArrowImageDirection) {
    ETArrowImageDirectionUP,
    ETArrowImageDirectionDown,
    ETArrowImageDirectionLeft,
    ETArrowImageDirectionRight,
} NS_AVAILABLE_IOS(7_0) ;
@interface UIImage (EasyTools)
+ (UIImage *)etScreenShot NS_AVAILABLE_IOS(7_0);
- (nullable UIImage *)etBlurGlass NS_AVAILABLE_IOS(7_0);
- (nullable UIImage *)etBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(nullable UIImage *)maskImage NS_AVAILABLE_IOS(7_0);
+(nullable UIImage *)imageWithBadge:(NSInteger)badgeVaue;
/*!
 *  @author 15-01-16 16:01:58
 *
 *  @brief  create image with color size adn scale
 *
 *  @param color color
 *  @param size  size
 *  @param scale scale
 *
 *  @return a new image
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size scale:(CGFloat)scale;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/*!
 *  @author 14-11-24 11:11:12
 *
 *  @brief  cut image use frame if CGRectContainsRect(orignalBounds, frame)
 *
 *  @param frame the frame relative to the image bounds
 *
 *  @return a new image
 */
-(UIImage *)cutUseFrame:(CGRect)frame NS_AVAILABLE_IOS(7_0);
/*!
 *  @author 14-11-24 11:11:06
 *
 *  @brief  cut center image use frame if CGRectContainsRect(orignalBounds, {(0,0),size}).
 *
 *  @param size new image size .
 *
 *  @return a new image
 */
-(UIImage *)cutUseSize:(CGSize)size NS_AVAILABLE_IOS(7_0);
/*!
 *  @author 14-11-24 11:11:07
 *
 *  @brief  //create a rectangle image with the color and size .the old image will show at the center of the new image
 *
 *  @param expandColor the around color
 *  @param size        the new image size
 *
 *  @return a new image
 */
-(UIImage *)expandUseColor:(UIColor *)expandColor toSize:(CGSize)size NS_AVAILABLE_IOS(7_0);
/*!
 *  @author 14-11-24 11:11:16
 *
 *  @brief  create a circle image with the color and size . the old image will show at the center of the new image
 *
 *  @param expandColor the around color
 *  @param radius      the circle radius
 *
 *  @return a new image.
 */
-(UIImage *)expandUseColor:(UIColor *)expandColor toCircleRadius:(CGFloat)radius NS_AVAILABLE_IOS(7_0);
/*!
 *  @Author 14-11-14 18:11:19
 *
 *  @brief  create an arrow image with param.the new image just like this:(ETArrowImageDirectionLeft:<)(ETArrowImageDirectionRight:>)
 *
 *  @param color     arrow color
 *  @param direction arrow direction
 *  @param size      arrow image size
 *  @param scale     arrow image scale
 *
 *  @return the arrow image
 */
+(UIImage *)arrowWithColor:(UIColor *)color direction:(ETArrowImageDirection) direction size:(CGSize)size scale:(CGFloat)scale NS_AVAILABLE_IOS(7_0);
/*!
 *  @Author 14-11-14 18:11:15
 *
 *  @brief  @see up use default params blueColor 20*20 size 2.0 scale
 *
 *  @param direction arrow image direction
 *
 *  @return arrow image
 */
+(UIImage *)arrowWithDirection:(ETArrowImageDirection)direction NS_AVAILABLE_IOS(7_0);

@end
NS_ASSUME_NONNULL_END