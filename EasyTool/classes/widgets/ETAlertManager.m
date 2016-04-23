//
//  ETAlertManager.m
//  EasyTool
//
//  Created by supertext on 14-6-10.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETAlertManager.h>
#import <EasyTools/ETalertController.h>
#import <EasyTools/EasyTool.h>
#import <EasyTools/ETGlobalContainer.h>
#define kETAlertAniDuration .3

@interface ETAlertManager()<UIAlertViewDelegate>

@property(nonatomic,strong) ETAlertController     *waitView;
@property(nonatomic,strong) ETAlertController     *iconView;
@property(nonatomic,strong) UIAlertController     *alertView;
@property(atomic) BOOL isAlerting;
@end

@implementation ETAlertManager

#pragma mark - ETAlertManager + lifeCycle

-(BOOL)canshowAlert
{
    @synchronized(self)
    {
        if (!self.isAlerting) {
            self.isAlerting=YES;
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

#pragma mark - usefull methods
-(void)showWaitingMessage:(NSString *)message
           appearComplete:(void (^)(UIView *alertView)) appearComplete
                 canceled:(void (^)(UIView *))cancelBlock
{
    [self showWaitingMessage:message waitStyle:ETAlertWaitStyleChrysanthemum appearComplete:appearComplete canceled:cancelBlock];
}
-(void)showWaitingMessage:(NSString *)message
                waitStyle:(ETAlertWaitStyle)waitStyle
           appearComplete:(void (^)(UIView *alertView)) appearComplete
                 canceled:(void (^)(UIView *))cancelBlock
{
    if ([self canshowAlert]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.waitView) {
                __weak ETAlertManager *weakself=self;
                self.waitView=[ETAlertController waitViewWithMessage:message style:waitStyle hideBlock:^(UIView *delicon) {
                    delicon.userInteractionEnabled=NO;
                    [weakself hideWaiting:cancelBlock];
                }];
                self.waitView.alpha=0;
                self.waitView.hidden=NO;
                [self.waitView startAnimation];
                [UIView animateWithDuration:kETAlertAniDuration animations:^{
                    self.waitView.alpha=1;
                } completion:^(BOOL finished) {
                    if (appearComplete!=NULL) {
                        appearComplete(self.waitView.blurView);
                    }
                }];
            }
        });
    }
}
-(void)hideWaiting:(void (^)(UIView *))hideBlock
{
    if (self.waitView&&self.waitView.alpha==1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:kETAlertAniDuration animations:^{
                self.waitView.alpha=0;
            } completion:^(BOOL finished) {
                [self.waitView stopAnimation];
                self.waitView.hidden = YES;
                self.isAlerting=NO;
                
                if (hideBlock!=NULL) {
                    hideBlock(self.waitView.blurView);
                }
                self.waitView=nil;
                
            }];
        });
    }
}

-(void)showIconMessage:(NSString *)message iconStyle:(ETAlertIconStyle)iconStyle hideComplete:(void (^)(UIView *))hideComplete
{
    [self showIconMessage:message iconStyle:iconStyle duration:1.0 hideComplete:hideComplete];
}
-(void)showIconMessage:(NSString *)message
             iconStyle:(ETAlertIconStyle)iconStyle
              duration:(double)duration
          hideComplete:(void (^)(UIView *alertView))hideComplete
{
    if ([self canshowAlert]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.iconView) {
                self.iconView=[ETAlertController iconViewWithMessage:message style:iconStyle];
                CGFloat dur=duration;
                if (duration<0.5) {
                    dur=0.5;
                }
                self.iconView.hidden=NO;
                self.iconView.alpha=0;
                [UIView animateWithDuration:kETAlertAniDuration animations:^{
                    self.iconView.alpha=1;
                } completion:^(BOOL finished) {
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dur * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [UIView animateWithDuration:kETAlertAniDuration animations:^{
                            self.iconView.alpha=0;
                        } completion:^(BOOL finished) {
                            self.iconView.hidden=YES;
                            self.isAlerting=NO;
                            if (hideComplete!=NULL) {
                                hideComplete(self.iconView.blurView);
                            }
                            self.iconView=nil;
                        }];
                    });
                }];
            }
        });
    }
}
-(void)showAlertWihtTitle:(NSString *)title
                  message:(NSString *)message
        cancelButtonTitle:(NSString *)cancelTitle
         otherButtonTitle:(NSString *)otherTitle
          onHiddenAtIndex:(void (^)(UIAlertController *alertView,NSInteger index))hiddenIndex
{
    if ([self canshowAlert]) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (!self.alertView) {
                self.alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                __weak ETAlertManager *weakself = self;
                if (cancelTitle) {
                    [self.alertView addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        weakself.isAlerting = NO;
                        if (hiddenIndex) {
                            hiddenIndex(weakself.alertView,0);
                        }
                        weakself.alertView=nil;
                    }]];
                }
                if (otherTitle) {
                    [self.alertView addAction:[UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        weakself.isAlerting=NO;
                        if (hiddenIndex) {
                            hiddenIndex(weakself.alertView,1);
                        }
                        weakself.alertView=nil;
                    }]];
                }
                UIViewController *root = [[UIApplication sharedApplication] keyWindow].rootViewController;
                if (root.presentingViewController)
                {
                    self.isAlerting=NO;
                    self.alertView=nil;
                }
                else if (root.presentedViewController) {
                    [root.presentedViewController presentViewController:self.alertView animated:YES completion:nil];
                }
                else
                {
                    [root presentViewController:self.alertView animated:true completion:nil];
                }
            }
        });
    }
}

@end
