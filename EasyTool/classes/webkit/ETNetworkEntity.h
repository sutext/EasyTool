//
//  ETNetworkEntity.h
//  EasyTool
//
//  Created by supertext on 14-10-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETNetworkEntity : NSObject<NSCoding,NSCopying>
-(instancetype)initWithDictionary:(nullable NSDictionary *)dic;
-(void)replaceForOther:(__kindof ETNetworkEntity*)other;
-(void)aweakFromData;//subclass overwite this method for its initliaz
-(nullable id)objectForKey:(NSString *)key;
-(nullable NSString *)stringForKey:(NSString *)key;
+(nullable NSArray<__kindof ETNetworkEntity *> *)translateDicarray:(NSArray *)dicary toEntityList:(Class)entityClass error:(NSError * __nullable __autoreleasing  * __nullable)error;
@end
NS_ASSUME_NONNULL_END