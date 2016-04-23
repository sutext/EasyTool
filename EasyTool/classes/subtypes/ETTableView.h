//
//  ETTableView.h
//  EasyTool
//
//  Created by supertext on 14/11/5.
//  Copyright (c) 2014年 icegent. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <EasyTools/ETRefreshProtocol.h>
NS_ASSUME_NONNULL_BEGIN
@class ETTableView;

@protocol ETTableViewDelegate <UITableViewDelegate>

@optional
/*!
 *  @Author 14-11-06 09:11:50
 *
 *  @brief  the callback of the tableView will begin refresh.
 *
 *  @param tableView      the tableview
 *  @param style          the style of table view
 *  @param refreshControl the sender
 */
-(void)tableView:(ETTableView *)tableView willBeginRefreshWithStyle:(ETRefreshStyle)style refreshControl:(id<ETRefreshProtocol>)refreshControl;

@end

/*!
 *  @Author 14-11-06 12:11:39
 *
 *  @brief  the ETTableView implement the up or down drag refresh for the tableView. 
 *          you can use anywhere. if you did not using the refresh function the ETTableView will not produce any rubbish
 */
NS_CLASS_AVAILABLE_IOS(6_0) @interface ETTableView : UITableView

@property(nonatomic,strong,readonly,nullable)id<ETRefreshProtocol> trefreshControl;//will be create when usingRefreshStyle:ETRefreshStyleTop happened. the topRefreshControl

@property(nonatomic,strong,readonly,nullable)id<ETRefreshProtocol> brefreshControl;//will be create when usingRefreshStyle:ETRefreshStyleBottom happened. the bottomRefreshControl
/*!
 *  @Author 14-11-06 09:11:23
 *
 *  @brief  the extends of the UITableView's delegate
 */
@property(nonatomic,weak,nullable)id<ETTableViewDelegate> delegate;
/*!
 *  @Author 14-11-06 14:11:05
 *
 *  @brief  see (usingRefreshStyle:withClass) 
 *          default refresClass used
 *
 *  @param style ETRefreshStyle value
 */
-(void)usingRefreshStyle:(ETRefreshStyle)style;
/*!
 *  @Author 14-11-06 09:11:43
 *
 *  @brief      if you want to use refresh function call this method. This method will alloc a refreshControl and setup to the tableView.
 *
 *  @param      refresClass this param must be match to the style. you set top refreshClass for the ETRefreshStyleBottom may doesn't work.
 *              if nil the default Class will be used.
 *              by default: ETRefreshStyleTop use UIRefresControl. ETRefreshStyleBottom use prevate ETLoadmoreControl
 *  @param      style ETRefreshStyle value
 */
-(void)usingRefreshStyle:(ETRefreshStyle)style withClass:(__unsafe_unretained _Nullable Class<ETRefreshProtocol>)refresClass;
/*!
 *  @Author 14-11-06 10:11:02
 *
 *  @brief  if you don't want to use the refreshControl anymore call this method. This method will dealloc the refreshControl.
 *
 *  @param style ETRefreshStyle value
 */
-(void)removeRefreshStyle:(ETRefreshStyle)style;
/*!
 *  @Author 14-11-06 09:11:13
 *
 *  @brief  if you don't want to use the refreshControl temporarily you can call this method to off the refresh.
 *
 *  @param style ETRefreshStyle value
 */
-(void)disableRefreshStyle:(ETRefreshStyle)style;
/*!
 *  @Author 14-11-06 09:11:15
 *
 *  @brief  open the refresh
 *
 *  @param style ETRefreshStyle value
 */
-(void)enableRefreshStyle:(ETRefreshStyle)style;
@end

NS_ASSUME_NONNULL_END
