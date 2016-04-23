//
//  UIViewController+easyTools.h
//  EasyTool
//
//  Created by supertext on 14-6-6.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,ETNavigationBarItemStyle) {
    ETNavigationBarItemStyleText,
    ETNavigationBarItemStyleImage,
    ETNavigationBarItemStyleFixed,
};

@interface ETNavigationBarItem : NSObject<UIAppearance>

+(instancetype)itemWithTitle:(NSString *)title action:(SEL)action;
+(instancetype)itemWithImage:(UIImage *)image selectedImage:(nullable UIImage *)selectedImage action:(SEL)action;
+(instancetype)itemWithFixed:(CGFloat)fixed;

@property(nonatomic,readonly)ETNavigationBarItemStyle    style;
@property(nonatomic,strong,nullable)UIColor     *badgeColor UI_APPEARANCE_SELECTOR;
@property(nonatomic)NSInteger                   badgeValue;
@property(nonatomic)CGSize                      size;
@property(nonatomic,readonly)SEL                action;
/*-image-*/
@property(nonatomic,strong,readonly)UIImage     *image;
@property(nonatomic,strong,readonly)UIImage     *selectedImage;
/*-text-*/
@property(nonatomic,strong,readonly)NSString    *title;
@property(nonatomic,strong,nullable)UIFont               *titleFont  UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong,nullable)UIColor              *titleColor UI_APPEARANCE_SELECTOR;
/*-fixed-*/
@property(nonatomic)CGFloat                     fixedSpace;
@end


@interface UIViewController (EasyTools)

-(void)setRightBarItems:(NSArray<ETNavigationBarItem *> *)items;
-(void)setLeftBarItems:(NSArray<ETNavigationBarItem *> *)items;

-(void)setLeftBarEnable:(BOOL)enable;

-(void)setRightBarEnable:(BOOL)enable;

-(void)removeLeftBarItem;

-(void)removeRightBarItem;
@end
NS_ASSUME_NONNULL_END