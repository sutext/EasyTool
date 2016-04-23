//
//  ETPhotoBrowser.m
//  EasyTool
//
//  Created by supertext on 14/12/15.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETPhotoBrowser.h>
#import <EasyTools/ETPBrowserController.h>

static ETPhotoBrowser *__strong kETPhotoGlobalBrowser;

@interface ETPBrowserController (privateMethods)
-(void)__setupPhotoBrowser:(ETPhotoBrowser *)browser;
@end

@interface ETPhotoBrowser()

@property(nonatomic,strong,readwrite)UIWindow *browserWindow;
@property(nonatomic,strong,readwrite)ETPBrowserController *browserController;

@end
@interface ETPBrowserNavigationController:UINavigationController
@end
@implementation ETPBrowserNavigationController
-(UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}
-(UIViewController *)childViewControllerForStatusBarHidden
{
    return nil;
}
@end
@implementation ETPhotoBrowser
+(BOOL)onlyBrowserExsit
{
    return kETPhotoGlobalBrowser!=nil;
}
-(instancetype)initWithPhotos:(NSArray *)photos startIndex:(NSUInteger)startIndex browservcClass:(__unsafe_unretained Class)browservcClass
{
    self=[super init];
    if (self) {
        if (!(browservcClass&&[browservcClass isSubclassOfClass:[ETPBrowserController class]])) {
            browservcClass=[ETPBrowserController class];
        }
        
        UIWindow *window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.backgroundColor=[UIColor clearColor];
        self.browserWindow=window;
        
        ETPBrowserController *photoContoller=[[browservcClass alloc] initWithPhotos:photos startIndex:startIndex];
        [photoContoller __setupPhotoBrowser:self];
        self.browserController=photoContoller;
        if ([browservcClass autoCreateNavigation]) {
            UINavigationController *nav=[[ETPBrowserNavigationController alloc] initWithRootViewController:photoContoller];
            self.browserWindow.rootViewController=nav;
        }
        else
        {
            self.browserWindow.rootViewController = photoContoller;
        }
    }
    return self;
}
#pragma mark -open methods
-(void)show
{
    if (!kETPhotoGlobalBrowser)
    {
        self.browserWindow.hidden = NO;
        kETPhotoGlobalBrowser=self;
    }
}
-(void)hide
{
    if (self.wannaDismissAtindex)
    {
        self.wannaDismissAtindex(self.browserController.currentIndex,self.browserController.currPage.photoView.photo,self);
    }
    [self.browserController.currPage.photoView hideZoomView];
}
-(void)setStatusBarHidden:(BOOL)hidden
{
    self.browserWindow.windowLevel=UIWindowLevelStatusBar+(hidden?1:-1);
}

#pragma mark -- private action
-(void)__removeSelf
{
    self.browserWindow.hidden = YES;
    if (self.didDismissAtindex) {
        self.didDismissAtindex(self.browserController.currentIndex,self.browserController.currPage.photoView.photo,self);
    }
    kETPhotoGlobalBrowser=nil;
}
@end

