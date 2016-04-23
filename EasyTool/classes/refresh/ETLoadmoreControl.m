//
//  ETLoadmoreControl.m
//  EasyTool
//
//  Created by supertext on 14/12/23.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETLoadmoreControl.h>
#import <EasyTools/EasyTool.h>
#import <EasyTools/UIView+EasyTools.h>

#define kETRefreshControlHeight 60
#define kETRefreshAniDuration 0.25
typedef NS_ENUM(NSInteger, ETLoadmoreState) {
    ETLoadmoreStateNormal,
    ETLoadmoreStateRefreshing
};

@interface ETLoadmoreControl()
@property(nonatomic,strong) UILabel *textLabel;
@property(nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic)ETLoadmoreState refreshState;
@property(nonatomic,weak)id target;
@property(nonatomic)SEL selector;
@end

@implementation ETLoadmoreControl
-(instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.font=[UIFont systemFontOfSize:15];
        textLabel.textAlignment=NSTextAlignmentCenter;
        textLabel.backgroundColor=[UIColor clearColor];
        textLabel.textColor=ETColorFromRGB(0x677386);
        textLabel.text=@"honey, no more content~";
        self.textLabel=textLabel;
        [self addSubview:textLabel];
        UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:activity];
        self.activityIndicator=activity;
        self.enabled=YES;
    }
    return self;
}
-(void)setAttributedTitle:(NSAttributedString *)attributedTitle
{
    if (_attributedTitle!=attributedTitle) {
        _attributedTitle=attributedTitle;
        self.textLabel.attributedText=attributedTitle;
    }
}
-(void)setEnabled:(BOOL)enabled
{
    if (_enabled!=enabled) {
        _enabled=enabled;
        self.textLabel.hidden=enabled;
    }
}
-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    self.target=target;
    self.selector=action;
}
-(void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    self.target=nil;
    self.selector=nil;
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        if ([newSuperview isKindOfClass:[UIScrollView class]]) {
            self.scrollView=(UIScrollView *)newSuperview;
            [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
            [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
            self.size=CGSizeMake(self.scrollView.width, kETRefreshControlHeight);
            self.textLabel.frame=CGRectMake(0, kETRefreshControlHeight/2 - 10, self.width, 20);
            self.activityIndicator.center=CGPointMake(self.width/2, self.height/2);
        }
    }
    else
    {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
        [self.scrollView removeObserver:self forKeyPath:@"contentSize" context:NULL];
        self.scrollView=nil;
    }
}
-(void)setRefreshState:(ETLoadmoreState)refreshState
{
    if (_refreshState!=refreshState) {
        _refreshState=refreshState;
        self.userInteractionEnabled=NO;
        switch (refreshState) {
            case ETLoadmoreStateNormal:
            {
                [self.activityIndicator stopAnimating];
                [UIView animateWithDuration:kETRefreshAniDuration animations:^{
                    UIEdgeInsets inset = self.scrollView.contentInset;
                    inset.bottom = 0;
                    self.scrollView.contentInset = inset;
                } completion:^(BOOL finished) {
                    self.userInteractionEnabled=YES;
                } ];
            } break;
            case ETLoadmoreStateRefreshing:
            {
                [self.activityIndicator startAnimating];
                if (self.target&&self.selector) {
                    [[UIApplication sharedApplication] sendAction:self.selector to:self.target from:self forEvent:nil];
                }
                [UIView animateWithDuration:kETRefreshAniDuration animations:^{
                    UIEdgeInsets inset = self.scrollView.contentInset;
                    inset.bottom = self.frame.origin.y - self.scrollView.contentSize.height +kETRefreshControlHeight;
                    self.scrollView.contentInset = inset;
                    self.scrollView.contentOffset = CGPointMake(0, [self verifiedOffset] + kETRefreshControlHeight);
                } completion:^(BOOL finished) {
                    self.userInteractionEnabled=YES;
                }];
            } break;
            default:
                break;
        }
    }
}
#pragma mark KVO method
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.isEnabled) {
        if ([@"contentOffset" isEqualToString:keyPath])
        {
            CGFloat offsetY = self.scrollView.contentOffset.y;
            CGFloat verifiedOffset = self.verifiedOffset+20;
            if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden|| offsetY <= verifiedOffset||self.refreshState==ETLoadmoreStateRefreshing)
            {
                return;
            }
            if (self.scrollView.isDragging) {
                self.refreshState=ETLoadmoreStateRefreshing;
            }
        }
    }
    if ([@"contentSize" isEqualToString:keyPath])
    {
        self.top=MAX(self.scrollView.contentSize.height, self.scrollView.height);
    }
}
- (CGFloat)verifiedOffset
{
    return MAX(self.scrollView.contentSize.height, self.scrollView.frame.size.height) - self.scrollView.frame.size.height;
    
}
-(BOOL)isRefreshing
{
    return self.refreshState==ETLoadmoreStateRefreshing;
}
- (void)beginRefreshing
{
    self.refreshState=ETLoadmoreStateRefreshing;
}
- (void)endRefreshing
{
    self.refreshState=ETLoadmoreStateNormal;
}

@end