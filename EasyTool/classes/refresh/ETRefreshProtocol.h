//
//  ETRefreshProtocol.h
//  EasyTool
//
//  Created by supertext on 14/11/6.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#ifndef EasyTool_ETRefreshProtocol_h
#define EasyTool_ETRefreshProtocol_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSUInteger, ETRefreshStyle)
{
    ETRefreshStyleTop = 1<<0,
    ETRefreshStyleBottom = 1<<2,
    ETRefreshStyleBoth  = ETRefreshStyleTop|ETRefreshStyleBottom,
};

/*!
 *  @Author 14-11-06 10:11:06
 *
 *  @brief  the refreshControl must be a UIView Class and impl this protocol
 *  @warning the impl class must be a UIView kind class !!!!!!
 */
@protocol ETRefreshProtocol <NSCoding, UIAppearance, UIAppearanceContainer, UIDynamicItem, UITraitEnvironment, UICoordinateSpace>
@optional
@property (nonatomic, strong,null_resettable) UIColor *tintColor;
@property (nonatomic, strong,nullable) NSAttributedString *attributedTitle;
@required
@property (nonatomic, getter=isEnabled) BOOL enabled;
- (instancetype)init;//The designated initializer
//** these methods must be implment by impl class . these  methods may be call by the user */
- (BOOL)isRefreshing NS_AVAILABLE_IOS(6_0);
- (void)beginRefreshing NS_AVAILABLE_IOS(6_0);
- (void)endRefreshing NS_AVAILABLE_IOS(6_0);

//** these methods must be implment by impl class . These methods shouldn't be call by user anywhere */

/*!
 *  @Author 14-11-06 12:11:34
 *
 *  @brief  add target/action for particular event. you can call this multiple times and you can specify multiple target/actions for a particular event.
 *          passing in nil as the target goes up the responder chain. The action may optionally include the sender and the event in that order
 *          the action cannot be NULL. Note that the target is not retained.
 *          the custom impl class must implement this method to enable the refreshControl;
 *
 *  @param target        the target
 *  @param action        the action
 *  @param controlEvents the events
 */
- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
/*!
 *  @Author 14-11-06 12:11:56
 *
 *  @brief  remove the target/action for a set of events. pass in NULL for the action to remove all actions for that target
 *          the  custom impl class must implement this method to disable the refresControl
 *
 *  @param target        the target
 *  @param action        the action
 *  @param controlEvents the events
 */
- (void)removeTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
/*!
 *  @Author 14-11-06 12:11:12
 *
 *  @brief  the custom impl class must implement this method to do some initialize  when the newSuperview is kind of UITableView.
 *          just like this:
 *          if ([newSuperview isKindOfClass:[UITableView class]]) {
                self.tableView=(ETTableView *)newSuperview;
                [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
                [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
                //other setup work
            }
 *
 *  @param newSuperview may be tableView
 */
- (void)willMoveToSuperview:(nullable UIView *)newSuperview;
@end
NS_ASSUME_NONNULL_END
#endif
