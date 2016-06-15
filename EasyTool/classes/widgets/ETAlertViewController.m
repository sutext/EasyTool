//
//  ETAlertViewController.m
//  EasyTool
//
//  Created by supertext on 16/1/28.
//  Copyright © 2016年 icegent. All rights reserved.
//

#import "ETAlertViewController.h"
@interface ETAlertViewController()

@end
@implementation ETAlertViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    
}
-(UIViewController *)childViewControllerForStatusBarHidden
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}
-(UIViewController *)childViewControllerForStatusBarStyle
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}
@end
