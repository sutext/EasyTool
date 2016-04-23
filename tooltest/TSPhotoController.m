//
//  TSPhotoController.m
//  EasyTool
//
//  Created by supertext on 15/2/10.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import "TSPhotoController.h"

@implementation TSPhotoController
+(ETPhotoViewScrollOrientation)orientation
{
    return ETPhotoViewScrollOrientationVertical;
}
-(void)leftItemAction:(id)sender
{
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[UINavigationController class], nil];
    [bar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)]];
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    [super leftItemAction:sender];
}
@end
