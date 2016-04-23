//
//  ETNetworkManager.h
//  EasyTool
//
//  Created by supertext on 14-10-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EasyTools/ETDefinition.h>

NS_ASSUME_NONNULL_BEGIN

ET_EXTERN NSString *const ETNetworkStatusDidChangedNotification;//userinfo=@{kETNetworkStatusKey:@(newstatus)}
ET_EXTERN NSString *const kETNetworkStatusKey;//standar key in userinfo

typedef NS_ENUM(NSInteger, ETNetworkStatus)
{
    ETNetworkStatusUnknown = -1,
    ETNetworkStatusNotReachable = 0,
    ETNetworkStatusReachableWWAN = 1,
    ETNetworkStatusReachableWiFi = 2
};
@protocol ETNetworkRequest;
@class ETNetworkResponse;
@protocol ETUploadProtocol;
@protocol ETDownloadProtocol;

NS_CLASS_AVAILABLE_IOS(7_0) @interface ETNetworkManager : NSObject
/*!
 *  @Author 14-11-05 14:11:18
 *
 *  @brief  the designed constructor
 *
 *  @param baseURL         the baseURL of all the request
 *   Below are a few examples of how `baseURL` and relative paths interact:
 *   NSURL *baseURL = [NSURL URLWithString:@"http://example.com/v1/"];
 *  [NSURL URLWithString:@"foo" relativeToURL:baseURL];                  // http://example.com/v1/foo
 *  [NSURL URLWithString:@"foo?bar=baz" relativeToURL:baseURL];          // http://example.com/v1/foo?bar=baz
 *  [NSURL URLWithString:@"/foo" relativeToURL:baseURL];                 // http://example.com/foo
 *  [NSURL URLWithString:@"foo/" relativeToURL:baseURL];                 // http://example.com/v1/foo
 *  [NSURL URLWithString:@"/foo/" relativeToURL:baseURL];                // http://example.com/foo/
 *  [NSURL URLWithString:@"http://example2.com/" relativeToURL:baseURL]; // http://example2.com/
 
 *  @param monitorURL      the monitorURL of the manager wen monitoring.
 *  @param timeoutInterval the timeout interval
 *  @param successCode     the code to flag the request is ok in business
 *
 *  @return the instance of network manager.
 */
-(instancetype)initWithBaseURL:(NSString *)baseURL
                   monitorName:(NSString *)monitorName
               timeoutInterval:(NSTimeInterval)timeoutInterval;

@property(nonatomic,copy,nullable)void(^statusChangedBlock)(ETNetworkStatus networkStatus);
/*!
 *  @Author 14-11-18 14:11:05
 *
 *  @brief  the swith of debug information log.
 *
 *  @param enable enable or not
 */
-(void)setDebugEnable:(BOOL)enable;
/*!
 *  @Author 14-11-13 12:11:30
 *
 *  @brief  begin monitoring the network status. this method is async。 after monitor complete the networkStatus can be use
 */
-(void)startMonitoring;
/*!
 *  @Author 14-11-13 13:11:52
 *
 *  @brief  stop monitoring the network status.
 */
-(void)stopMonitoring;
/*!
 *  @Author 14-11-13 13:11:21
 *
 *  @brief  in order to judge the status exactly you must start monitory before
 *
 *  @return networkStatus
 */
-(ETNetworkStatus)networkStatus;// the current network status

/*!
 *  @Author 14-11-13 12:11:56
 *
 *  @brief  check self.networkStatus==ETNetworkStatusReachableWiFi or not.
 *
 *  @return reachable WiFi or not.
 */
-(BOOL)isReachableWiFi;

/*!
 *  @Author 14-11-13 12:11:01
 *
 *  @brief  check self.networkStatus==ETNetworkStatusReachableWWAN or not
 *
 *  @return reachable WWAN or not.
 */
-(BOOL)isReachableWWAN;
/*!
 *  @Author 14-11-13 12:11:55
 *
 *  @brief  chek [self isReachableViaWiFi]||[self isReachableViaWWAN] or not
 *  @return reachable or not
 */
-(BOOL)isReachable;
/*!
 *  @author 15-03-17 14:03:35
 *
 *  @brief  subclass overwrite this method to config the urlsession
 *
 *  @return the configuration object
 */
-(NSURLSessionConfiguration *)sessionConfiguration;
/**
 * @author 15-03-17 14:03:35
 * @brief Sets the value for the HTTP headers set in request objects made by the HTTP client. If `nil`, removes the existing value for that header.
 
 * @param field The HTTP header to set a default value for
 * @param value The value set as default for the specified header, or `nil`
 */
- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(NSString *)field;
/*!
 *  @author 15-03-17 15:03:34
 *
 *  @brief  begin a data request task using an ETNetworkRequest object
 *  @param request        the infomation of http request
 *  @param completedBlock the callback when task over
 *  @return the datatask
 */

-(nullable NSURLSessionDataTask *)datataskWithRequest:(id<ETNetworkRequest>)request
                                       completedBlock:(nullable void (^) (_Nullable id<ETNetworkRequest> request, ETNetworkResponse * _Nullable response,NSError * _Nullable error)) completedBlock;

-(nullable NSURLSessionDataTask *)datataskWithRequest:(id<ETNetworkRequest>)request
                                             progress:(nullable void (^) ( NSProgress * _Nonnull ))progress
                                       completedBlock:(nullable void (^) (_Nullable id<ETNetworkRequest> request, ETNetworkResponse * _Nullable response,NSError * _Nullable error)) completedBlock;

-(nullable NSURLSessionUploadTask *)uploadWithRequest:(id<ETUploadProtocol>)request
                                             progress:(nullable void (^) ( NSProgress * _Nonnull ))progress
                                       completedBlock:(nullable void (^) (_Nullable id<ETUploadProtocol> request,ETNetworkResponse * _Nullable response,NSError * _Nullable error)) completedBlock;

-(nullable NSURLSessionDownloadTask *)downloadWithRequest:(id<ETDownloadProtocol>)request
                                                 progress:(nullable void (^) ( NSProgress * _Nonnull ))progress
                                           completedBlock:(nullable void (^) (_Nullable id<ETDownloadProtocol> request,ETNetworkResponse * _Nullable response,NSError * _Nullable error)) completedBlock;

@end
NS_ASSUME_NONNULL_END


