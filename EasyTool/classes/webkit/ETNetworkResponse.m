//
//  ETNetworkResponse.m
//  EasyTool
//
//  Created by supertext on 14-10-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETNetworkResponse.h>
#import <EasyTools/ETNetworkRequest.h>
@interface ETNetworkResponse()
@property(nonatomic,readwrite,strong)id entiyObject;
@property(nonatomic,readwrite,strong)id extends;
@property(nonatomic,readwrite,strong)NSDictionary *header;//the header info

@end
@implementation ETNetworkResponse
+(instancetype)__analysisObject:(id)returnedObject relativeRequest:(id<ETNetworkRequest>)request error:(NSError * __autoreleasing *)error
{
    id extends=nil;
    NSDictionary *header=nil;
    NSError *therror=nil;
    id entityObject = [request analysisResponseObject:returnedObject header:&header extends:&extends error:&therror];
    if ([request isKindOfClass:[ETSimpleRequest class]])
    {
        ETNetworkResponse *response=[[[self class] alloc] init];
        response.entiyObject=entityObject;
        return response;
    }
    if (!therror) {
        ETNetworkResponse *response=[[[self class] alloc] init];
        response.entiyObject=entityObject;
        response.extends=extends;
        response.header=header;
        return response;
    }
    if (error) {
        *error = therror;
    }
    return nil;
}
@end