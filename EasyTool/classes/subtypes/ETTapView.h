//
//  ETTapView.h
//  EasyTool
//
//  Created by supertext on 14-6-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_CLASS_AVAILABLE_IOS(7_0)
NS_ASSUME_NONNULL_BEGIN
@interface ETTapView : UIView

@property(nonatomic,copy,nullable)void (^tapAction) (ETTapView *etview);
@property(nonatomic,copy,nullable)void (^doubleTapAction) (ETTapView *etview);

-(void)setTapEnable:(BOOL)enable;
-(void)setDoubleTapEnable:(BOOL)enable;
@end
NS_ASSUME_NONNULL_END