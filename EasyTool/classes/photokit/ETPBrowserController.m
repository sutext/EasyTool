//
//  ETPBrowserController.m
//  EasyTool
//
//  Created by supertext on 15/3/2.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <EasyTools/ETPBrowserController.h>
#import <EasyTools/ETPhotoChildController.h>
#import <EasyTools/ETPhotoBrowser.h>
#import <EasyTools/ETPhotoView.h>
#import <EasyTools/ETPhotoConfig.h>
@interface ETPhotoView(privateMethods)
-(void)__setOriginAnimator;
@end

@interface ETPhotoBrowser (privateMethods)
-(void)__removeSelf;
@property(nonatomic,strong,readonly)UIWindow *browserWindow;
@end

@interface ETPBrowserController ()
@property(nonatomic,weak,readwrite)ETPhotoBrowser *browser;
@end

@interface ETPBrowserController (ETPBrowserController_extends)
@property(nonatomic,strong,readonly)UIView *backgroundView;
@end

@implementation ETPBrowserController
+(BOOL)autoCreateNavigation
{
    return NO;
}
- (instancetype)initWithPhotos:(NSArray *)photos startIndex:(NSUInteger)startIndex
{
    self = [super initWithPhotos:photos startIndex:startIndex];
    if (self) {
        [self.currPage.photoView __setOriginAnimator];
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.backgroundView.alpha=0;
}
-(void)setFullscreen:(BOOL)fullscreen
{
    [super setFullscreen:fullscreen];
    [self.browser setStatusBarHidden:fullscreen];
}
-(void)__setupPhotoBrowser:(ETPhotoBrowser *)browser
{
    self.browser=browser;
}
-(void)prepareForPage:(ETPhotoChildController *)createdPage
{
    createdPage.photoView.autoShrink=YES;
}
-(void)leftItemAction:(id)sender
{
    [self.browser hide];
}
#pragma mark ETPhotoViewDelegate methods
-(void)photoView:(ETPhotoView *)photoView zoomViewDidAppear:(UIImageView *)zoomView originAnimator:(BOOL)isOriginAnimator error:(nullable NSError *)error
{
    if (isOriginAnimator) {
        if (self.toolbarItems.count>0) {
            [self.navigationController setToolbarHidden:NO];
            self.navigationController.toolbar.alpha = 0;
        }
        [UIView animateWithDuration:0.15 animations:^{
            self.navigationController.navigationBar.alpha=1;
            self.navigationController.toolbar.alpha=1;
            self.backgroundView.alpha = 1;
        }];
    }
}
-(void)photoView:(ETPhotoView *)photoView zoomViewWillDisappear:(UIImageView *)zoomView
{
    [UIView animateWithDuration:photoView.config.aniduration animations:^{
        self.navigationController.navigationBar.alpha=0;
        self.navigationController.toolbar.alpha=0;
        self.backgroundView.alpha = 0;
    }];
}
-(void)photoView:(ETPhotoView *)photoView zoomViewDidDisappear:(UIImageView *)zoomView
{
    [self.browser __removeSelf];
}
-(void)photoView:(ETPhotoView *)photoView clickedAtpoint:(CGPoint)point
{
    if (self.browser.didClickedAtindex)
    {
        self.browser.didClickedAtindex(self.currentIndex,photoView.photo,self.browser);
    }
}
-(void)photoView:(ETPhotoView *)photoView scaleAcrossCriticalIncreasing:(BOOL)increasing
{
    if (!increasing) {
        if (self.browser.wannaDismissAtindex)
        {
            self.browser.wannaDismissAtindex(self.currentIndex,photoView.photo,self.browser);
        }
    }
}
-(void)photoView:(ETPhotoView *)photoView zoomingAtscale:(CGFloat)scale increasing:(BOOL)increasing
{
    if (scale<=1) {
        if (!self.isFullscreen) {
            self.navigationController.navigationBar.alpha=scale;
            self.navigationController.toolbar.alpha=scale;
        }
        self.backgroundView.alpha = scale;
    }
}

@end
