//
//  ETAlertController.h
//  EasyTool
//
//  Created by supertext on 16/1/28.
//  Copyright © 2016年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EasyTools/ETAlertIconView.h>
#import <EasyTools/ETAlertWaitView.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ETAlertViewType) {
    ETAlertViewTypeIcon,
    ETAlertViewTypeWait,
};
NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETAlertController : NSObject
+(instancetype)waitViewWithMessage:(NSString *)amessage style:(ETAlertWaitStyle)astyle hideBlock:(nullable void (^) (UIView *delicon)) hideBlock;

+(instancetype)iconViewWithMessage:(NSString *)amessage style:(ETAlertIconStyle)astyle;

@property(nonatomic,strong,readonly)UIView *blurView;

@property(nonatomic)CGFloat alpha;
-(void)setHidden:(CGFloat)hidden;

-(void)startAnimation;

-(void)stopAnimation;

@end
NS_ASSUME_NONNULL_END