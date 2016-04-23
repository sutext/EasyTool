//
//  ETPopoverController.m
//  EasyTool
//
//  Created by supertext on 15/11/6.
//  Copyright © 2015年 icegent. All rights reserved.
//
#import "ETPopoverController.h"
#import <EasyTools/UIView+EasyTools.h>
#import <EasyTools/ETTapView.h>
@interface ETPopoverController()
@property(nonatomic,strong)ETPopoverView *popoverView;
@property(nonatomic,strong)ETPopoverController *strongself;
@property(nonatomic,strong)ETTapView *blurView;
@end
@implementation ETPopoverController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.animationOptions = ETPopoverAnimationOptionsFade;
        self.margin = 0.1;
        self.blurView = [[ETTapView alloc] initWithFrame:CGRectZero];
        self.blurView.backgroundColor = [UIColor clearColor];
        __weak ETPopoverController * weakself = self;
        [self.blurView setTapAction:^(ETTapView * _Nonnull tap) {
            [weakself dismissPopoverAnimated:YES];
        }];
    }
    return self;
}
-(void)presentPopoverFromView:(UIView *)fromView inView:(UIView *)view animated:(BOOL)animated
{
    CGRect rect=[fromView convertRect:fromView.bounds toView:view];
    [self presentPopoverFromRect:rect inView:view animated:animated];
}
-(void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
    if (self.strongself) {
        return;
    }
    self.blurView.frame = view.bounds;
    [view addSubview:self.blurView];
    if (self.delegate&&[self.delegate conformsToProtocol:@protocol(ETPopoverControllerDelegate)]&&[self.delegate respondsToSelector:@selector(popover:setupConfiguration:)]) {
        ETPopoverViewConfig *config = [[ETPopoverViewConfig alloc] init];
        [self.delegate popover:self setupConfiguration:config];
        self.popoverView=[[ETPopoverView alloc] initWithConfig:config];
        
        __weak ETPopoverController *weakself=self;
        [self.popoverView setClickedAtIndex:^(ETPopoverView *pview, NSInteger idx, ETPopoverViewItem * item) {
            [weakself dismissPopoverWithItemIndex:idx animated:YES];
        }];
        CGFloat rectW=rect.size.width;
        CGFloat rectH=rect.size.height;
        CGFloat rectX=rect.origin.x;
        CGFloat rectY=rect.origin.y;
        CGFloat bestPos=[self bestPosationFromRect:rect inView:view];
        self.popoverView.left = bestPos;
        self.popoverView.anchorPosition=rectW/2-(bestPos-rectX);
        
        [view addSubview:self.popoverView];
        CGFloat startTop;
        CGFloat endTop;
        if (config.direction==ETPopoverArrowDirectionDown) {
            startTop = rectY;
            endTop = rectY -self.popoverView.height;
        }
        else
        {
            startTop = rectY+rectH-self.popoverView.height;
            endTop = rectY+rectH;
        }
        if (self.animationOptions&ETPopoverAnimationOptionsFade) {
            self.popoverView.alpha = 0;
        }
        else
        {
            self.popoverView.alpha = 1;
        }
        if (!(self.animationOptions&ETPopoverAnimationOptionsMove)) {
            startTop = endTop;
        }        
        if (animated) {
            self.popoverView.top = startTop;
            [UIView animateWithDuration:0.3 animations:^{
                self.popoverView.top = endTop;
                self.popoverView.alpha = 1;
                self.popoverView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            self.popoverView.top = endTop;
            self.popoverView.alpha = 1;
        }
        self.strongself=self;
    }
}
-(void)dismissPopoverWithItemIndex:(NSInteger)index animated:(BOOL)animated
{
    if (!self.strongself) {
        return;
    }
    ETPopoverViewItem *item = index==NSNotFound?nil:self.popoverView.config.items[index];
    if (self.delegate&&[self.delegate conformsToProtocol:@protocol(ETPopoverControllerDelegate)]&&[self.delegate respondsToSelector:@selector(popover:willDisappearAtIndex:item:)]) {
        [self.delegate popover:self willDisappearAtIndex:index item:item];
    }
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            if (self.animationOptions&ETPopoverAnimationOptionsMove) {
                self.popoverView.top = self.popoverView.config.direction==ETPopoverArrowDirectionDown?self.popoverView.bottom:(self.popoverView.top-self.popoverView.height);
            }
            if (self.animationOptions&ETPopoverAnimationOptionsFade) {
               self.popoverView.alpha = 0;
            }
        } completion:^(BOOL finished) {
            [self.popoverView removeFromSuperview];
            [self.blurView removeFromSuperview];
            self.popoverView=nil;
            if (self.delegate&&[self.delegate conformsToProtocol:@protocol(ETPopoverControllerDelegate)]&&[self.delegate respondsToSelector:@selector(popover:didDisappearAtIndex:item:)]) {
                [self.delegate popover:self didDisappearAtIndex:index item:item];
            }
        }];
    }
    else
    {
        [self.popoverView removeFromSuperview];
        [self.blurView removeFromSuperview];
        self.popoverView=nil;
        if (self.delegate&&[self.delegate conformsToProtocol:@protocol(ETPopoverControllerDelegate)]&&[self.delegate respondsToSelector:@selector(popover:didDisappearAtIndex:item:)]) {
            [self.delegate popover:self didDisappearAtIndex:index item:item];
        }
    }
    self.strongself=nil;
}
-(BOOL)isDisplay
{
    return self.strongself!=nil;
}
-(void)dismissPopoverAnimated:(BOOL)animated
{
    [self dismissPopoverWithItemIndex:NSNotFound animated:animated];
}
-(CGFloat)bestPosationFromRect:(CGRect)rect inView:(UIView *)view
{
    CGFloat popoverWidth=self.popoverView.bounds.size.width;
    CGFloat rectWidth=rect.size.width;
    CGFloat bestPos=rect.origin.x;
    if (popoverWidth<=rectWidth) {
        bestPos+=(rectWidth-popoverWidth)/2;
    }
    else
    {
        bestPos-=(popoverWidth-rectWidth)/2;
        if (bestPos<self.margin) {
            bestPos=self.margin;
        }
        if (bestPos+popoverWidth>view.bounds.size.width-self.margin) {
            bestPos=view.bounds.size.width-self.margin-popoverWidth;
        }
    }
    return bestPos;
}

@end
