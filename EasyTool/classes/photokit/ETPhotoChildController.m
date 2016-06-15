//
//  ETPhotoChildController.m
//  EasyTool
//
//  Created by supertext on 15/1/16.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <EasyTools/ETPhotoChildController.h>
#import <EasyTools/ETPhotoViewController.h>
#import <EasyTools/ETPhotoObject.h>

@interface ETPhotoChildController ()
@property(nonatomic,strong,readwrite)ETPhotoView *photoView;
@property(nonatomic,weak,readwrite)ETPhotoViewController *photoController;
@end

@interface ETPhotoView(privateMethods_ETPhotoChildController)
-(void)__setDelegate:(id<ETPhotoViewDelegate>)delegate;
-(void)__setAnimationStateChangedBlock:(void (^)(ETPhotoView *, BOOL))animationStateChangedBlock;
@end

@implementation ETPhotoChildController
- (instancetype)initWithPhoto:(ETPhotoObject *)photo config:(ETPhotoConfig *)config
{
    self = [super init];
    if (self)
    {
        ETPhotoView *photoView=[[ETPhotoView alloc] initWithPhoto:photo config:config];
        [photoView __setDelegate:self];
        __weak ETPhotoChildController *weakself = self;
        [photoView __setAnimationStateChangedBlock:^(ETPhotoView *sender, BOOL animating) {
            weakself.view.userInteractionEnabled=!animating;
            weakself.photoController.view.userInteractionEnabled=!animating;
        }];
        self.photoView=photoView;
    }
    return self;
}
-(void)__setPhotoController:(ETPhotoViewController *)photoController
{
    self.photoController = photoController;
}
-(void)setPhotoController:(ETPhotoViewController *)photoController
{
    if (_photoController!=photoController) {
        _photoController=photoController;
        if (photoController) {
            [self.photoView __setDelegate:photoController];
        }
    }
}
-(UINavigationController *)navigationController
{
    if (self.photoController) {
        return self.photoController.navigationController;
    }
    else
    {
        return [super navigationController];
    }
}
-(void)loadView
{
    [super loadView];
    [self.view addSubview:self.photoView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.photoView showZoomView];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.photoView restoreAnimated:NO];
}
@end
