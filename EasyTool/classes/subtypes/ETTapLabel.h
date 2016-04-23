//
//  ETTapLabel.h
//  EasyTool
//
//  Created by supertext on 14-6-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_CLASS_AVAILABLE_IOS(7_0)
NS_ASSUME_NONNULL_BEGIN
@interface ETTapLabel : UILabel
@property(nonatomic,copy,nullable)void (^tapAction)(ETTapLabel *label);
/*!
 *  @author 15-04-21 13:04:22
 *
 *  @brief  if you set this property ,you may call sizeToFit to adjust it's frame.
 */
-(void)setTextInsets:(UIEdgeInsets)textInsets;
-(UIEdgeInsets)textInsets;
@end
NS_ASSUME_NONNULL_END