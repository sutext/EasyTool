//
//  ETAlertController.m
//  EasyTool
//
//  Created by supertext on 16/1/28.
//  Copyright © 2016年 icegent. All rights reserved.
//

#import <EasyTools/ETAlertController.h>
#import <EasyTools/UIView+EasyTools.h>
#import <EasyTools/ETDefinition.h>
#import <EasyTools/ETalertViewController.h>
@interface ETAlertDeleteIcon :UIView
- (instancetype)init;
@property(nonatomic,copy)void (^clickedBlock)(ETAlertDeleteIcon *icon);
@end
@implementation ETAlertDeleteIcon
- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 20, 20)];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapges=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapges];
    }
    return self;
}
-(void)tapAction:(UITapGestureRecognizer *)tapges
{
    if (self.clickedBlock) {
        self.clickedBlock(self);
    }
}
-(void)drawRect:(CGRect)rect

{
    CGSize size=rect.size;
    CGFloat radius=size.width/2-1;
    CGFloat width=size.width;
    CGFloat height=size.height;
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(width/2, height/2) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CGFloat temlegth=(sqrt(2)-1)*width/2;
    [path moveToPoint:CGPointMake(temlegth,temlegth)];
    [path addLineToPoint:CGPointMake(width-temlegth, height-temlegth)];
    [path moveToPoint:CGPointMake(width-temlegth, temlegth)];
    [path addLineToPoint:CGPointMake(temlegth, height-temlegth)];
    path.lineWidth=1;
    [[UIColor whiteColor] set];
    [path stroke];
}

@end

@interface ETAlertController()
@property(nonatomic,strong)UIWindow *window;
@property(nonatomic,strong)UILabel *messageLabel;
@property(nonatomic,strong,readwrite)UIView *blurView;
@property(nonatomic,strong)ETAlertIconView *iconView;
@property(nonatomic,strong)ETAlertWaitView *waitView;
@property(nonatomic,readwrite)ETAlertViewType alertType;
@end

@implementation ETAlertController
+(instancetype)waitViewWithMessage:(NSString *)message style:(ETAlertWaitStyle)style hideBlock:(void (^)(UIView *))hideBlock
{
    ETAlertController *alert=[[ETAlertController alloc] init];
    alert.alertType=ETAlertViewTypeWait;
    alert.waitView=[ETAlertWaitView waitWithStyle:style];
    alert.waitView.origin=CGPointMake((alert.blurView.width-alert.waitView.width)/2, (alert.blurView.height-alert.waitView.height)/2);
    [alert.blurView addSubview:alert.waitView];
    
    if (message&&message.length>0) {
        alert.waitView.top=10;
        alert.messageLabel.text=message;
    }
    ETAlertDeleteIcon *icon=[[ETAlertDeleteIcon alloc] init];
    icon.origin=CGPointMake(alert.blurView.width-icon.width, 0);
    icon.clickedBlock=^(ETAlertDeleteIcon *iconview){
        if (hideBlock) {
            hideBlock(iconview);
        }
    };
    icon.hidden=YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        icon.hidden=NO;
    });
    [alert.blurView addSubview:icon];
    return alert;
}
+(instancetype)iconViewWithMessage:(NSString *)message style:(ETAlertIconStyle)style
{
    ETAlertController *alert=[[ETAlertController alloc] init];
    alert.alertType=ETAlertViewTypeIcon;
    alert.iconView=[ETAlertIconView iconWithStyle:style];
    alert.iconView.origin=CGPointMake((alert.blurView.width-alert.iconView.width)/2, (alert.blurView.height-alert.iconView.height)/2);
    [alert.blurView addSubview:alert.iconView];
    
    if (message&&message.length>0) {
        alert.iconView.top=10;
        alert.messageLabel.text=message;
    }
    return alert;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.backgroundColor=[UIColor clearColor];
        window.windowLevel=UIWindowLevelAlert;
        self.window = window;
        UIView *blurView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 170, 100)];
        blurView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
        blurView.center=CGPointMake(window.width/2, window.height/2);
        blurView.layer.cornerRadius=5;
        self.blurView=blurView;
        self.window.rootViewController = [[ETAlertViewController alloc] init];
        self.window.rootViewController.view.frame = window.bounds;
        [self.window.rootViewController.view addSubview:self.blurView];
    }
    return self;
}
-(UILabel *)messageLabel
{
    if (!_messageLabel) {
        UILabel *messageLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.blurView.height-30, self.blurView.width, 20)];
        messageLabel.textAlignment=NSTextAlignmentCenter;
        messageLabel.backgroundColor=[UIColor clearColor];
        messageLabel.textColor=[UIColor whiteColor];
        messageLabel.font=[UIFont boldSystemFontOfSize:15];
        self.messageLabel=messageLabel;
        [self.blurView addSubview:messageLabel];
    }
    return _messageLabel;
}
-(void)startAnimation
{
    if (self.alertType==ETAlertViewTypeWait) {
        [self.waitView startAnimation];
    }
}
-(void)stopAnimation
{
    if (self.alertType==ETAlertViewTypeWait) {
        [self.waitView stopAnimation];
    }
}
-(CGFloat)alpha
{
    return self.window.alpha;
}
-(void)setAlpha:(CGFloat)alpha
{
    self.window.alpha = alpha;
}
-(void)setHidden:(CGFloat)hidden
{
    self.window.hidden = hidden;
}
@end
