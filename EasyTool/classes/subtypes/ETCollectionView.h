//
//  ETCollectionView.h
//  EasyTool
//
//  Created by supertext on 15/2/14.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EasyTools/ETRefreshProtocol.h>
NS_ASSUME_NONNULL_BEGIN
@class ETCollectionView;

@protocol ETCollectionViewDelegate <UICollectionViewDelegate>

@optional
/*!
 *  @Author 14-11-06 09:11:50
 *
 *  @brief  the callback of the tableView will begin refresh.
 *
 *  @param collectionView the collectionView
 *  @param style          the style of table view
 *  @param refreshControl the sender
 */
-(void)collectionView:(ETCollectionView *)collectionView willBeginRefreshWithStyle:(ETRefreshStyle)style refreshControl:(id<ETRefreshProtocol>)refreshControl;
@end

NS_CLASS_AVAILABLE_IOS(7_0) @interface ETCollectionView : UICollectionView

@property(nonatomic,strong,readonly)id<ETRefreshProtocol> trefreshControl;//will be create when usingRefreshStyle:ETRefreshStyleTop happened. the topRefreshControl

@property(nonatomic,strong,readonly)id<ETRefreshProtocol> brefreshControl;//will be create when usingRefreshStyle:ETRefreshStyleBottom happened. the bottomRefreshControl
/*!
 *  @Author 14-11-06 09:11:23
 *
 *  @brief  the extends of the UICollectionView's delegate
 */
@property(nonatomic,weak,nullable)id<ETCollectionViewDelegate> delegate;
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