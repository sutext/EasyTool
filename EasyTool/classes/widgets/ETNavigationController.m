//
//  ETNavigationController.m
//  EasyTool
//
//  Created by supertext on 16/5/18.
//  Copyright © 2016年 icegent. All rights reserved.
//

#import "ETNavigationController.h"

@implementation ETNavigationController

-(UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}
-(UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

@end
