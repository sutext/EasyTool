//
//  ETDecryptor.h
//  EasyTool
//
//  Created by supertext on 15/8/24.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface ETDecryptor : NSObject
+(instancetype)decryptorWithPath:(NSString *)privateKeyPath passwd:(NSString *)passwd;
-(nullable NSData *)decryptMessage:(NSString *)message;
-(nullable NSData *)signatureMessage:(NSString *)message;//use SHA1 sign
@end
NS_ASSUME_NONNULL_END