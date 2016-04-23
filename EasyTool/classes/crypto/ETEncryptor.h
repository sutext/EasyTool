//
//  ETEncryptor.h
//  EasyTool
//
//  Created by supertext on 15/8/24.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface ETEncryptor : NSObject
+(nullable instancetype)encryptorWithPath:(NSString *)pubkeyPath;
-(nullable NSData *)encryptMessage:(NSString *)message;
@end
NS_ASSUME_NONNULL_END