//
//  ETPhotoViewController.m
//  EasyTool
//
//  Created by supertext on 15/2/6.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <EasyTools/ETPhotoViewController.h>
#import <EasyTools/ETPhotoObject.h>
#import <EasyTools/ETPhotoBrowser.h>
#import <EasyTools/UIImage+EasyTools.h>
#import <EasyTools/UIViewController+EasyTools.h>

@interface ETPhotoViewController()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIViewControllerTransitioningDelegate>

@property(nonatomic,strong,readwrite)NSMutableOrderedSet    *photos;
@property(nonatomic,strong,readwrite)UIView                 *backgroundView;
@property(nonatomic,strong,readwrite)ETPhotoChildController *currPage;
@property(nonatomic,strong,readwrite)ETPhotoChildController *nextPage;
@property(nonatomic,strong,readwrite)ETPhotoChildController *prevPage;
@property(nonatomic,strong)          UIPageViewController   *pageController;
@property(nonatomic,strong)          ETPhotoConfig          *config;
@property(nonatomic,readwrite)       NSUInteger             currentIndex;
@property(nonatomic)                 BOOL                   isTransforming;
@property(nonatomic)                 Class                  photovcClass;

@end

@interface ETPhotoChildController (privateMethods)
-(void)__setPhotoController:(ETPhotoViewController *)photoController;
@end

@implementation ETPhotoViewController
#pragma mark - -lifecircle methods
- (void)dealloc
{
    self.pageController.delegate=nil;
    self.pageController.dataSource=nil;
}
- (instancetype)initWithPhotos:(NSArray<ETPhotoObject *> *)photos startIndex:(NSUInteger)startIndex
{
    self = [super init];
    if (self) {
        NSAssert((photos.count>startIndex&&startIndex>=0),([NSString stringWithFormat:@"startIndex = %zi out off bounds count = %zi!!",startIndex,photos.count]));
        self.backgroundColor                        = [UIColor whiteColor];
        self.config                                 = [[self class] configuration];
        self.photovcClass                           = [[self class] photovcClass];
        self.automaticallyAdjustsScrollViewInsets   = NO;
        NSAssert([self.photovcClass isSubclassOfClass:[ETPhotoChildController class]], @"+[ETPhotoViewController photovcClass] must be kind of ETPhotoChildController class");
        
        self.photos                                 = [NSMutableOrderedSet orderedSetWithArray:photos];
        self.currPage                               = [self createPageAtindex:startIndex];
        self.currentIndex                           = startIndex;
        UIPageViewController *pageController        =[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                                     navigationOrientation:(UIPageViewControllerNavigationOrientation)[[self class] orientation]
                                                                                                   options:nil];
        pageController.delegate                             = self;
        pageController.dataSource                           = self;
        pageController.automaticallyAdjustsScrollViewInsets = NO;
        self.pageController                                 = pageController;
        [self addChildViewController:pageController];
    }
    return self;
}
-(void)loadView
{
    [super loadView];
    UIView *bgview = [[UIView alloc] initWithFrame:self.view.bounds];
    bgview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.backgroundView = bgview;
    [self.view addSubview:bgview];
    [self.view addSubview:self.pageController.view];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor=self.backgroundColor;
    ETNavigationBarItem *item = [ETNavigationBarItem itemWithImage:[UIImage arrowWithColor:[UIColor whiteColor] direction:ETArrowImageDirectionLeft size:CGSizeMake(20, 20) scale:2] selectedImage:nil action:@selector(leftItemAction:)];
    [self setRightBarItems:@[item]];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.pageController.viewControllers.count) {
        [self reloadData];
    }
}
#pragma mark geter and setter
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (_backgroundColor!=backgroundColor)
    {
        _backgroundColor = backgroundColor;
        self.backgroundView.backgroundColor = backgroundColor;
    }
}

-(void)setFullscreen:(BOOL)fullscreen
{
    if (_fullscreen!=fullscreen)
    {
        _fullscreen=fullscreen;
        CGFloat alpha = fullscreen?0:1;
        UIColor *color =fullscreen?[UIColor blackColor]:self.backgroundColor;
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundView.backgroundColor=color;
            self.navigationController.navigationBar.alpha=alpha;
            self.navigationController.toolbar.alpha=alpha;
        }];
    }
}
-(NSOrderedSet *)photoObjects
{
    return self.photos;
}
#pragma interface methods

-(void)scrollTonext:(BOOL)animated
{
    if (self.nextPage) {
        [self showPage:self.nextPage atIndex:self.currentIndex+1 direction:UIPageViewControllerNavigationDirectionForward animated:animated];
    }
}
-(void)scrollToprev:(BOOL)animated
{
    if (self.prevPage) {
        [self showPage:self.prevPage atIndex:self.currentIndex-1 direction:UIPageViewControllerNavigationDirectionReverse animated:animated];
    }
}
-(void)scrollToindex:(NSInteger)index animated:(BOOL)animated
{
    if (index != self.currentIndex&&index<self.photos.count&&index>=0)
    {
        if (index == self.currentIndex-1)
        {
            [self scrollToprev:animated];
        }
        else  if (index == self.currentIndex+1)
        {
            [self scrollTonext:animated];
        }
        else
        {
            UIPageViewControllerNavigationDirection direction = index>self.currentIndex?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse;
            ETPhotoChildController *page = [self createPageAtindex:index];
            [self showPage:page atIndex:index direction:direction animated:animated];
        }
    }
}
-(void)reloadData
{
    [self showPage:self.currPage atIndex:self.currentIndex direction:UIPageViewControllerNavigationDirectionForward animated:NO];
}
-(void)deleteCurrent
{
    [self.photos removeObjectAtIndex:self.currentIndex];
    if (self.photos.count) {
        NSUInteger nIndex = self.currentIndex;
        if (nIndex>self.photos.count-1) {
            self.currentIndex = 0;
            self.currPage = [self createPageAtindex:0];
            [self showPage:self.currPage atIndex:self.currentIndex direction:UIPageViewControllerNavigationDirectionReverse animated:YES];
        }
        else
        {
            self.currPage = self.nextPage;
            self.nextPage = [self createPageAtindex:self.currentIndex+1];
            [self.nextPage.photoView preloadImage];
            [self willtransmitToPage:self.currPage toIndex:self.currentIndex];
            __weak ETPhotoViewController * weakself = self;
            [self.pageController setViewControllers:@[self.currPage] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                [weakself didTransmitFromPage:weakself.currPage fromIndex:weakself.currentIndex toPage:weakself.currPage toIndex:weakself.currentIndex];
            }];
        }
    }
    else
    {
        [self leftItemAction:nil];
    }
}
-(void)appendPhotos:(NSArray<ETPhotoObject *> *)photos
{
    if (photos.count>0) {
        NSUInteger originCount = self.photos.count;
        [self.photos addObjectsFromArray:photos];
        if (self.currentIndex == originCount-1) {
            self.nextPage = [self createPageAtindex:originCount];
            [self.nextPage.photoView preloadImage];
        }
    }
}
-(void)insertPhotos:(NSArray<ETPhotoObject *> *)photos
{
    NSUInteger addCount =photos.count;
    if (addCount>0) {
        [self.photos insertObjects:photos atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, addCount)]];
        self.currentIndex +=addCount;
        if (self.currentIndex-addCount == 0) {
            self.prevPage = [self createPageAtindex:addCount-1];
            [self.prevPage.photoView preloadImage];
        }
    }
}
#pragma mark --  private methods
-(void)willtransmitToPage:(ETPhotoChildController *)toPage toIndex:(NSInteger)toIndex
{
    [self willTransmitFromPage:self.currPage fromIndex:self.currentIndex toPage:toPage toIndex:toIndex];
}
-(void)showPage:(ETPhotoChildController *)page atIndex:(NSInteger)index direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated
{
    __weak ETPhotoViewController * weakself = self;
    [self willtransmitToPage:page toIndex:index];
    [self.pageController setViewControllers:@[page] direction:direction animated:animated completion:^(BOOL finished) {
        [weakself rebuildWithPage:page atIndex:index];
    }];
}
-(ETPhotoChildController *)createPageAtindex:(NSInteger)index
{
    if (index<self.photos.count&&index>=0) {
        ETPhotoChildController *photovc=[[self.photovcClass alloc] initWithPhoto:[self.photos objectAtIndex:index] config:self.config];
        [photovc __setPhotoController:self];
        [self prepareForPage:photovc];
        return photovc;
    }
    return nil;
}
-(void)rebuildWithPage:(ETPhotoChildController *)page atIndex:(NSInteger)index
{
    NSUInteger fromIndex=self.currentIndex;
    ETPhotoChildController *fromPage = self.currPage;
    if (page==self.nextPage)
    {
        self.prevPage = fromPage;
        self.nextPage = [self createPageAtindex:index+1];
        [self.nextPage.photoView preloadImage];
    }
    else if (page == self.prevPage)
    {
        self.nextPage = fromPage;
        self.prevPage = [self createPageAtindex:index-1];
        [self.prevPage.photoView preloadImage];
    }
    else
    {
        self.nextPage = [self createPageAtindex:index+1];
        self.prevPage = [self createPageAtindex:index-1];
        [self.nextPage.photoView preloadImage];
        [self.prevPage.photoView preloadImage];
    }
    self.currPage=page;
    self.currentIndex=index;
    [self didTransmitFromPage:fromPage fromIndex:fromIndex toPage:self.currPage toIndex:self.currentIndex];
}
#pragma mark - - abstractMethods
+(Class)photovcClass
{
    return [ETPhotoChildController class];
}
+(ETPhotoConfig *)configuration
{
    return nil;
}
+(ETPhotoViewScrollOrientation)orientation
{
    return ETPhotoViewScrollOrientationHorizontal;
}
-(void)leftItemAction:(nullable id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightItemAction:(id)sender
{
    
}

-(void)prepareForPage:(ETPhotoChildController *)createdPage
{

}
-(void)willTransmitFromPage:(ETPhotoChildController *)fromPage fromIndex:(NSUInteger)fromIndex toPage:(ETPhotoChildController *)toPage toIndex:(NSUInteger)toIndex
{

}
-(void)didTransmitFromPage:(ETPhotoChildController *)fromPage fromIndex:(NSUInteger)fromIndex toPage:(ETPhotoChildController *)toPage toIndex:(NSUInteger)toIndex
{

}
#pragma mark UIPageViewController methods
-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    self.isTransforming=YES;
    ETPhotoChildController *toPage  = pendingViewControllers.firstObject;
    NSInteger index = [self.photos indexOfObject:toPage.photoView.photo];
    [self willtransmitToPage:toPage toIndex:index];
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (finished)
    {
        if (completed)
        {
            ETPhotoChildController *toPage  = pageViewController.viewControllers.firstObject;
            NSInteger index = [self.photos indexOfObject:toPage.photoView.photo];
            [self rebuildWithPage:pageViewController.viewControllers.firstObject atIndex:index];
        }
        self.isTransforming=NO;
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (!self.isTransforming)
    {
        return self.prevPage;
    }
    return nil;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (!self.isTransforming)
    {
        return self.nextPage;
    }
    return nil;
}
@end
