//
//  ETAlertWaitView.m
//  EasyTool
//
//  Created by supertext on 14-6-12.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETAlertWaitView.h>
#import <EasyTools/UIView+EasyTools.h>
@interface ETAlertWaitView()
@property(nonatomic,strong)UIActivityIndicatorView *indicator;
@property(nonatomic)ETAlertWaitStyle style;
@property(nonatomic,strong)UIColor* iconColor;//defalt is white color
@end
@implementation ETAlertWaitView
+(instancetype)waitWithStyle:(ETAlertWaitStyle)style
{
    return [[ETAlertWaitView alloc] initWithStyle:style];
}
-(instancetype)initWithStyle:(ETAlertWaitStyle)style
{
    self = [super initWithFrame:CGRectMake(0, 0, 151, 60)];
    if (self) {
        _style=style;
        self.backgroundColor=[UIColor clearColor];
        self.iconColor=[UIColor whiteColor];
    }
    return self;
}
-(UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center=CGPointMake(self.width/2, self.height/2);
        self.indicator=indicator;
    }
    return _indicator;
}
-(void)startAnimation
{
    switch (self.style) {
        case ETAlertWaitStyleChrysanthemum:
            [self addSubview:self.indicator];
            [self.indicator startAnimating];
            break;
            
        default:
            break;
    }
}
-(void)stopAnimation
{
    switch (self.style) {
        case ETAlertWaitStyleChrysanthemum:
            [self.indicator startAnimating];
            [self.indicator removeFromSuperview];
            break;
            
        default:
            break;
    }
}
@end
