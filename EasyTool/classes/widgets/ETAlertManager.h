//
//  ETAlertManager.h
//  EasyTool
//
//  Created by supertext on 14-6-10.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ETAlertIconStyle) {
    ETAlertIconStyleNone,
    ETAlertIconStyleOK,
    ETAlertIconStyleFail,
    ETAlertIconStyleCircle,
    ETAlertIconStyleUpArrow,
    ETAlertIconStyleDownArrow,
    ETAlertIconStyleRightArrow ,
    ETAlertIconStyleLeftArrow,
    ETAlertIconStylePlay,
    ETAlertIconStylePause,
    ETAlertIconStyleExclamation,
    ETAlertIconStyleCloud,
    ETAlertIconStyleCloudUp,
    ETAlertIconStyleCloudDown,
    ETAlertIconStyleMail,
    ETAlertIconStyleMicrophone,
    ETAlertIconStyleLocation,
    ETAlertIconStyleHome,
    ETAlertIconStyleTweet,
    ETAlertIconStyleClock,
    ETAlertIconStyleWifiFull,
    ETAlertIconStyleWifiEmpty,
    ETAlertIconStyleGrieved,
};

typedef NS_ENUM(NSInteger, ETAlertWaitStyle) {
    ETAlertWaitStyleNone,
    ETAlertWaitStyleChrysanthemum,
};

/*!
 *  @Author 14-11-12 12:11:07
 *
 *  @brief  all the methods is thread safety. you can call them any where in any thread. at the same time only one alert can be show!
 */
NS_CLASS_AVAILABLE_IOS(8_0)
@interface ETAlertManager : NSObject
@property(nonatomic)CGFloat alertAlpha;
/**
 *  @brief packaging the UIAlertView to block suport
 *
 *  @param aTitle      the alert title
 *  @param aMessage    the alert message
 *  @param canceltitle the cancel button title
 *  @param otherTitle  the other cancel button title
 *  @param hiddenIndex the callback when alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex occur
 */
-(void)showAlertWihtTitle:(nullable NSString *)aTitle
                  message:(nullable NSString *)amessage
        cancelButtonTitle:(nullable NSString *)canceltitle
         otherButtonTitle:(nullable NSString *)otherTitle
          onHiddenAtIndex:(nullable void (^)(UIAlertController *alert,NSInteger index))hiddenIndex;
/**
 *  @brief show the waiting view .you may call hideWaiting to hide it.the waitStyle=ETAlertWaitStyleChrysanthemum
 *
 *  @param aMessage    the alert message
 *  @param appearBlock the callback when the alertview show complete
 *  @param cancelBlock the callback when user clicked the cancel icon
 */
-(void)showWaitingMessage:(NSString *)amessage
           appearComplete:(nullable void (^)(UIView *alertView)) appearBlock
              canceled:(nullable void (^)(UIView *alertView)) cancelBlock;
/**
 *  @brief show the waiting view .you may call hideWaiting to hide it.
 *  @param message :the message to show.this param can be nil
 *  @param waitStyle :the style of wait view
 *  @param appearComplete : the callBack of the show animation complete
 *  @param canceled : called when user canceled
 */
-(void)showWaitingMessage:(NSString *)amessage
                waitStyle:(ETAlertWaitStyle)aStyle
           appearComplete:(nullable void (^)(UIView *alertView)) appearBlock
                 canceled:(nullable void (^)(UIView *alertView)) cancelBlock;
/**
 *  @brief  call this method affter showWaitingMessage to hide the waiting alertView
 */
-(void)hideWaiting:(nullable void (^)(UIView *alertView))hideBlock;

/**
 *  @brief show the icon view .and the duration=1.0.
 */
-(void)showIconMessage:(NSString *)amessage
             iconStyle:(ETAlertIconStyle)aStyle
          hideComplete:(nullable void (^)(UIView *alertView))hideBlock;
/**
 *  @brief show the icon view .it will auto hide affter duration.
 *  @param message :the message to show.this param can be nil
 *  @param duration :if duration is less than .5s. we will change it to 0.5s
 *  @param iconStyle : the icon style
 *  @param hideComplete : the callBack of the hide animation complete
 */
-(void)showIconMessage:(NSString *)amessage
             iconStyle:(ETAlertIconStyle)aStyle
              duration:(double)aDuration
          hideComplete:(nullable void (^)(UIView *alertView))hideBlock;
@end
NS_ASSUME_NONNULL_END