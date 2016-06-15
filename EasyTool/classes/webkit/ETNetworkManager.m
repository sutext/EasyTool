//
//  ETNetworkManager.m
//  EasyTool
//
//  Created by supertext on 14-10-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETNetworkManager.h>
#import <EasyTools/ETNetworkResponse.h>
#import <EasyTools/ETNetworkRequest.h>
#import <EasyTools/AFNetworking.h>

NSString *const ETNetworkStatusDidChangedNotification =@"com.icegent.easytools.ETNetworkStatusDidChangedNotification";
NSString *const kETNetworkStatusKey=@"com.icegent.easytools.kETNetworkStatusKey";

@interface ETNetworkManager()
@property (nonatomic,strong)AFNetworkReachabilityManager *reachabilityManager;
@property (nonatomic,strong)AFHTTPSessionManager *sessionManager;
@property (nonatomic,strong)dispatch_queue_t analyzingQueue;
@property (nonatomic,copy)NSString *baseURL;
@property (nonatomic)NSTimeInterval timeoutInterval;
@property (nonatomic)BOOL debugEnable;
@property (nonatomic)ETNetworkStatus status;
@end

@interface ETNetworkResponse(privateMethods)
+(instancetype)__analysisObject:(id)returnedObject relativeRequest:(id<ETNetworkRequest>)request error:(NSError * __autoreleasing *)error;
@end

@implementation ETNetworkManager
- (void)dealloc
{
    [self stopMonitoring];
}
- (instancetype)initWithBaseURL:(NSString *)baseURL monitorName:(NSString *)monitorName timeoutInterval:(NSTimeInterval)timeoutInterval
{
    self = [super init];
    if (self) {
        self.baseURL =baseURL;
        self.timeoutInterval = timeoutInterval;
        //monitor
        self.status=ETNetworkStatusUnknown;
        AFNetworkReachabilityManager *reachable=nil;
        if (monitorName) {
            reachable=[AFNetworkReachabilityManager managerForDomain:monitorName];
        }
        else
        {
            reachable=[AFNetworkReachabilityManager sharedManager];
        }
        __weak __typeof(self) weakself=self;
        [reachable setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            __strong __typeof(weakself) strongself=weakself;
            strongself.status=(ETNetworkStatus)status;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongself.statusChangedBlock) {
                    strongself.statusChangedBlock(strongself.status);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:ETNetworkStatusDidChangedNotification object:self userInfo:@{kETNetworkStatusKey:@(status)}];
            });
        }];
        self.reachabilityManager =reachable;
        self.analyzingQueue = dispatch_queue_create("com.icegent.easytools.ETNetworkAnalyzingQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}
-(AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        AFHTTPSessionManager * sessionManager =[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:self.baseURL] sessionConfiguration:[self sessionConfiguration]];
        sessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        sessionManager.securityPolicy.allowInvalidCertificates = YES;
        sessionManager.securityPolicy.validatesDomainName = NO;
        sessionManager.requestSerializer.timeoutInterval = self.timeoutInterval;
        sessionManager.responseSerializer.acceptableContentTypes=nil;
        sessionManager.reachabilityManager = self.reachabilityManager;
        sessionManager.completionQueue = self.analyzingQueue;
        self.sessionManager =sessionManager;
    }
    return _sessionManager;
}
#pragma mark - - interface methods
-(BOOL)isReachable
{
    return [self isReachableWiFi]||[self isReachableWWAN];
}

-(BOOL)isReachableWiFi
{
    return self.status==ETNetworkStatusReachableWiFi;
}

-(BOOL)isReachableWWAN
{
    return self.status=ETNetworkStatusReachableWWAN;
}

-(ETNetworkStatus)networkStatus
{
    return self.status;
}
-(void)startMonitoring
{
    [self.reachabilityManager startMonitoring];
}
-(void)stopMonitoring
{
    [self.reachabilityManager stopMonitoring];
}
-(void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}
#pragma mark -- private methods
-(BOOL)checkRequest:(id<ETNetworkRequest>)request
{
    if (request
        &&[request conformsToProtocol:@protocol(ETNetworkRequest)]
        &&[request respondsToSelector:@selector(requestMethod)]
        &&[request respondsToSelector:@selector(requestURL)]
        &&[request respondsToSelector:@selector(params)])
    {
        return YES;
    }
    return NO;
}


-(void)request:(id<ETNetworkRequest>)request
  didCompleted:(ETNetworkResponse *)response
         error:(NSError *)error
completedBlock:(void (^)(id<ETNetworkRequest> req, ETNetworkResponse *resp, NSError *ncerr))completedBlock
      operator:(id)operator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([request respondsToSelector:@selector(finishedWithResponse:error:task:)])
        {
            [request finishedWithResponse:response error:error task:operator];
        }
        if (completedBlock)
        {
           completedBlock(request,response,error);
        }
    });
}

-(void)handleFilterWithBlock:(void (^)(id<ETNetworkRequest> req, ETNetworkResponse *resp, NSError *ncerr))completedBlock
                 responseObj:(id)responseObject
                  andRequest:(id<ETNetworkRequest>)request
                       error:(NSError *)error
{
    if (self.debugEnable)
    {
        NSLog(@"ETNetworkManager:the request have be filered and returned  :\n%@",responseObject);
    }
    if (!error)
    {
        ETNetworkResponse *ncresp=[ETNetworkResponse __analysisObject:responseObject
                                                      relativeRequest:request
                                                                error:&error];
        [self request:request
         didCompleted:ncresp
                error:error
       completedBlock:completedBlock
         operator:nil];
    }
    else
    {
        [self request:request
         didCompleted:nil
                error:error
       completedBlock:completedBlock
         operator:nil];
    }
}
-(void)successWithBlock:(void (^)(id<ETNetworkRequest> req, ETNetworkResponse *resp, NSError *ncerr))completeBlock
            responseObj:(id)responseObject
             andRequest:(id<ETNetworkRequest>)request
               operator:(id)operator
{
    if (self.debugEnable)
    {
        NSLog(@"ETNetworkManager:the original response :\n%@",responseObject);
    }
    NSError *error;
    ETNetworkResponse *ncresp=[ETNetworkResponse __analysisObject:responseObject
                                                  relativeRequest:request
                                                            error:&error];
    [self request:request
     didCompleted:ncresp
            error:error
   completedBlock:completeBlock
         operator:operator];
    
}
-(void)failWithBlock:(void (^)(id<ETNetworkRequest> req, ETNetworkResponse *resp, NSError *ncerr))completedBlock
          andRequest:(id<ETNetworkRequest>)request
            andError:(NSError *)error
            operator:(id)operator
{
    if (self.debugEnable)
    {
        NSLog(@"ETNetworkManager:an error occur :\n%@",error);
    }
    
    [self request:request
     didCompleted:nil
            error:error
   completedBlock:completedBlock
         operator:operator];
}

#pragma mark -- session methods

-(NSURLSessionConfiguration *)sessionConfiguration
{
    return nil;
}
-(NSURLSessionDataTask *)datataskWithRequest:(id<ETNetworkRequest>)request
                              completedBlock:(nullable void (^)(id<ETNetworkRequest>, ETNetworkResponse *, NSError *))completedBlock
{
    return  [self datataskWithRequest:request progress:nil completedBlock:completedBlock];
}
-(NSURLSessionDataTask *)datataskWithRequest:(id<ETNetworkRequest>)request
                                    progress:(nullable void (^) ( NSProgress * _Nonnull ))progress
                              completedBlock:(nullable void (^)(id<ETNetworkRequest>, ETNetworkResponse *, NSError *))completedBlock
{
    NSAssert([self checkRequest:request], @"the request must implement all the @required methods!!");
    if (self.status==ETNetworkStatusNotReachable)
    {
        if (completedBlock)
        {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:@{@"message":@"network not reachable"}];
            [self request:request didCompleted:nil error:error completedBlock:completedBlock operator:nil];
        }
        return nil;
    }
    NSString *requestURL = [request requestURL];
    NSDictionary *params = [request params];
    if (self.debugEnable)
    {
        NSLog(@"ETNetworkManager:\nThe baseURL:\n%@\nThe requestURL:\n%@\nThe request params:\n%@",self.sessionManager.baseURL,requestURL,params);
    }
    NSURLSessionDataTask *task=nil;
    switch (request.requestMethod)
    {
        case ETNetworkRequestMethodGET:
        {
            task = [self.sessionManager GET:requestURL
                                 parameters:params
                                   progress:progress
                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self successWithBlock:completedBlock responseObj:responseObject andRequest:request operator:task];
            }
                                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self failWithBlock:completedBlock andRequest:request andError:error operator:task];
            }];
        }break;
        case ETNetworkRequestMethodPOST:
        {
            task=[self.sessionManager POST:requestURL
                                parameters:params
                                  progress:progress
                                   success:^(NSURLSessionDataTask *task, id responseObject)
            {
                [self successWithBlock:completedBlock responseObj:responseObject andRequest:request operator:task];
            }
                                   failure:^(NSURLSessionDataTask *task, NSError *error)
            {
                [self failWithBlock:completedBlock andRequest:request andError:error operator:task];
            }];
        }break;
        default:
            break;
    }
    return task;
}

-(BOOL)checkUploadRequest:(id<ETUploadProtocol>)request
{
    if ([self checkRequest:request]) {
        return [request conformsToProtocol:@protocol(ETUploadProtocol)]
        &&[request respondsToSelector:@selector(uploadObjects)];
    }
    return NO;
}
-(NSURLSessionUploadTask *)uploadWithRequest:(id<ETUploadProtocol>)request
                                    progress:(nullable void (^) ( NSProgress * _Nonnull ))progress
                              completedBlock:(void (^)(id<ETUploadProtocol>, ETNetworkResponse *, NSError *))completedBlock
{
    NSAssert([self checkUploadRequest:request], @"the upload request must implement all the @required methods!!");
    NSDictionary *params = [request params];
    NSString *requestURL = [self.sessionManager.baseURL.absoluteString stringByAppendingPathComponent:[request requestURL]];
    NSArray *uploadObjects = [request uploadObjects];
    if (self.debugEnable)
    {
        NSLog(@"ETNetworkManager:the request params:\n%@\n the request URL path:\n%@",params,requestURL);
    }
    NSError *error;
    NSURLRequest *uploadRequest = [self.sessionManager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:requestURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [uploadObjects enumerateObjectsUsingBlock:^(ETUploadObject * upobj, NSUInteger idx, BOOL *stop) {
            [formData appendPartWithFileData:upobj.data name:upobj.name fileName:upobj.fileName mimeType:upobj.mimeType];
        }];
    } error:&error];
    
    NSURLSessionUploadTask * uploadTask =  [self.sessionManager uploadTaskWithRequest:uploadRequest
                                                                             fromData:nil
                                                                             progress:progress
                                                                    completionHandler:^(NSURLResponse * respones, id responseObject, NSError * error)
    {
        if (self.debugEnable)
        {
            NSLog(@"ETNetworkManager:the original response :\n%@",responseObject);
        }
        ETNetworkResponse *ncresp = nil;
        if (!error) {
           ncresp =[ETNetworkResponse __analysisObject:responseObject
                                       relativeRequest:request
                                                 error:&error];
        }
        [self request:request didCompleted:ncresp error:error completedBlock:completedBlock operator:uploadTask];
    }];
    [uploadTask resume];
    return uploadTask;
}
-(BOOL)checkDownloadRequest:(id<ETDownloadProtocol>)request
{
    if ([self checkRequest:request]) {
        return [request conformsToProtocol:@protocol(ETDownloadProtocol)]
        &&[request respondsToSelector:@selector(fileURLWithResponse:downloadURL:)];
    }
    return NO;
}
-(NSURLSessionDownloadTask *)downloadWithRequest:(id<ETDownloadProtocol>)request
                                        progress:(nullable void (^) ( NSProgress * _Nonnull ))progress
                                  completedBlock:(void (^)(id<ETDownloadProtocol>, ETNetworkResponse *, NSError *))completedBlock
{
    NSAssert([self checkDownloadRequest:request], @"the download request must implement all the @required methods!!");
    NSDictionary *params = [request params];
    NSString *requestURL = [self.sessionManager.baseURL.absoluteString stringByAppendingPathComponent:[request requestURL]];
    NSURLRequest *downloadRequest = [self.sessionManager.requestSerializer requestWithMethod:@"GET" URLString:requestURL parameters:params error:nil];
    NSURLSessionDownloadTask * downloadTask = [self.sessionManager downloadTaskWithRequest:downloadRequest
                                                                                  progress:progress
                                                                               destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
    {
        return [request fileURLWithResponse:response downloadURL:targetPath];
    }
                                                                         completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
    {
        if (completedBlock) {
            completedBlock(request,nil,error);
        }
    }];
    [downloadTask resume];
    return downloadTask;
}

@end