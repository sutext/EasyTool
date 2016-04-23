//
//  UIViewController+easyTools.m
//  EasyTool
//
//  Created by supertext on 14-6-6.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import "UIViewController+EasyTools.h"
#import "UIImage+EasyTools.h"

@interface ETNavigationBarItem()
@property(nonatomic,readwrite)ETNavigationBarItemStyle    style;
@property(nonatomic,readwrite)SEL                action;
@property(nonatomic,strong,readwrite)UIImage     *image;
@property(nonatomic,strong,readwrite)UIImage     *selectedImage;
@property(nonatomic,strong,readwrite)NSString    *title;
@end

@implementation ETNavigationBarItem
+(instancetype)itemWithTitle:(NSString *)title action:(SEL)action
{
    ETNavigationBarItem *item = [[[self class] alloc] init];
    item.title = title;
    item.style = ETNavigationBarItemStyleText;
    item.size = CGSizeMake(60, 30);
    item.action= action;
    return item;
}
+(instancetype)itemWithImage:(UIImage *)image selectedImage:(nullable UIImage *)selectedImage action:(SEL)action
{
    ETNavigationBarItem *item = [[[self class] alloc] init];
    item.image = image;
    item.selectedImage = selectedImage;
    item.style = ETNavigationBarItemStyleImage;
    item.action = action;
    return item;
}
+(instancetype)itemWithFixed:(CGFloat)fixed
{
    ETNavigationBarItem *item = [[[self class] alloc] init];
    item.fixedSpace = fixed;
    item.style = ETNavigationBarItemStyleFixed;
    return item;
}
+(instancetype)appearance
{
    static dispatch_once_t onceToken = 0;
    static ETNavigationBarItem *_appearance;
    dispatch_once(&onceToken, ^{
        _appearance= [[self alloc] initAppearance];
    });
    return _appearance;
}
+(instancetype)appearanceForTraitCollection:(UITraitCollection *)trait
{
    return [self appearance];
}
+(instancetype)appearanceForTraitCollection:(UITraitCollection *)trait whenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ...
{
    return [self appearance];
}
+(instancetype)appearanceWhenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ...
{
    return [self appearance];
}
-(UIBarButtonItem *)buttonItemWithTarget:(id)target
{
    switch (self.style) {
        case ETNavigationBarItemStyleText: {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:self.title forState:UIControlStateNormal];
            [button setTitleColor:self.titleColor forState:UIControlStateNormal];
            [button.titleLabel setFont:self.titleFont];
            [button setFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
            [button addTarget:target action:self.action forControlEvents:UIControlEventTouchUpInside];
            UILabel *badge = [self createBadgeLable:self.badgeValue];
            if (badge) {
                badge.frame = CGRectMake(self.size.width-badge.frame.size.width/2, - badge.frame.size.height/2, badge.frame.size.width, badge.frame.size.height);
                [button addSubview:badge];
            }
            return  [[UIBarButtonItem alloc] initWithCustomView:button];
            break;
        }
        case ETNavigationBarItemStyleImage: {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:target action:self.action forControlEvents:UIControlEventTouchUpInside];
            [button setFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
            [button setImage:self.image forState:UIControlStateNormal];
            [button setImage:self.selectedImage forState:UIControlStateHighlighted];
            UILabel *badge = [self createBadgeLable:self.badgeValue];
            if (badge) {
                badge.frame = CGRectMake(self.size.width-badge.frame.size.width/2, - badge.frame.size.height/2, badge.frame.size.width, badge.frame.size.height);
                [button addSubview:badge];
            }
            return [[UIBarButtonItem alloc] initWithCustomView:button];
            break;
        }
        case ETNavigationBarItemStyleFixed: {
            UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedSpace.width = self.fixedSpace;
            return fixedSpace;
            break;
        }
        default: {
            break;
        }
    }
}
-(UILabel *)createBadgeLable:(NSInteger)badgeValue
{
    if (badgeValue>0) {
        UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        badgeLabel.backgroundColor = self.badgeColor;
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
        point.backgroundColor = self.badgeColor;
        return point;
    }
    else
    {
        return nil;
    }
}

- (instancetype)initAppearance
{
    self = [super init];
    if (self) {
        self.titleColor = [UIColor blackColor];
        self.titleFont  = [UIFont systemFontOfSize:14];
        self.badgeColor = [UIColor redColor];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        ETNavigationBarItem *appearance     = [[self class] appearance];
        self.titleColor                     = appearance.titleColor.copy;
        self.titleFont                      = appearance.titleFont.copy;
        self.badgeColor                     = appearance.badgeColor.copy;
        self.size                           = CGSizeMake(30, 30);
    }
    return self;
}


@end

@implementation UIViewController (EasyTools)

-(void)setRightBarItems:(NSArray<ETNavigationBarItem *> *)items
{
    if (items.count>0) {
       NSMutableArray<UIBarButtonItem *> *rightItems=[NSMutableArray array];
        [items enumerateObjectsUsingBlock:^(ETNavigationBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [rightItems addObject:[obj buttonItemWithTarget:self]];
        }];
        self.navigationItem.rightBarButtonItems = rightItems;
    }
}
-(void)setLeftBarItems:(NSArray<ETNavigationBarItem *> *)items
{
    if (items.count>0) {
        NSMutableArray<UIBarButtonItem *> *rightItems=[NSMutableArray array];
        [items enumerateObjectsUsingBlock:^(ETNavigationBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [rightItems addObject:[obj buttonItemWithTarget:self]];
        }];
        self.navigationItem.leftBarButtonItems = rightItems;
    }
}
-(void)setLeftBarEnable:(BOOL)enable;
{
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* obj, NSUInteger idx, BOOL *stop) {
        obj.enabled=enable;
    }];
}

-(void)setRightBarEnable:(BOOL)enable
{
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * obj, NSUInteger idx, BOOL *stop) {
        obj.enabled=enable;
    }];
}

-(void)removeLeftBarItem
{
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.leftBarButtonItems=nil;
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

-(void)removeRightBarItem
{
    self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.rightBarButtonItems=nil;
}

@end


