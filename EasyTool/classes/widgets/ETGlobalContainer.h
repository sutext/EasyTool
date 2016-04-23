//
//  ETGlobalContainer.h
//  EasyTool
//
//  Created by supertext on 16/3/9.
//  Copyright © 2016年 icegent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class UIViewController;
@interface ETGlobalContainer : NSObject
+(instancetype)singleContainer;
-(void)present:(__kindof UIViewController *)controller;
-(void)dismissController;
@end
NS_ASSUME_NONNULL_END