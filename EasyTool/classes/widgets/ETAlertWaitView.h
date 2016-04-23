//
//  ETAlertWaitView.h
//  EasyTool
//
//  Created by supertext on 14-6-12.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EasyTools/ETAlertManager.h>
NS_ASSUME_NONNULL_BEGIN
NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETAlertWaitView : UIView
+(instancetype)waitWithStyle:(ETAlertWaitStyle)astyle;

-(instancetype)initWithStyle:(ETAlertWaitStyle)astyle;

-(void)startAnimation;

-(void)stopAnimation;
@end
NS_ASSUME_NONNULL_END