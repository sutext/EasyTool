//
//  EasyTool.h
//  EasyTool
//
//  Created by supertext on 14-10-15.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETDefinition.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
ET_EXTERN CGRect      ETEdgeInsetsOutsideRect(CGRect inRect,UIEdgeInsets insets);//the inverse operation of UIEdgeInsetsInsetRect.UIKit dosn't provide this method so we custom it.

ET_EXTERN UIImage *   ETRectImageWithColorScale(UIColor *color,CGSize size,CGFloat scale);//create a rectangle image with the color and size

ET_EXTERN UIImage *   ETRoundImageWithColorScale(UIColor *color,CGFloat radius,CGFloat scale);//create a round image with the color and radius

ET_EXTERN UIImage *   ETRectImageWithColor(UIColor *color,CGSize size);//create a rectangle image with the color and size scale=2

ET_EXTERN UIImage *   ETRoundImageWithColor(UIColor *color,CGFloat radius);//create a round image with the color and radius scale=2

ET_EXTERN UIColor *   ETColorFromRGBA(long long rgbValue,CGFloat aalpha);//create a UIColor with  hexadecimal RGB Value and alpha Value

ET_EXTERN UIColor *   ETColorFromRGB(long long rgbValue);//create a UIColor with  hexadecimal RGB Value and the alpha=1

ET_EXTERN NSString*   ETDocumentsDirectory();//the directory of Documents

ET_EXTERN NSString*   ETCachesDirectory();//the directory of Caches

ET_EXTERN CGFloat     ETScreenRatio();

ET_EXTERN CGFloat     ETScreenWidth();

ET_EXTERN CGFloat     ETScreenHeight();

ET_EXTERN CGFloat     ETScaledFloat(CGFloat value);

ET_EXTERN void        ETSwapSystemFontName(NSString *fontName);
#define kETScreenRatio      ETScreenRatio()
#define kETScreenWith       ETScreenWidth()
#define kETScreenHeight     ETScreenHeight()

@interface NSDate (easyTools)
/*!
 *  @author 14-12-24 14:12:19
 *
 *  @brief  use system timt.h interface to format Date to string. this method is efficiently!!!
 *
 *  @param format just like this:"%Y-%m-%d %H:%M:%S"->"2014-12-24 14:12:19"
                                 "%y-%m-%d %H:%M:%S"->"14-12-24 14:12:19"
 *
 *  @return time string using local time zone!
 */
-(NSString *)stringWithCFormat:(const char *__restrict)format;
/*!
 *  @author 14-12-25 09:12:00
 *
 *  @brief  @see (stringWithCFormat:) return:[self stringWithCFormat:[format UTF8String]];
 *
 *  @param format cformat
 *
 *  @return formate time string
 */
-(NSString *)stringWithFormat:(NSString *)format;

@end

@interface NSObject (easyTools)

@property(nonatomic,strong,nullable)id runtimeObject;

@end

@interface NSString (easyTools)
/*!
 *  @author 14-12-25 09:12:17
 *
 *  @brief  the inverse operation of [NSDate stringWithCFormat:] 
 *  @brief  analyze the import string as local time!
 *
 */
-(NSDate *)dateWithCFromat:(const char *__restrict)format;

-(NSDate *)dateWithFromat:(NSString *)format;

@end
@interface UITabBar (easyTools)
-(void)setBadgeValue:(NSInteger)badgeValue atIndex:(NSInteger)index;
-(void)setBadgeValue:(NSInteger)badgeValue badgeColor:(nullable UIColor *)badgeColor atIndex:(NSInteger)index;
@end
NS_ASSUME_NONNULL_END
