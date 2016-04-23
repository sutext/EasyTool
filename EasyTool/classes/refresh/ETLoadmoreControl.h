//
//  ETLoadmoreControl.h
//  EasyTool
//
//  Created by supertext on 14/12/23.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EasyTools/ETRefreshProtocol.h>
NS_ASSUME_NONNULL_BEGIN
@interface ETLoadmoreControl : UIView<ETRefreshProtocol>
-(instancetype)init;
@property(nonatomic,strong,nullable) NSAttributedString *attributedTitle;
@property(nonatomic,getter=isEnabled) BOOL enabled;
@end
NS_ASSUME_NONNULL_END