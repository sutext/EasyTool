//
//  ETButton.h
//  EasyTool
//
//  Created by supertext on 14-6-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
/*!
 *  @author 15-04-16 19:04:17
 *
 *  @brief The ETButtonTitleStyle type  described the location relationship between titleLabel and imageView.
 */
typedef NS_ENUM(NSInteger, ETButtonTitleStyle){
    /*!
     *  @author 15-04-16 19:04:17
     *
     *  @brief  the title titleLabel cover on the imageView
     */
    ETButtonTitleStyleCover,
    /*!
     *  @author 15-04-16 19:04:17
     *
     *  @brief  the titleLabel is on the right side of imageView, this is the UIButton default style.
     */
    ETButtonTitleStyleRight,
    /*!
     *  @author 15-04-16 19:04:17
     *
     *  @brief  the titleLabel is on the bottom side of imageView
     */
    ETButtonTitleStyleBottom,
    /*!
     *  @author 15-04-16 19:04:17
     *
     *  @brief  the default style is ETButtonTitleStyleRight.this is the UIButton default style.
     */
    ETButtonTitleStyleDefault = ETButtonTitleStyleRight
};

@class ETButtonItem;

/*!
 *  @author 15-04-16 19:04:00
 *
 *  @brief  the ETButon Class is an evolution of UIButton witch help you to use button more convenience。
 *  @note   In order to layout the button subviews perfect you may call [sizeToFit].
 */
NS_CLASS_AVAILABLE_IOS(7_0) @interface ETButton : UIButton
-(instancetype)init;//use defualt style
-(instancetype)initWithStyle:(ETButtonTitleStyle)style;
-(instancetype)initWithFrame:(CGRect)frame style:(ETButtonTitleStyle)style;
@property(nonatomic,readonly)ETButtonTitleStyle titleStyle;
/*!
 *  @author 15-04-20 10:04:27
 *
 *  @brief  set the size for self.iamgeView. all the custom layout style caculate size base on this property.
 *  @note   if titleStyle == ETButtonTitleStyleDefault this property will be ignore
 *  @note   this is the most important porperty for the custom layout style. you mast set it exactly!
 */
@property(nonatomic)CGSize imageSize;
/*!
 *  @author 15-04-20 10:04:53
 *  @brief  set a block action for UIControlEventTouchUpInside
 */
@property(nonatomic,copy,nullable)void (^clickedAction)(ETButton *sender);
/*!
 *  @author 15-04-20 13:04:11
 *  @brief  caculate current titleLabel size.
 */
-(CGSize)currentTitleSize;
/*!
 *  @author 15-04-20 10:04:43
 *
 *  @brief  this method create an image with color and imageSize and call [setImage:forState:]
 *  @note   this method will overwrite the image for the corresponding state.
 *  @param  color image color
 *  @param  state UIControlState
 */
-(void)setImageColor:(UIColor *)color forState:(UIControlState)state;

/*!
 *  @author 15-04-20 10:04:53
 *
 *  @brief  this method will overwrite all the corresponding settings of the button using the item property.
 *  @note   the button nerver keep the item project.
 *  @param  item  the button setting project
 *  @param  state UIControlState
 */
-(void)applyButtonItem:(__kindof ETButtonItem *)item forState:(UIControlState)state;
@end

@interface ETButtonItem : NSObject<UIAppearance>//all the UIAppearance protocol methods return the same proxy object.
@property(nonatomic,strong,nullable)UIImage     *image;
@property(nonatomic,strong,nullable)NSString    *title;
@property(nonatomic,strong,nullable)UIFont      *titleFont   UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong,nullable)UIColor     *titleColor  UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong,nullable)UIColor     *imageColor  UI_APPEARANCE_SELECTOR;//if the image!=nil the imageColor property dos't work!
@property(nonatomic)CGFloat                     cornerRadius UI_APPEARANCE_SELECTOR;
@property(nonatomic)CGSize                      imageSize    UI_APPEARANCE_SELECTOR;
@end
NS_ASSUME_NONNULL_END

