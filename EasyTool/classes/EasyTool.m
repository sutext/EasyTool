//
//  EasyTool.m
//  EasyTool
//
//  Created by supertext on 14-10-15.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/EasyTool.h>
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import <EasyTools/UIView+EasyTools.h>
inline CGRect UIEdgeInsetsOutsideRect(CGRect inRect,UIEdgeInsets insets)
{
    inRect.origin.x    -= insets.left;
    inRect.origin.y    -= insets.top;
    inRect.size.width  += (insets.left + insets.right);
    inRect.size.height += (insets.top  + insets.bottom);
    return inRect;
}

inline UIColor * ETColorFromRGBA(long long rgbValue,CGFloat aalpha)
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:aalpha];
}
inline UIColor * ETColorFromRGB(long long rgbValue)
{
    return ETColorFromRGBA(rgbValue, 1.0);
}
inline UIImage * ETRectImageWithColorScale(UIColor *color,CGSize size,CGFloat scale)
{
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

inline UIImage * ETRoundImageWithColorScale(UIColor *color,CGFloat radius,CGFloat scale)
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(2*radius, 2*radius), NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, 2*radius, 2*radius));
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
void ETSwapSystemFontName(NSString *fontName)
{
    if (fontName) {
        method_setImplementation(class_getClassMethod([UIFont class], @selector(systemFontOfSize:)), imp_implementationWithBlock((UIFont *) ^(id self,CGFloat size){
            return [self fontWithName:fontName size:size];
        }));
    }
}
inline UIImage * ETRectImageWithColor(UIColor *color,CGSize size)
{
    return  ETRectImageWithColorScale(color, size, [UIScreen mainScreen].scale);
}

inline UIImage * ETRoundImageWithColor(UIColor *color,CGFloat radius)
{
    return ETRoundImageWithColorScale(color, radius, [UIScreen mainScreen].scale);
}
inline NSString* ETDocumentsDirectory()
{
    NSString *docPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    BOOL isdir=NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:docPath isDirectory:&isdir]&&isdir) {
        return docPath;
    }
    return NSTemporaryDirectory();
}

inline NSString* ETCachesDirectory()
{
    NSString *cachesPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"];
    BOOL isdir=NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath isDirectory:&isdir]&&isdir) {
        return cachesPath;
    }
    return NSTemporaryDirectory();
}
@interface EasyTool : NSObject
+(instancetype)onlyObject;
@property(nonatomic)CGFloat screenWidth;
@property(nonatomic)CGFloat screenHeight;
@property(nonatomic)CGFloat screenRatio;
@property(nonatomic)CGFloat coefficient;
@end

inline CGFloat   ETScreenRatio()
{
    return [EasyTool onlyObject].screenRatio;
}
inline CGFloat   ETScreenWidth()
{
    return [EasyTool onlyObject].screenWidth;
}
inline CGFloat   ETScreenHeight()
{
    return [EasyTool onlyObject].screenHeight;
}
inline CGFloat   ETScaledFloat(CGFloat value)
{
    return value * [EasyTool onlyObject].coefficient;
}
@implementation EasyTool
+(instancetype)onlyObject
{
    static EasyTool *_tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool=[[super allocWithZone:nil] init];
    });
    return _tool;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        CGSize size= [UIScreen mainScreen].bounds.size;
        self.screenHeight=size.height;
        self.screenWidth=size.width;
        self.coefficient=self.screenWidth/375.0;
        self.screenRatio=size.height/size.width;
    }
    return self;
}
@end
@implementation NSObject(easyTools)
-(void)setRuntimeObject:(id)runtimeObject
{
    objc_setAssociatedObject(self, "__kETRuntimeObject", runtimeObject,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(id)runtimeObject
{
    return objc_getAssociatedObject(self,"__kETRuntimeObject");
}
@end
@implementation NSDate(easyTools)
-(NSString *)stringWithCFormat:(const char *restrict)format
{
    time_t tick=[self timeIntervalSince1970];//tick 为GMT的绝对时间
    char s[100];
    strftime(s, sizeof(s), format, localtime(&tick));//time format must set time zone
    //localtime(&tick)将时间戳转换为tm结构体 tm.tm_zone为当地时区
    return [NSString stringWithUTF8String:s];
}
-(NSString *)stringWithFormat:(NSString *)format
{
    return [self stringWithCFormat:[format UTF8String]];
}
@end

@implementation NSString(easyTools)
-(NSDate *)dateWithCFromat:(const char *restrict)format
{
    const char * timestr=[self UTF8String];
    struct tm tm;
    strptime(timestr, format, &tm);//字符串转tm结构体的时候 tm结构体的tm_zone为空
    time_t tick = timelocal(&tm);//timelocal调用后 tm结构体的tm_zone会被设置为当前时区 返回local绝对时间，如果timegm(&tm) 则tm结构体的tm_zone将被设置为UTC 返回当前GMT绝对时间
    return [NSDate dateWithTimeIntervalSince1970:tick];
}
-(NSDate *)dateWithFromat:(NSString *)format
{
    return [self dateWithCFromat:[format cStringUsingEncoding:NSUTF8StringEncoding]];
}
@end

@implementation UITabBar(easyTools)
-(void)setBadgeValue:(NSInteger)badgeValue atIndex:(NSInteger)index
{
    [self setBadgeValue:badgeValue badgeColor:nil atIndex:index];
}
-(void)setBadgeValue:(NSInteger)badgeValue badgeColor:(nullable UIColor *)badgeColor atIndex:(NSInteger)index
{
    if (self.items.count==0||index>=self.items.count) {
        return;
    }
    UILabel *point = (UILabel *)[self viewWithTag:1999+index];
    if (point) {
        [point removeFromSuperview];
    }
    point = [self createBadgeLable:badgeValue badgeColor:badgeColor?:[UIColor redColor]];
    CGFloat itemWidth=self.width/(self.items.count>5?5:self.items.count);
    point.origin=CGPointMake(index*itemWidth+itemWidth-point.width-20, 8);
    point.tag=1999+index;
    [self addSubview:point];
}
-(UILabel *)createBadgeLable:(NSInteger)badgeValue badgeColor:(UIColor *)badgeColor
{
    if (badgeValue>0) {
        UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        badgeLabel.backgroundColor = badgeColor;
        badgeLabel.layer.cornerRadius = 8;
        badgeLabel.layer.masksToBounds = YES;
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.font = [UIFont systemFontOfSize:11];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.text = [@(badgeValue) stringValue];
        if (badgeValue > 9 && badgeValue < 100)
        {
            badgeLabel.frame = CGRectMake(0, 0, 22, 16);
        }
        if (badgeValue > 99)
        {
            badgeLabel.frame = CGRectMake(0, 0, 24, 16);
            badgeLabel.text = @"99+";
        }
        return badgeLabel;
    }
    else if (badgeValue <0)
    {
        UILabel * point = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        point.clipsToBounds=YES;
        point.layer.cornerRadius = point.frame.size.height / 2;
        point.backgroundColor = badgeColor;
        return point;
    }
    else
    {
        return nil;
    }
}
@end





