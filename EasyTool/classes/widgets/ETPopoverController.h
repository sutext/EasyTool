//
//  ETPopoverController.h
//  EasyTool
//
//  Created by supertext on 15/11/6.
//  Copyright © 2015年 icegent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EasyTools/ETPopoverView.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSInteger, ETPopoverAnimationOptions) {
    ETPopoverAnimationOptionsNone = 0,
    ETPopoverAnimationOptionsFade = 1,
    ETPopoverAnimationOptionsMove = 2,
};

@protocol ETPopoverControllerDelegate;

NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETPopoverController : NSObject
@property(nonatomic,weak,nullable)id<ETPopoverControllerDelegate> delegate;
@property(nonatomic)ETPopoverAnimationOptions animationOptions;
@property(nonatomic)NSUInteger margin;
@property(nonatomic,readonly,getter=isDisplay)BOOL display;
-(void)presentPopoverFromView:(UIView *)fromView inView:(UIView *)view animated:(BOOL)animated;
-(void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
-(void)dismissPopoverAnimated:(BOOL)animated;
@end

NS_CLASS_AVAILABLE_IOS(7_0)
@protocol ETPopoverControllerDelegate <NSObject>
@required
-(void)popover:(ETPopoverController *)popover setupConfiguration:(ETPopoverViewConfig *)config;
@optional
-(void)popover:(ETPopoverController *)popover willDisappearAtIndex:(NSInteger)index item:(nullable ETPopoverViewItem *)item;
-(void)popover:(ETPopoverController *)popover didDisappearAtIndex:(NSInteger)index item:(nullable ETPopoverViewItem *)item;
@end
NS_ASSUME_NONNULL_END