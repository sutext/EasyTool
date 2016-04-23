//
//  ETCrypto.h
//  EasyTool
//
//  Created by supertext on 15/6/29.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,ETHashAlgorithm) {
    ETHashAlgorithmMD2,
    ETHashAlgorithmMD4,
    ETHashAlgorithmMD5,
    ETHashAlgorithmSHA1,
    ETHashAlgorithmSHA224,
    ETHashAlgorithmSHA256,
    ETHashAlgorithmSHA384,
    ETHashAlgorithmSHA512,
};

typedef NS_ENUM(NSInteger,ETCryptoAlgorithm) {
    ETCryptoAlgorithmDES,
    ETCryptoAlgorithmZIP,
    ETCryptoAlgorithmAES128,
    ETCryptoAlgorithmAES192,
    ETCryptoAlgorithmAES256,
};

typedef NS_ENUM(NSInteger,ETEncodeAlgorithm) {
    ETEncodeAlgorithmBase64,
    ETEncodeAlgorithmHex,
};

@interface ETCrypto : NSObject
+(nullable NSString *)DESEncryptString:(NSString *)inputString withkey:(NSString *)key;
+(nullable NSString *)DESDecryptString:(NSString *)inputString withkey:(NSString *)key;
+(nullable NSString *)AESEncryptString:(NSString *)inputString withkey:(NSString *)key;
+(nullable NSString *)AESDecryptString:(NSString *)inputString withkey:(NSString *)key;
@end

@interface NSString (ETCrypto)
-(NSString *)ETMD5String;
-(NSString *)ETCRC32String;
-(NSString *)ETBase64String;
-(NSString *)ETURLEncodedString;

-(nullable NSString *)encryptWithKey:(NSString *)key
                  algorithm:(ETCryptoAlgorithm)algorithm
                     encode:(ETEncodeAlgorithm)encode;

-(nullable NSString *)decryptWithKey:(NSString *)key
                  algorithm:(ETCryptoAlgorithm)algorithm
                     encode:(ETEncodeAlgorithm)encode;
@end

@interface NSData (ETCrypto)
-(NSString *)stringWithEncode:(ETEncodeAlgorithm)algorithm;
-(NSData *)hashWithAlgorithm:(ETHashAlgorithm)algorithm;
-(nullable NSData *)encryptWithKey:(NSString *)key algorithm:(ETCryptoAlgorithm)algorithm;
-(nullable NSData *)decryptWithKey:(NSString *)key algorithm:(ETCryptoAlgorithm)algorithm;
@end
NS_ASSUME_NONNULL_END