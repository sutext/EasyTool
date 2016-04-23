//
//  ETCrypto.m
//  EasyTool
//
//  Created by supertext on 15/6/29.
//  Copyright (c) 2015年 icegent. All rights reserved.
//


#import <CommonCrypto/CommonCrypto.h>
#import "ETCrypto.h"
@implementation ETCrypto
+(NSString *)DESEncryptString:(NSString *)inputString withkey:(NSString *)key
{
    const char *dataIn = [inputString UTF8String];
    size_t dataInLength = strlen(dataIn);
    size_t bufferSize = dataInLength+kCCBlockSizeDES;
    unsigned char  buffer[bufferSize];
    size_t outCount ;
    const char *strkey = [key UTF8String];
    size_t keylength = strlen(strkey);
    CCCryptorStatus cryptStatus =CCCrypt(kCCEncrypt,
            kCCAlgorithmDES,
            kCCOptionPKCS7Padding,
            strkey,
            keylength,
            NULL,
            dataIn,
            dataInLength,
            buffer,
            bufferSize,
            &outCount);
    if (cryptStatus == kCCSuccess) {
        return [[NSData dataWithBytes:buffer length:outCount] base64EncodedStringWithOptions:0];
    }
    return nil;
}
+(NSString *)DESDecryptString:(NSString *)inputString withkey:(NSString *)key
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:inputString options:0];
    const void *dataIn = data.bytes;
    size_t dataInLength = data.length;
    size_t bufferSize = dataInLength+kCCBlockSizeDES;
    unsigned char  buffer[bufferSize];
    size_t outCount ;
    const char *strkey = [key UTF8String];
    CCCryptorStatus cryptStatus =CCCrypt(kCCDecrypt,
                                         kCCAlgorithmDES,
                                         kCCOptionPKCS7Padding,
                                         strkey,
                                         kCCKeySizeDES,
                                         NULL,
                                         dataIn,
                                         dataInLength,
                                         buffer,
                                         bufferSize,
                                         &outCount);
    if (cryptStatus == kCCSuccess) {
        return [[NSString alloc] initWithData:[NSData dataWithBytes:buffer length:outCount] encoding:NSUTF8StringEncoding];
    }
    return nil;
}
+(NSString *)AESEncryptString:(NSString *)inputString withkey:(NSString *)key
{
    const char *dataIn = [inputString UTF8String];
    size_t dataInLength = strlen(dataIn);
    size_t bufferSize = dataInLength+kCCBlockSizeAES128;
    unsigned char  buffer[bufferSize];
    size_t outCount ;
    const char *strkey = [key UTF8String];
    CCCryptorStatus cryptStatus =CCCrypt(kCCEncrypt,
                                         kCCAlgorithmAES128,
                                         kCCOptionPKCS7Padding|kCCOptionECBMode,
                                         strkey,
                                         kCCKeySizeAES128,
                                         NULL,
                                         dataIn,
                                         dataInLength,
                                         buffer,
                                         bufferSize,
                                         &outCount);
    if (cryptStatus == kCCSuccess) {
        return [[NSData dataWithBytes:buffer length:outCount] base64EncodedStringWithOptions:0];
    }
    return nil;
}
+(NSString *)AESDecryptString:(NSString *)inputString withkey:(NSString *)key
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:inputString options:0];
    const void *dataIn = data.bytes;
    size_t dataInLength = data.length;
    size_t bufferSize = dataInLength+kCCBlockSizeAES128;
    unsigned char  buffer[bufferSize];
    size_t outCount ;
    const char *strkey = [key UTF8String];
    CCCryptorStatus cryptStatus =CCCrypt(kCCDecrypt,
                                         kCCAlgorithmAES128,
                                         kCCOptionPKCS7Padding|kCCOptionECBMode,
                                         strkey,
                                         kCCKeySizeDES,
                                         NULL,
                                         dataIn,
                                         dataInLength,
                                         buffer,
                                         bufferSize,
                                         &outCount);
    if (cryptStatus == kCCSuccess) {
        return [[NSString alloc] initWithData:[NSData dataWithBytes:buffer length:outCount] encoding:NSUTF8StringEncoding];
    }
    return nil;
}
@end

@implementation NSString(ETCrypto)
-(NSString *)ETMD5String
{
    const char *str = [self UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *result = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return [result uppercaseString];
}
- (NSString*)ETURLEncodedString
{
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    
    return encodedString;
}
-(NSString *)ETBase64String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}
-(NSString *)ETCRC32String
{
    return nil;
}
-(NSString *)encryptWithKey:(NSString *)key
                  algorithm:(ETCryptoAlgorithm)algorithm
                     encode:(ETEncodeAlgorithm)encode
{
    return [[[self dataUsingEncoding:NSUTF8StringEncoding] encryptWithKey:key algorithm:algorithm] stringWithEncode:encode];
}

-(NSString *)decryptWithKey:(NSString *)key
                  algorithm:(ETCryptoAlgorithm)algorithm
                     encode:(ETEncodeAlgorithm)encode
{
    return nil;
}
@end

@implementation NSData(ETCrypto)

-(NSData *)hashWithAlgorithm:(ETHashAlgorithm)algorithm
{
    switch (algorithm) {
        case ETHashAlgorithmMD2: {
            unsigned char hashByte[CC_MD2_DIGEST_LENGTH];
            CC_MD2(self.bytes, (CC_LONG)self.length, hashByte);
            return [NSData dataWithBytes:hashByte length:CC_MD2_DIGEST_LENGTH];
            break;
        }
        case ETHashAlgorithmMD4: {
            unsigned char hashByte[CC_MD5_DIGEST_LENGTH];
            CC_MD4(self.bytes, (CC_LONG)self.length, hashByte);
            return [NSData dataWithBytes:hashByte length:CC_MD5_DIGEST_LENGTH];
            break;
        }
        case ETHashAlgorithmMD5: {
            unsigned char hashByte[CC_MD5_DIGEST_LENGTH];
            CC_MD5(self.bytes, (CC_LONG)self.length, hashByte);
            return [NSData dataWithBytes:hashByte length:CC_MD5_DIGEST_LENGTH];
            break;
        }
        case ETHashAlgorithmSHA1: {
            unsigned char hashByte[CC_SHA1_DIGEST_LENGTH];
            CC_SHA1(self.bytes, (CC_LONG)self.length, hashByte);
            return [NSData dataWithBytes:hashByte length:CC_SHA1_DIGEST_LENGTH];
            break;
        }
        case ETHashAlgorithmSHA224: {
            unsigned char hashByte[CC_SHA224_DIGEST_LENGTH];
            CC_SHA224(self.bytes, (CC_LONG)self.length, hashByte);
            return [NSData dataWithBytes:hashByte length:CC_SHA224_DIGEST_LENGTH];
            break;
        }
        case ETHashAlgorithmSHA256: {
            unsigned char hashByte[CC_SHA256_DIGEST_LENGTH];
            CC_SHA256(self.bytes, (CC_LONG)self.length, hashByte);
            return [NSData dataWithBytes:hashByte length:CC_SHA256_DIGEST_LENGTH];
            break;
        }
        case ETHashAlgorithmSHA384: {
            unsigned char hashByte[CC_SHA384_DIGEST_LENGTH];
            CC_SHA384(self.bytes, (CC_LONG)self.length, hashByte);
            return [NSData dataWithBytes:hashByte length:CC_SHA384_DIGEST_LENGTH];
            break;
        }
        case ETHashAlgorithmSHA512: {
            unsigned char hashByte[CC_SHA512_DIGEST_LENGTH];
            CC_SHA512(self.bytes, (CC_LONG)self.length, hashByte);
            return [NSData dataWithBytes:hashByte length:CC_SHA512_DIGEST_LENGTH];
            break;
        }
        default: {
            break;
        }
    }
    return nil;
}
-(NSString *)stringWithEncode:(ETEncodeAlgorithm)algorithm
{
    switch (algorithm) {
        case ETEncodeAlgorithmBase64: {
            return [self base64EncodedStringWithOptions:0];
            break;
        }
        case ETEncodeAlgorithmHex: {
            return [[self description] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            break;
        }
        default: {
            break;
        }
    }
}
-(NSData *)encryptWithKey:(NSString *)key algorithm:(ETCryptoAlgorithm)algorithm
{
    int keysize = algorithm==ETCryptoAlgorithmAES128?kCCBlockSizeAES128:kCCBlockSizeDES;
    int options = algorithm==ETCryptoAlgorithmAES128?(kCCOptionPKCS7Padding|kCCOptionECBMode):kCCOptionPKCS7Padding;
    int alogo = algorithm==ETCryptoAlgorithmAES128?kCCAlgorithmAES128:kCCAlgorithmDES;
    int blockSize = algorithm==ETCryptoAlgorithmAES128?kCCBlockSizeAES128:kCCBlockSizeDES;
    size_t dataInLength = self.length;
    size_t bufferSize = dataInLength+blockSize;
    unsigned char  buffer[bufferSize];
    size_t outCount ;
    CCCryptorStatus cryptStatus =CCCrypt(kCCEncrypt,
                                         alogo,
                                         options,
                                         [key UTF8String],
                                         keysize,
                                         NULL,
                                         self.bytes,
                                         dataInLength,
                                         buffer,
                                         bufferSize,
                                         &outCount);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytes:buffer length:outCount];
    }
    return nil;
}
-(NSData *)decryptWithKey:(NSString *)key algorithm:(ETCryptoAlgorithm)algorithm
{
    return nil;
}
@end