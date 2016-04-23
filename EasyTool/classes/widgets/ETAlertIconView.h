//
//  ETAlertIconView.h
//  EasyTool
//
//  Created by supertext on 14-6-10.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EasyTools/ETAlertManager.h>
NS_ASSUME_NONNULL_BEGIN
NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETAlertIconView : UIView
+(instancetype)iconWithStyle:(ETAlertIconStyle)astyle;
-(instancetype)initWithStyle:(ETAlertIconStyle)astyle;
@end
NS_ASSUME_NONNULL_END