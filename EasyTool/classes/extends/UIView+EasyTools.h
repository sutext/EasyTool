//
//  UIView+easyTools.h
//  EasyTool
//
//  Created by supertext on 14-6-6.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (EasyTools)
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;
- (UIViewController*) belongedController;//the controller of itself belong to .return nil if the controller do not exsist
@end

NS_ASSUME_NONNULL_END