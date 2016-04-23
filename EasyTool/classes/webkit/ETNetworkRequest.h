//
//  ETNetworkRequest.h
//  EasyTool
//
//  Created by supertext on 14-10-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EasyTools/ETDefinition.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ETNetworkRequestMethod)
{
    ETNetworkRequestMethodGET,
    ETNetworkRequestMethodPOST,
};
ET_EXTERN NSString *const kETHeaderCodeKey;//use this kETHeaderCodeKey to set the @(errorCode) in header dictionnary
ET_EXTERN NSString *const kETHeaderMeesageKey;//use this key kETHeaderMeesageKey set the errorMessage in header dictionnary
ET_EXTERN NSString *const ETNetworkErrorDomain;//this error domian means the http request is successfull but analyze content failed.
typedef NS_ENUM(NSInteger, ETNetworkErrorCode)
{
    ETNetworkErrorCodeUnknown,
    ETNetworkErrorCodeNoanalyzer,
    ETNetworkErrorCodeAnalyzeFailed,
    ETNetworkErrorCodeBusiness
};

@class ETNetworkResponse;
@protocol ETNetworkRequest <NSObject>
@required
/*!
 *  @Author 14-11-18 14:11:59
 *
 *  @brief  the ETNetworkRequestType value
 *
 *  @return the ETNetworkRequestType value
 */
-(ETNetworkRequestMethod)requestMethod;
/*!
 *  @Author 14-11-18 14:11:10
 *
 *  @brief  the last send params
 *
 *  @return params
 */
-(NSDictionary *)params;
/*!
 *  @Author 14-10-30 17:10:49
 *
 *  @brief subclass must implement this method. The url can relative url or absolut url
 *
 *  @return the request url
 */
-(NSString *)requestURL;//subclass must implement this method and relative to the BaseURL in the  HTTPRequest

/*!
 *  @author 15-02-14 18:02:10
 *
 *  @brief  the impl class implement this method to set response info to the ETNetworRespone. if dos't implement this method the ETNetworRespone object will be original object
 *
 *  @param  returnedObject the original object
 *  @return header         ETNetworkResponse.header
 *  @return extends        ETNetworkResponse.extends
 *  @return error          if some error occur error != nil 
 *  @return to ETNetworkResponse.entityObjec
 */
-(nullable id)analysisResponseObject:(id)returnedObject header:(NSDictionary  * __nullable  __autoreleasing  * __nullable)header extends:(id __nullable * __nullable)extends error:(NSError * __nullable __autoreleasing  * __nullable)error;
@optional
/*!
 *  @author 15-02-15 11:02:26
 *
 *  @brief  this method is called before the request will be send. user can implement it to filter what request can be send
 *
 *  @param directReturnedObject may be cached object. it will be use as the returnedObject when return NO.
 *  @param error                if some error occur you can get detail from it;
 *
 *  @return  YES means  it can be send so the directReturnedObject an error will be ignored .defaut is YES.
 */
-(BOOL)prepareForSending:(__autoreleasing id __nullable * __nullable)directReturnedObject error:(NSError *__nullable __autoreleasing * __nullable)error;
/*!
 *  @author 15-03-30 18:03:38
 *
 *  @brief  called when the operation did completed
 *
 *  @param response  the result response
 *  @param error     error info or nil
 *  @param operation the operation ,NSOperation or NSURLSessionTask
 */
-(void)finishedWithResponse:(ETNetworkResponse *)response error:(nullable NSError *)error task:(NSURLSessionDataTask *)operation;
@end
/*!
 *  @Author 14-11-18 15:11:29
 *
 *  @brief  the Architecture impl class by default params=nil requestURL=nil requestMethod=ETNetworkMethodGET.
 *          the subcalss must overwrite protocol methods to change it
 */
NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETDesignedRequest : NSObject<NSCopying,ETNetworkRequest>
+(instancetype)defaultRequest;//return the default params request
+(instancetype)requestWithRequest:(ETDesignedRequest *)other;
-(void)setParam:(nullable NSString *)param forKey:(NSString *)key;
-(nullable NSString *)paramForKey:(NSString *)key;
@end

NS_CLASS_AVAILABLE_IOS(7_0)
@interface ETSimpleRequest : NSObject<ETNetworkRequest>//the simpleness url implement class.if you use this request you may don't care about the response data.
-(instancetype)initWithURL:(NSString *)url method:(ETNetworkRequestMethod)requestMethod params:(nullable NSDictionary *)params;
+(instancetype)requestWithURL:(NSString *)url method:(ETNetworkRequestMethod)requestMethod params:(nullable NSDictionary *)params;
@end

@interface ETUploadObject : NSObject;
@property(nonatomic,strong,nullable)NSData   *data;
@property(nonatomic,strong,nullable)NSString *name;
@property(nonatomic,strong,nullable)NSString *fileName;
@property(nonatomic,strong,nullable)NSString *mimeType;
@end

@protocol ETUploadProtocol <ETNetworkRequest>
-(NSArray<ETUploadObject *> *)uploadObjects;
@optional
-(void)finishedWithResponse:(ETNetworkResponse *)response error:(nullable NSError *)error task:(NSURLSessionUploadTask *)taskOperator;
@end
@protocol ETDownloadProtocol<ETNetworkRequest>
-(NSURL *)fileURLWithResponse:(NSURLResponse *)response downloadURL:(NSURL *)url;
@optional
-(void)finishedWithResponse:(ETNetworkResponse *)response error:(nullable NSError *)error task:(NSURLSessionDownloadTask *)taskOperator;
@end
NS_ASSUME_NONNULL_END

