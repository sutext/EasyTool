//
//  ETNetworkEntity.m
//  EasyTool
//
//  Created by supertext on 14-10-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//
#import <EasyTools/ETNetworkEntity.h>
#import <EasyTools/ETNetworkRequest.h>
@interface ETNetworkEntity()
@property(nonatomic,copy)NSDictionary *datas;
@end
@implementation ETNetworkEntity
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.datas forKey:@"datas"];
}
-(id)copyWithZone:(NSZone *)zone
{
    return [[[self class] alloc] initWithDictionary:self.datas];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if (self) {
        self.datas=[aDecoder decodeObjectForKey:@"datas"];
        [self aweakFromData];
    }
    return self;
}
-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.datas=dic;
        [self aweakFromData];
    }
    return self;
}
-(void)replaceForOther:(__kindof ETNetworkEntity *)other
{
    self.datas = other.datas;
    [self aweakFromData];
}
-(void)aweakFromData
{

}
-(id)objectForKey:(NSString *)key
{
    return [self.datas objectForKey:key];
}
-(NSString *)stringForKey:(NSString *)key
{
    id result=[self.datas objectForKey:key];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    if ([result isKindOfClass:[NSNumber class]]) {
        return [result stringValue];
    }
    return nil;
}
- (NSString *)description
{
    return  self.datas.description;
}
+(NSArray<ETNetworkEntity *> *)translateDicarray:(NSArray *)dicary toEntityList:(Class)entityClass error:(NSError *__autoreleasing  _Nullable * _Nullable)error
{
    if ([dicary isKindOfClass:[NSArray class]]&&[entityClass isSubclassOfClass:[ETNetworkEntity class]]) {
        NSMutableArray *array=[NSMutableArray array];
        [dicary enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id entity=[[entityClass alloc] initWithDictionary:obj];
            [array addObject:entity];
        }];
        return [NSArray arrayWithArray:array];
    }
    else
    {
        if (*error) {
            *error = [NSError errorWithDomain:ETNetworkErrorDomain code:ETNetworkErrorCodeNoanalyzer userInfo:@{@"message":@"data array translate error :data is't an array object or target class is't an ETNetworkEntity subclass"}];
        }
        return nil;
    }
}
@end