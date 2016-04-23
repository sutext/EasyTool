//
//  ETPhotoView.m
//  EasyTool
//
//  Created by supertext on 15/1/16.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <EasyTools/ETPhotoView.h>
#import <EasyTools/ETImageView.h>
#import <EasyTools/ETPhotoObject.h>
#import <EasyTools/EasyTool.h>
#import <EasyTools/ETPhotoConfig.h>
#import <EasyTools/UIView+EasyTools.h>
#import <EasyTools/UIImage+EasyTools.h>
@interface ETPhotoObject(privateMethods)
-(CGRect)__originalRect;
@end

@interface ETPhotoView()<UIScrollViewDelegate>

@property(nonatomic,strong)                 UILongPressGestureRecognizer* longPressGes;
@property(nonatomic,strong)                 UITapGestureRecognizer      * singleTapGes;
@property(nonatomic,strong)                 ETImageView                 * imageView;
@property(nonatomic,strong)                 ETImageView                 * thumbView;
@property(nonatomic,strong)                 UIScrollView                * scroolView;
@property(nonatomic,strong)                 UIView                      * blackBG;
@property(nonatomic,strong)                 UIActivityIndicatorView     * indicator;
@property(nonatomic,strong,readwrite)       ETPhotoConfig               * config;
@property(nonatomic,strong,readwrite)       ETPhotoObject               * photo;
@property(nonatomic,weak,  readwrite)       id<ETPhotoViewDelegate>     delegate;
@property(nonatomic)                        CGFloat                     perfacetScale;
@property(nonatomic)                        CGFloat                     lastScale;
@property(nonatomic)                        CGFloat                     zoomScale;
@property(nonatomic)                        BOOL                        callThroughOnce;
@property(nonatomic,getter=isAnimating)     BOOL                        animating;
@property(nonatomic,getter=isOriginAnimator)BOOL                        originAnimator;
@property(nonatomic,copy)                   void (^animationStateChangedBlock)(ETPhotoView *sender,BOOL isAnimating);

@end

@implementation ETPhotoView
{
    struct {
        unsigned int zoomViewWillAppear:1;
        unsigned int zoomViewDidAppear:1;
        unsigned int zoomViewWillDisappear:1;
        unsigned int zoomViewDidDisappear:1;
        unsigned int longPressedAtpoint : 1;
        unsigned int clickedAtpoint : 1;
        unsigned int scaleAcrossCriticalIncreasing : 1;
        unsigned int zoomCompletedAtscale : 1;
        unsigned int zoomingAtscale : 1;
    } _delegateHas;
}
- (void)dealloc
{
    self.scroolView.delegate=nil;
}
- (id)initWithPhoto:(ETPhotoObject *)photo config:(ETPhotoConfig *)config
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        NSParameterAssert(photo);
        //init
        self.config=config?config:[ETPhotoConfig defaultConfig];
        self.perfacetScale=1;
        self.lastScale=1;
        self.zoomScale=1;
        self.photo=photo;
        self.zoomEnable=YES;
        self.backgroundColor=[UIColor clearColor];
        //thumb image view
        ETImageView *thumbView      = [[ETImageView alloc] initWithFrame:self.config.thumbRect];
        thumbView.contentMode       = UIViewContentModeScaleAspectFill;
        thumbView.backgroundColor   = [UIColor clearColor];
        self.thumbView              = thumbView;
        thumbView.clipsToBounds     = YES;
        [self addSubview:thumbView];
        
        //scroolView
        UIScrollView *scroolView                    = [[UIScrollView alloc] initWithFrame:self.bounds];
        scroolView.delegate                         = self;
        scroolView.minimumZoomScale                 = 0.5;
        scroolView.maximumZoomScale                 = self.config.maximumZoomScale;
        scroolView.showsHorizontalScrollIndicator   = NO;
        scroolView.showsVerticalScrollIndicator     = NO;
        scroolView.backgroundColor                  = [UIColor clearColor];
        self.scroolView                             = scroolView;
        [self addSubview:scroolView];
        
        // image view
        ETImageView *imageView      = [[ETImageView alloc] initWithFrame:CGRectZero];
        imageView.backgroundColor   = [UIColor clearColor];
        imageView.contentMode       = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds     = YES;
        self.imageView              = imageView;
        [self.scroolView addSubview:imageView];
        
        //gesture
        UITapGestureRecognizer *doubleTap   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired      = 2;
        [self addGestureRecognizer:doubleTap];
        
        //preload thumb
        if (photo.photoType==ETPhotoObjectTypeLocal) {
            thumbView.image=photo.thumb;
            imageView.image= photo.image;
            [self resizeWithImage:photo.image];
            [self setImageViewHidden:NO];
            thumbView.frame=self.imageView.frame;
        }
        else
        {
            [self setImageViewHidden:YES];
            [self setThumbCompleted:nil];
        }
    }
    return self;
}
#pragma mark interface methods

-(void)setDelegate:(id<ETPhotoViewDelegate>)delegate
{
    if (_delegate!=delegate)
    {
        _delegate=delegate;
        if (delegate&&[delegate conformsToProtocol:@protocol(ETPhotoViewDelegate)])
        {
            _delegateHas.zoomViewWillAppear             = [delegate respondsToSelector:@selector(photoView:zoomViewWillAppear:originAnimator:)];
            _delegateHas.zoomViewDidAppear              = [delegate respondsToSelector:@selector(photoView:zoomViewDidAppear:originAnimator:error:)];
            _delegateHas.zoomViewWillDisappear          = [delegate respondsToSelector:@selector(photoView:zoomViewWillDisappear:)];
            _delegateHas.zoomViewDidDisappear           = [delegate respondsToSelector:@selector(photoView:zoomViewDidDisappear:)];
            _delegateHas.longPressedAtpoint             = [delegate respondsToSelector:@selector(photoView:longPressedAtpoint:)];
            _delegateHas.clickedAtpoint                 = [delegate respondsToSelector:@selector(photoView:clickedAtpoint:)];
            _delegateHas.scaleAcrossCriticalIncreasing  = [delegate respondsToSelector:@selector(photoView:scaleAcrossCriticalIncreasing:)];
            _delegateHas.zoomCompletedAtscale           = [delegate respondsToSelector:@selector(photoView:zoomCompletedAtscale:)];
            _delegateHas.zoomingAtscale                 = [delegate respondsToSelector:@selector(photoView:zoomingAtscale:increasing:)];
            if (_delegateHas.clickedAtpoint)
            {
                [self addGestureRecognizer:self.singleTapGes];
            }
            else
            {
                [self removeGestureRecognizer:self.singleTapGes];
            }
        }
        else
        {
            _delegateHas.zoomViewWillAppear             = 0;
            _delegateHas.zoomViewDidAppear              = 0;
            _delegateHas.zoomViewWillDisappear          = 0;
            _delegateHas.zoomViewDidDisappear           = 0;
            _delegateHas.longPressedAtpoint             = 0;
            _delegateHas.clickedAtpoint                 = 0;
            _delegateHas.scaleAcrossCriticalIncreasing  = 0;
            _delegateHas.zoomCompletedAtscale           = 0;
            _delegateHas.zoomingAtscale                 = 0;
            [self removeGestureRecognizer:self.singleTapGes];
        }
    }
}
-(BOOL)isZooming
{
    return self.scroolView.isZooming;
}
-(UIImage *)image
{
    return self.imageView.image;
}
-(void)setZoomEnable:(BOOL)zoomEnable
{
    [self setZoomEnable:zoomEnable restore:NO animated:NO];
}
-(void)setZoomEnable:(BOOL)zoomEnable restore:(BOOL)restore animated:(BOOL)animated
{
    if (_zoomEnable!=zoomEnable) {
        if (!zoomEnable) {
            if (restore) {
                [self restoreAnimated:animated];
            }
        }
        _zoomEnable=zoomEnable;
    }
}
-(void)restoreAnimated:(BOOL)animated
{
    [self.scroolView setZoomScale:1 animated:animated];
}
-(void)preloadImage
{
    __weak ETPhotoView *weakself=self;
    [self setImageCompleted:^(NSError *error) {
        if (!error) {
            [weakself setImageViewHidden:NO];
            weakself.thumbView.frame=weakself.imageView.frame;
        }
    }];
}
#pragma mark private methods
-(void)setAnimating:(BOOL)animating
{
    if (_animating!=animating) {
        _animating = animating;
        self.userInteractionEnabled=!animating;
        if (self.animationStateChangedBlock) {
            self.animationStateChangedBlock(self,animating);
        }
    }
}
-(void)__setOriginAnimator
{
    self.originAnimator=YES;
    self.thumbView.frame=[self photoOriginalRect];
    [self setImageViewHidden:YES];
}
-(void)__setDelegate:(id<ETPhotoViewDelegate>)delegate
{
    self.delegate=delegate;
}
-(void)__setAnimationStateChangedBlock:(void (^)(ETPhotoView *, BOOL))animationStateChangedBlock
{
    self.animationStateChangedBlock=animationStateChangedBlock;
}
-(void)resizeWithImage:(UIImage *)image
{
    CGRect  imageBounds     = UIEdgeInsetsInsetRect([UIScreen mainScreen].bounds, self.config.imageInsets);
    CGFloat boundsWidth     = imageBounds.size.width;
    CGFloat boundsHeight    = imageBounds.size.height;
    CGFloat boundsTop       = imageBounds.origin.y;
    CGFloat boundsLeft      = imageBounds.origin.x;
    
    CGSize  imageSize       = image.size;
    CGFloat imageWidth      = imageSize.width;
    CGFloat imageHeight     = imageSize.height;
    
    CGRect rect;
    if (imageHeight/imageWidth<=boundsHeight/boundsWidth) {
        CGFloat newHeight=imageHeight * boundsWidth / imageWidth;
        self.perfacetScale=boundsHeight/newHeight;
        rect= CGRectMake(boundsLeft, ABS(boundsHeight-newHeight)/2+boundsTop, boundsWidth, newHeight);
    }
    else
    {
        CGFloat newWidth=imageWidth*boundsHeight/imageHeight;
        self.perfacetScale=boundsWidth/newWidth;
        rect= CGRectMake(ABS(boundsWidth-newWidth)/2+boundsLeft, +boundsTop, newWidth, boundsHeight);
    }
    self.imageView.frame=rect;
}
-(void)setImageCompleted:(void (^)(NSError *error))completedBlock
{
    switch (self.photo.photoType) {
        case ETPhotoObjectTypeAlbum:
        {
            [[self imageView] setImageWithAsset:self.photo.asset placeholder:nil completedBlock:^(UIImage *image, NSError *error) {
                if (!error&&image) {
                    [self resizeWithImage:image];
                }
                if (completedBlock) {
                    completedBlock(error);
                }
            }];
        } break;
        case ETPhotoObjectTypeRemote:
        {
            [[self imageView] setImageWithURL:self.photo.imageURL placeholder:nil completedBlock:^(UIImage * _Nullable image, NSError * _Nullable error, ETImageView * _Nonnull imageView) {
                if (!error&&image)
                {
                    [self resizeWithImage:image];
                }
                if (completedBlock) {
                    completedBlock(error);
                }
            }];
        } break;
        default:
        {
            if (completedBlock)
            {
                completedBlock(nil);
            }
        }break;
    }
}
-(void)setThumbCompleted:(void (^)(NSError *error))completedBlock
{
    switch (self.photo.photoType) {
        case ETPhotoObjectTypeAlbum:
        {
            [self.thumbView setThumbWithAsset:self.photo.asset placeholder:nil targetSize:self.thumbView.frame.size completedBlock:^(UIImage *image, NSError *error) {
                if (completedBlock) {
                    completedBlock(error);
                }
            }];
        } break;
        case ETPhotoObjectTypeRemote:
        {
            [[self thumbView] setImageWithURL:self.photo.thumbURL placeholder:nil completedBlock:^(UIImage * _Nullable image, NSError * _Nullable error, ETImageView * _Nonnull imageView) {
                if (completedBlock) {
                    completedBlock(error);
                }
            }];
        } break;
        default:
        {
            if (completedBlock) {
                completedBlock(nil);
            }
        }break;
    }
}

-(void)setImageViewHidden:(BOOL)hidden
{
    self.imageView.hidden=hidden;
    self.thumbView.hidden=!hidden;
}
-(CGRect)photoOriginalRect
{
    CGRect rect = [self.photo __originalRect];
    if (!CGRectIsEmpty(rect)) {
        return rect;
    }
    return self.config.thumbRect;
}
#pragma mark animation suport
-(void)showZoomView
{
    if (!self.isAnimating)
    {
        [self zoomViewWillAppear];
        if (!self.imageView.image)
        {
            __weak ETPhotoView *weakself=self;
            [self startAnimating];
            [self setImageCompleted:^(NSError *error)
             {
                [weakself stopAnimating];
                if (error)
                {
                    [weakself zoomviewDidAppear:error];
                }
                else
                {
                    [weakself startZoomAnimating];
                }
            }];
        }
        else
        {
            if (self.isOriginAnimator)
            {
                [self startZoomAnimating];
            }
            else
            {
                [self zoomviewDidAppear:nil];
            }
        }
    }
}

-(void)startZoomAnimating
{
    CGRect rect=self.imageView.frame;
    [UIView animateWithDuration:self.config.aniduration animations:^{
        self.thumbView.frame=rect;
    } completion:^(BOOL finished) {
        [self setImageViewHidden:NO];
        [self zoomviewDidAppear:nil];
    }];
}

-(void)zoomViewWillAppear
{
    self.animating=YES;
    if (_delegateHas.zoomViewWillAppear)
    {
        [self.delegate photoView:self zoomViewWillAppear:self.imageView originAnimator:self.isOriginAnimator];
    }
}

-(void)zoomviewDidAppear:(NSError *)error
{
    if (_delegateHas.zoomViewDidAppear)
    {
        [self.delegate photoView:self zoomViewDidAppear:self.imageView originAnimator:self.isOriginAnimator error:nil];
    }
    self.originAnimator=NO;
    self.animating=NO;
}

-(void)hideZoomView
{
    if (!self.isAnimating)
    {
        [self zoomViewWillDisapear];
        [self restoreAnimated:NO];
        [self setImageViewHidden:YES];
        CGRect originalRect = [self photoOriginalRect];
        [UIView animateWithDuration:self.config.aniduration animations:^{
            self.thumbView.frame=originalRect;
        } completion:^(BOOL finished) {
            [self zoomViewDidDisappear];
        }];
    }
}

-(void)zoomViewWillDisapear
{
    self.animating=YES;
    if (_delegateHas.zoomViewWillDisappear)
    {
        [self.delegate photoView:self zoomViewWillDisappear:self.imageView];
    }
}

-(void)zoomViewDidDisappear
{
    if (_delegateHas.zoomViewDidDisappear)
    {
        [self.delegate photoView:self zoomViewDidDisappear:self.imageView];
    }
    self.animating=NO;
}

-(UIView *)blackBG
{
    if (!_blackBG)
    {
        UIView *graybg=[[UIView alloc] initWithFrame:self.thumbView.bounds];
        graybg.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        graybg.backgroundColor=[UIColor colorWithWhite:0 alpha:0.3];
        self.blackBG=graybg;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center=CGPointMake(self.thumbView.frame.size.width/2, self.thumbView.frame.size.height/2);
        self.indicator=indicator;
        [self.blackBG addSubview:indicator];
    }
    return _blackBG;
}

-(void)startAnimating
{
    [self.thumbView addSubview:self.blackBG];
    self.blackBG.frame=self.thumbView.bounds;
    self.indicator.center=CGPointMake(self.thumbView.frame.size.width/2, self.thumbView.frame.size.height/2);
    [self.indicator startAnimating];
}

-(void)stopAnimating
{
    [self.indicator stopAnimating];
    [self.blackBG removeFromSuperview];
}

#pragma mark user action function
-(UITapGestureRecognizer *)singleTapGes
{
    if (!_singleTapGes)
    {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        self.singleTapGes=singleTap;
    }
    return _singleTapGes;
}

-(UILongPressGestureRecognizer *)longPressGes
{
    if (!_longPressGes)
    {
        UILongPressGestureRecognizer *longpresse=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        self.longPressGes=longpresse;
    }
    return _longPressGes;
}

-(void)setLongpressEnable:(BOOL)longpressEnable
{
    if (_longpressEnable!=longpressEnable)
    {
        _longpressEnable=longpressEnable;
        if (longpressEnable) {
            [self addGestureRecognizer:self.longPressGes];
        }
        else
        {
            [self removeGestureRecognizer:self.longPressGes];
        }
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    if (_delegateHas.clickedAtpoint)
    {
        [self performSelector:@selector(singleTapAction:) withObject:[NSValue valueWithCGPoint:[tap locationInView:self]] afterDelay:0.2];
    }
}

-(void)singleTapAction:(NSValue *)sender
{
    [self.delegate photoView:self clickedAtpoint:[sender CGPointValue]];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction:) object:nil];
    CGPoint touchPoint = [tap locationInView:self];
    if (self.scroolView.zoomScale == self.scroolView.maximumZoomScale)
    {
        [self.scroolView setZoomScale:1 animated:YES];
    }
    else
    {
        [self.scroolView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

-(void)longPressAction:(UILongPressGestureRecognizer *)sender

{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        if (_delegateHas.longPressedAtpoint)
        {
            [self.delegate photoView:self longPressedAtpoint:[sender locationInView:self]];
        }
    }
}

#pragma mark UIScrollView methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (self.isZoomEnable)
    {
        return  self.imageView;
    }
    return nil;
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    self.callThroughOnce=YES;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scale<1)
    {
        if (self.canAutoShrink&&self.zoomScale<self.lastScale)
        {
            if (!self.isAnimating) {
                [self zoomViewWillDisapear];
                CGRect originalRect = [self photoOriginalRect];
                [UIView animateWithDuration:self.config.aniduration animations:^{
                    self.imageView.frame=originalRect;
                } completion:^(BOOL finished) {
                    [self zoomViewDidDisappear];
                }];
            }
        }
        else
        {
            [self restoreAnimated:YES];
        }
    }
    else
    {
        if (_delegateHas.zoomCompletedAtscale)
        {
            [self.delegate photoView:self zoomCompletedAtscale:scale];
        }
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    CGFloat contentWidth = scrollView.contentSize.width;
    CGFloat contentHeight = scrollView.contentSize.height;
    if (contentWidth > scrollView.frame.size.width)
    {
        xcenter=contentWidth/2;
    }
    if (contentHeight> scrollView.frame.size.height)
    {
        ycenter=contentHeight/2;
    }
    self.imageView.center=CGPointMake(xcenter, ycenter);
    CGFloat newscale = self.scroolView.zoomScale;
    BOOL increasing =(self.zoomScale<newscale);
    self.lastScale=self.zoomScale;
    self.zoomScale=newscale;
    if (_delegateHas.zoomingAtscale)
    {
        [self.delegate photoView:self zoomingAtscale:newscale increasing:increasing];
    }
    if (self.zoomScale<1&&self.callThroughOnce)
    {
        self.callThroughOnce=NO;
        if (_delegateHas.scaleAcrossCriticalIncreasing)
        {
            [self.delegate photoView:self scaleAcrossCriticalIncreasing:NO];
        }
    }
    else if (self.zoomScale>1&&!self.callThroughOnce)
    {
        self.callThroughOnce=YES;
        if (_delegateHas.scaleAcrossCriticalIncreasing)
        {
            [self.delegate photoView:self scaleAcrossCriticalIncreasing:YES];
        }
    }
}
@end
