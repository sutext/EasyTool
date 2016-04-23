//
//  ETPhotoConfig.h
//  EasyTool
//
//  Created by supertext on 15/2/3.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
NS_CLASS_AVAILABLE_IOS(7_0)@interface ETPhotoConfig : NSObject
+(instancetype)defaultConfig;//the default and shared instance.
@property(nonatomic) CGFloat      aniduration;// default is 0.35
@property(nonatomic) CGFloat      maximumZoomScale;// default is 3
@property(nonatomic) CGRect       thumbRect;//the rect of thumb relative to the screen default is 100*100 in center
@property(nonatomic) UIEdgeInsets imageInsets;//default is UIEdgeInsetsZero
@end
NS_ASSUME_NONNULL_END