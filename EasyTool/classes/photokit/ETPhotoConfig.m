//
//  ETPhotoConfig.m
//  EasyTool
//
//  Created by supertext on 15/2/3.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <EasyTools/ETPhotoConfig.h>
#import <EasyTools/EasyTool.h>

@implementation ETPhotoConfig
+(instancetype)defaultConfig
{
    static dispatch_once_t onceToken = 0;
    static ETPhotoConfig *_defaultConfig;
    dispatch_once(&onceToken, ^{
        _defaultConfig = [[super allocWithZone:nil] init];
    });
    return _defaultConfig;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.aniduration=0.35;
        self.imageInsets=UIEdgeInsetsZero;
        self.maximumZoomScale=3;
        self.thumbRect=CGRectMake(kETScreenWith/2-50, kETScreenHeight/2-50, 100, 100);
    }
    return self;
}
@end
