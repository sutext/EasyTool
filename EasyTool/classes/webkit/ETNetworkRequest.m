//
//  ETNetworkRequest.m
//  EasyTool
//
//  Created by supertext on 14-10-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETNetworkRequest.h>
#import <EasyTools/ETNetworkEntity.h>

NSString *const kETHeaderCodeKey         = @"com.icegent.easytools.kETHeaderCodeKey";
NSString *const kETHeaderMeesageKey      = @"com.icegent.easytools.kETHeaderMeesageKey";
NSString *const ETNetworkErrorDomain     = @"com.icegent.easytools.ETNetworkErrorDomain";

@interface ETDesignedRequest()
@property(nonatomic,strong)NSMutableDictionary *mutableParams;
@end

@implementation ETDesignedRequest
+(instancetype)defaultRequest
{
    return [[[self class] alloc] init];
}
+(instancetype)requestWithRequest:(ETDesignedRequest *)other
{
    return [self copy];
}
-(instancetype)copyWithZone:(NSZone *)zone
{
    ETDesignedRequest *req=[[[self class] alloc] init];
    req.mutableParams=[self.mutableParams mutableCopy];
    return req;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mutableParams=[NSMutableDictionary dictionary];
    }
    return self;
}
-(NSDictionary *)params
{
    return self.mutableParams;
}
-(NSString *)requestURL
{
    return @"";
}
-(void)setParam:(NSString *)param forKey:(NSString *)key
{
    if (key) {
        [self.mutableParams setValue:param forKey:key];
    }
}
-(NSString *)paramForKey:(NSString *)key
{
    return [self.mutableParams valueForKey:key];
}
-(ETNetworkRequestMethod)requestMethod
{
    return ETNetworkRequestMethodGET;
}
-(NSString *)description
{
    return self.mutableParams.description;
}
-(nullable id)analysisResponseObject:(id)returnedObject header:(NSDictionary *__autoreleasing  _Nullable * __nullable)header extends:(id  _Nullable __autoreleasing *__nullable)extends error:(NSError *__autoreleasing  _Nullable *__nullable)error
{
    return returnedObject;
}
@end

@interface ETSimpleRequest()
@property(nonatomic)ETNetworkRequestMethod requestMethod;
@property(nonatomic,copy)NSDictionary *params;
@property(nonatomic,copy)NSString *requestURL;
@end

@implementation ETSimpleRequest

+(instancetype)requestWithURL:(NSString *)url method:(ETNetworkRequestMethod)method params:(NSDictionary *)params
{
    return [[[self class] alloc] initWithURL:url method:method params:params];
}
- (instancetype)initWithURL:(NSString *)url method:(ETNetworkRequestMethod)method params:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        self.requestURL=url;
        self.requestMethod=method;
        self.params=params;
    }
    return self;
}
-(nullable id)analysisResponseObject:(id)returnedObject header:(NSDictionary *__autoreleasing  _Nullable * __nullable)header extends:(id  _Nullable __autoreleasing *__nullable)extends error:(NSError *__autoreleasing  _Nullable *__nullable)error
{
    return returnedObject;
}
@end

@implementation ETUploadObject


@end