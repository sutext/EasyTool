//
//  ETPhotoBrowser.h
//  EasyTool
//
//  Created by supertext on 14/12/15.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ETPhotoObject;

NS_CLASS_AVAILABLE_IOS(7_0)@interface ETPhotoBrowser : NSObject
+(BOOL)onlyBrowserExsit;
/*!
 *  @author 15-02-09 17:02:59
 *
 *  @brief  the designed constructor for the browsser.
 *
 *  @param photos       an array of ETPhotoObject. the less count of photos is 1;
 *  @param startIndex   if startIndex is out of photos bounds.Your app will crash.
 *  @param browservcClass subclass of  ETPBrowserController class. if nil ETPBrowserController will be used
 *
 *  @return the browser instance
 */
-(instancetype)initWithPhotos:(NSArray<ETPhotoObject *> *)photos
                   startIndex:(NSUInteger)startIndex
               browservcClass:(__unsafe_unretained Class)browservcClass;
@property(nonatomic,copy,nullable)void (^wannaDismissAtindex)(NSUInteger index,ETPhotoObject * photo,ETPhotoBrowser *browser);
@property(nonatomic,copy,nullable)void (^didDismissAtindex)(NSUInteger index,ETPhotoObject * photo,ETPhotoBrowser *browser);
@property(nonatomic,copy,nullable)void (^didClickedAtindex)(NSUInteger index,ETPhotoObject * photo,ETPhotoBrowser *browser);
-(void)setStatusBarHidden:(BOOL)hidden;
-(void)show;
-(void)hide;
@end
NS_ASSUME_NONNULL_END