//
//  ETScrollView.h
//  EasyTool
//
//  Created by supertext on 14-6-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETScrollView : UIScrollView
@property(nonatomic,copy,nullable)void (^tapAction)(ETScrollView *scrollView);
@end
NS_ASSUME_NONNULL_END