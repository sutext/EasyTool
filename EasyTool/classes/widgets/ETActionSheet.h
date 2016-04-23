//
//  ETActionSheet.h
//  EasyTool
//
//  Created by supertext on 14/10/29.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EasyTools/ETButton.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, ETActionSheetStyle) {
    ETActionSheetStyleRank1x3 = 0x13,
    ETActionSheetStyleRank1x4 = 0x14,
    ETActionSheetStyleRank2x3 = 0x23,
    ETActionSheetStyleRank2x4 = 0x24,
    ETActionSheetStyleRank3x3 = 0x33,
    ETActionSheetStyleRank3x4 = 0x34,
    ETActionSheetStyleDefault = ETActionSheetStyleRank2x3,
};
@protocol ETActionSheetDelegate;

NS_CLASS_AVAILABLE_IOS(7_0)@interface ETActionSheet : UIViewController
-(instancetype)initWithDelegate:(id<ETActionSheetDelegate>)delegate;//ETActionSheetStyleDefault used
-(instancetype)initWithStyle:(ETActionSheetStyle)style  delegate:(id<ETActionSheetDelegate>)delegate;//the designed constructor
@property(nonatomic)NSUInteger                          titleLineCount;//the number of all action item's title line count. default is 1
@property(nonatomic)CGFloat                             topMargin;//the margin between first line and the actionSheet pageview top bounds.default is 20.
@property(nonatomic)CGFloat                             middleMargin;//the margin between two line .default is 0.
@property(nonatomic)CGFloat                             bottomMargin;//the margin between last line and the actionSheet pageview bottom bounds .default is 10
@property(nonatomic)NSTimeInterval                      aniduration;//defualt is 0.25
@property(nonatomic,strong,nullable)UIColor             *tintColor;//the action view color
-(void)show;//show the action sheet .
-(void)hide;//the same result of cancel button clicked
@end

@interface ETActionSheetItem : ETButtonItem
@property(nonatomic,strong,nullable)id          bindingData;
@end

@protocol ETActionSheetDelegate <NSObject>
@required
/*!
 *  @Author 14-10-30 10:10:06
 *
 *  @brief  the icon numbers
 *
 *  @param actionSheet the action sheet
 *
 *  @return the count of the icon. if return 0 nothing will be show.
 */
-(NSUInteger)numberOfItemsInActionSheet:(ETActionSheet *)actionSheet;
/*!
 *  @author 15-04-17 21:04:41
 *
 *  @brief  config the info with each item . such as:
 *          actionItem.title = @"facebook";
            actionItem.image = [UIImage imageNamed:@"facebook_icon"];
            actionItem.bindingData = you binding object.
            ...other item setings.
 *
 *  @note   the actionItem.imageSize will be ignore.
 *
 *  @param actionSheet the acitonSheet.
 *  @param actionItem  the empity item object.
 *  @param index       the action index .
 */
-(void)actionSheet:(ETActionSheet *)actionSheet configActionItem:(ETActionSheetItem *)actionItem atIndex:(NSUInteger)index;
/*!
 *  @author 15-04-20 10:04:48
 *
 *  @brief  config the cancel item appearance.
 *  @see actionSheet:configActionItem:atIndex
 */
-(void)actionSheet:(ETActionSheet *)actionSheet configCancelItem:(ETActionSheetItem *)cancelItem;
@optional
/*!
 *  @author 15-04-20 10:04:16
 *
 *  @brief  the call back when actionSheet item have been clicked.
 *
 *  @param actionSheet the actionSheet
 *  @param actionItem  the config object of current clicked item
 *  @param index       the current item index.
 */
-(void)actionSheet:(ETActionSheet *)actionSheet dismissWithItem:(ETActionSheetItem *)actionItem atIndex:(NSUInteger)index;
/*!
 *  @author 15-04-20 11:04:15
 *
 *  @brief  the call back when actionSheet cancel button have been clicked.@see actionSheet:dismissWithItem:atIndex:
 */
-(void)actionSheet:(ETActionSheet *)actionSheet cancledWithItem:(ETActionSheetItem *)cancelItem;
@end

NS_ASSUME_NONNULL_END