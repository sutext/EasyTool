//
//  ETPopoverView.h
//  EasyTool
//
//  Created by supertext on 15/11/6.
//  Copyright © 2015年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ETPopoverArrowDirection) {
    ETPopoverArrowDirectionUP,
    ETPopoverArrowDirectionDown
};

@class ETPopoverViewConfig;
@class ETPopoverViewItem;
NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETPopoverView : UIView
-(instancetype)initWithConfig:(ETPopoverViewConfig *)config;
@property(nonatomic)CGFloat anchorPosition;
@property(nonatomic,strong,readonly)ETPopoverViewConfig* config;
@property(nonatomic,copy,nullable)void (^clickedAtIndex)(ETPopoverView *popoverView,NSInteger index,ETPopoverViewItem *item);
@end

NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETPopoverViewItem : NSObject
-(instancetype)initWithTitle:(NSString *)title icon:(nullable UIImage*)icon data:(nullable id)data;
@property(nonatomic,readonly,strong,nullable) NSString  *title;
@property(nonatomic,readonly,strong,nullable) UIImage   *icon;
@property(nonatomic,readonly,strong,nullable)id         bindData;
@end

NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETPopoverViewConfig : NSObject<UIAppearance>
@property(nonatomic,strong,nullable) UIFont                         *font UI_APPEARANCE_SELECTOR ;//defualt 14
@property(nonatomic,strong,nullable) UIColor                        *textColor UI_APPEARANCE_SELECTOR;//defualt withe
@property(nonatomic,strong,nullable) UIColor                        *backgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong,nullable) UIColor                        *selectedColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong,nullable) UIColor                        *separatorColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong,nullable) NSArray<ETPopoverViewItem *>   *items;
@property(nonatomic)                 NSUInteger                     maxTextCount UI_APPEARANCE_SELECTOR;//defualt 5
@property(nonatomic)                 NSUInteger                     maxLineCount UI_APPEARANCE_SELECTOR;//deault 5
@property(nonatomic)                 NSUInteger                     itemHeight UI_APPEARANCE_SELECTOR;//defualt 35
@property(nonatomic)                 NSUInteger                     cornerRadius UI_APPEARANCE_SELECTOR;//default 6
@property(nonatomic)                 NSUInteger                     anchorHeight UI_APPEARANCE_SELECTOR;//deault 5
@property(nonatomic)                 ETPopoverArrowDirection        direction UI_APPEARANCE_SELECTOR;//default Down
@property(nonatomic)                 NSTextAlignment                textAlignment UI_APPEARANCE_SELECTOR;//default Center
@end
NS_ASSUME_NONNULL_END