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
#if FOUNDATION_SWIFT_SDK_EPOCH_AT_LEAST(8)
@property (class, readonly, strong) ETGlobalContainer *singleContainer;//the single and shared instance.
#endif
-(void)present:(__kindof UIViewController *)controller;
-(void)dismissController;
@end
NS_ASSUME_NONNULL_END
