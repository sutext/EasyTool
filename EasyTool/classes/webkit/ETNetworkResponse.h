//
//  ETNetworkResponse.h
//  EasyTool
//
//  Created by supertext on 14-10-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETNetworkResponse : NSObject
@property(nonatomic,readonly,strong)id              entiyObject;//the body of the respone may be an ETNetworkEntity or ETNetworkEntity array
@property(nonatomic,readonly,strong)id              extends;   //the extends info
@property(nonatomic,readonly,strong)NSDictionary    *header;    //the header info
@end
NS_ASSUME_NONNULL_END
