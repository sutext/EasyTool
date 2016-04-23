//
//  ETRefreshControl.m
//  EasyTool
//
//  Created by supertext on 14/11/24.
//  Copyright (c) 2014年 icegent. All rights reserved.
//
#import <EasyTools/ETRefreshControl.h>
#import <EasyTools/EasyTool.h>
#import <EasyTools/UIView+EasyTools.h>
#define kETRefreshControlHeight 60
#define kETRefreshAniDuration 0.25
typedef NS_ENUM(NSInteger, ETRefreshState) {
    ETRefreshStateNormal,
    ETRefreshStatePulling,
    ETRefreshStateRefreshing
};

@interface ETRefreshControl()
@property (nonatomic) CGFloat progress;
@property (nonatomic) CGFloat viewHeight;
@property (nonatomic)ETRefreshState refreshState;
@property (nonatomic,weak)UIScrollView *scrollView;
@property (nonatomic,weak)id target;
@property (nonatomic)SEL selector;
@end
@implementation ETRefreshControl
-(instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.tintColor=[UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
        self.enabled=YES;
        
    }
    return self;
}
-(void)setProgress:(CGFloat)progress
{
    if (progress!=_progress) {
        _progress=progress;
        [self setNeedsDisplay];
    }
}
-(void)drawRect:(CGRect)rect
{
    if (self.progress>0) {
        UIBezierPath *path=[UIBezierPath bezierPath];
        CGFloat centerx=rect.size.width/2;
        CGFloat offsety=self.height*self.progress;
        CGFloat radius=(pow(centerx, 2)+pow(offsety, 2))/(2*offsety);
        CGFloat angle=atan((radius-offsety)/centerx);
        [path addArcWithCenter:CGPointMake(centerx, offsety-radius) radius:radius startAngle:-M_PI+angle endAngle:-angle clockwise:NO];
        [self.tintColor setFill];
        [path fill];
    }
    else
    {
        [super drawRect:rect];
    }
}
-(void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    self.target=target;
    self.selector=action;
}
-(void)removeTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    self.target=nil;
    self.selector=nil;
}
-(void)willMoveToSuperview:(nullable UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        if ([newSuperview isKindOfClass:[UIScrollView class]]) {
            self.scrollView=(UIScrollView *)newSuperview;
            [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
            self.size=CGSizeMake(self.scrollView.width, kETRefreshControlHeight);
        }
    }
    else
    {
        if (self.scrollView) {
            [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
            self.scrollView=nil;
        }
    }
}
-(void)setRefreshState:(ETRefreshState)refreshState
{
    if (_refreshState!=refreshState) {
        _refreshState=refreshState;
        if (refreshState==ETRefreshStateRefreshing) {
            if (self.target&&self.selector) {
                [[UIApplication sharedApplication] sendAction:self.selector to:self.target from:self forEvent:nil];
            }
        }
    }
}
#pragma mark 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.enabled) {
        if ([@"contentOffset" isEqualToString:keyPath])
        {
            CGFloat offsetY = - self.scrollView.contentOffset.y;
            self.progress=offsetY/self.height;
            if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden||self.refreshState==ETRefreshStateRefreshing)
            {
                return;
            }
            if (offsetY>0) {
                if (self.scrollView.isDragging) {
                    CGFloat validOffsetY =  self.height*0.4;
                    if (self.refreshState == ETRefreshStatePulling && offsetY <= validOffsetY)
                    {
                        self.refreshState=ETRefreshStateNormal;
                    }
                    else if (self.refreshState == ETRefreshStateNormal && offsetY > validOffsetY)
                    {
                        self.refreshState=ETRefreshStatePulling;
                    }
                } else {
                    if (self.refreshState==ETRefreshStatePulling) {
                        self.refreshState=ETRefreshStateRefreshing;
                    }
                }
            }
        }
    }
}
-(BOOL)isRefreshing
{
    return self.refreshState==ETRefreshStateRefreshing;
}
- (void)beginRefreshing
{
    self.refreshState=ETRefreshStateRefreshing;
}
- (void)endRefreshing
{
    self.refreshState=ETRefreshStateNormal;
}

@end
