//
//  ETGlobalContainer.m
//  EasyTool
//
//  Created by supertext on 16/3/9.
//  Copyright © 2016年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EasyTools/ETGlobalContainer.h>

@interface ETGlobalContainer()
@property(nonatomic,strong,readwrite)UIWindow *keyWindow;
@end
@implementation ETGlobalContainer
+(instancetype)singleContainer
{
    static ETGlobalContainer * _container;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _container = [[super allocWithZone:nil] init];
    });
    return _container;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self singleContainer];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        UIWindow *actionWindow          = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        actionWindow.windowLevel        = UIWindowLevelAlert-1;
        actionWindow.backgroundColor    = [UIColor clearColor];
        self.keyWindow                  = actionWindow;
    }
    return self;
}
-(void)present:(UIViewController *)controller
{
    self.keyWindow.rootViewController = controller;
    self.keyWindow.hidden = NO;
}
-(void)dismissController
{
    
    self.keyWindow.hidden = YES;
    self.keyWindow.rootViewController = nil;
}
@end