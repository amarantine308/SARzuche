//
//  FMNetworkManager.m
//  FMLibrary
//
//  Created by leks on 13-4-1.
//  Copyright (c) 2013年 House365. All rights reserved.
//

#import "FMNetworkManager.h"
#import "Reachability.h"
#import "FMStorageManager.h"

#define NETWORK_FAILED_MSG @"网络连接失败"
#define NETWORK_TIMEOUT_MSG @"请求超时"

#define TIME_OUT_SECOND_GET 10
#ifdef DEBUG
#define TIME_OUT_SECOND_POST 5
#else
#define TIME_OUT_SECOND_POST 20
#endif

@implementation FMNetworkRequest
@synthesize requestName = _requestName;
@synthesize responseData = _responseData;
@synthesize requestData = _requestData;
@synthesize networkDelegate = _networkDelegate;
@synthesize requestDelegate = _requestDelegate;
@synthesize asiHttpRequest = _asiHttpRequest;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize uploadedBytes = _uploadedBytes;
@synthesize downloadedBytes = _downloadedBytes;
@synthesize isSkipFilterRequest = _isSkipFilterRequest;

-(void)dealloc
{
    _requestDelegate = nil;
    _networkDelegate = nil;
    [self stop];
    [_requestName release];
    [_requestData release];
    [_responseData release];
    [super dealloc];
}

-(void)start
{
    _startTime = [[NSDate date] timeIntervalSince1970];
    _uploadedBytes = 0;
    _downloadedBytes = 0;
    
    [self performSelectorInBackground:@selector(delayRun) withObject:nil];
}

-(void)delayRun
{
    [_asiHttpRequest startAsynchronous];
}

-(void)stop
{
    if (!self.asiHttpRequest)
    {
        return ;
    }
    
    _endTime = [[NSDate date] timeIntervalSince1970];
    [_asiHttpRequest clearDelegatesAndCancel];
    self.asiHttpRequest = nil;
    if ([_requestDelegate respondsToSelector:@selector(fmNetworkRequestFinishedStat:)])
    {
        [_requestDelegate fmNetworkRequestFinishedStat:self];
    }
}

-(void)receivedBytes:(long long)bytes
{
    _downloadedBytes += bytes;
    _downloadedPercent = _asiHttpRequest.contentLength > 0?_downloadedBytes/_asiHttpRequest.contentLength:0;
    if ([_requestDelegate respondsToSelector:@selector(fmNetworkRequestDownloadProgressDidChanged:)])
    {
        [_requestDelegate fmNetworkRequestDownloadProgressDidChanged:self];
    }
}

-(void)sendBytes:(long long)bytes
{
    _uploadedBytes += bytes;
    _uploadedPercent = _asiHttpRequest.postLength > 0?_uploadedBytes/_asiHttpRequest.postLength:0;
    if ([_requestDelegate respondsToSelector:@selector(fmNetworkRequestUploadProgressDidChanged:)])
    {
        [_requestDelegate fmNetworkRequestUploadProgressDidChanged:self];
    }
}
@end

@implementation FMNetworkManager

-(void)dealloc
{
    [_registedInstances release];
    [super dealloc];
}

-(id)init
{
	if (self = [super init])
	{
//        [ASIHTTPRequest hideNetworkActivityIndicator];
        _registedInstances = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	}
	return self;
}

#pragma mark -
#pragma mark === 外部接口 ===
#pragma mark -
-(void)cancelNetworkRequest:(FMNetworkRequest*)networkRequest
{
    [self removeNetworkRequest:networkRequest];
}

#pragma mark -
#pragma mark === 基础Get、Post方法 ===
#pragma mark -
-(FMNetworkRequest*)addGetUrl:(NSString*)urlString
                  requestName:(NSString*)requestName
                     delegate:(id<FMNetworkProtocol>)networkDelegate
{
    FMNetworkRequest *fm_request = [[[FMNetworkRequest alloc] init] autorelease];
	fm_request.networkDelegate = networkDelegate;
    
    if (![self checkNetwork:fm_request]) {
        return nil;
    }
    
    [self registNetwork:networkDelegate];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[request setDelegate:self];
	request.timeOutSeconds = TIME_OUT_SECOND_GET;
    request.shouldAttemptPersistentConnection = NO;
    request.uploadProgressDelegate = self;
    request.downloadProgressDelegate = self;
    request.showAccurateProgress = YES;
    
	fm_request.asiHttpRequest = request;
	fm_request.requestName = requestName;

    request.userInfo = [NSDictionary dictionaryWithObject:fm_request forKey:@"NetworkRequest"];
	[self addNetworkRequest:fm_request forInstance:networkDelegate];
    [fm_request start];
    
    [request release];
    
    return fm_request;
}

-(FMNetworkRequest*)addPostUrl:(NSString*)urlString
                   requestName:(NSString*)requestName
                     formDatas:(NSDictionary*)formDatas
                      delegate:(id<FMNetworkProtocol>)networkDelegate
{
    FMNetworkRequest *fm_request = [[[FMNetworkRequest alloc] init] autorelease];
	fm_request.networkDelegate = networkDelegate;
    
    if (![self checkNetwork:fm_request]) {
        return nil;
    }
    
    [self registNetwork:networkDelegate];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[request setDelegate:self];
    request.timeOutSeconds = TIME_OUT_SECOND_POST;
    request.shouldAttemptPersistentConnection = NO;
    request.uploadProgressDelegate = self;
    request.downloadProgressDelegate = self;
    request.showAccurateProgress = YES;
    
    for (NSString *key in [formDatas allKeys])
    {
        id value = [formDatas objectForKey:key];
        if ([value isKindOfClass:[NSData class]])
        {
//            [request addData:value forKey:key];
            [request addData:value withFileName:@"pic.jpg" andContentType:@"file" forKey:key];
        }
        else
        {
            [request addPostValue:value forKey:key];
        }
    }
    
    
	fm_request.asiHttpRequest = request;
	fm_request.requestName = requestName;
	
    request.userInfo = [NSDictionary dictionaryWithObject:fm_request forKey:@"NetworkRequest"];
	[self addNetworkRequest:fm_request forInstance:networkDelegate];
    [fm_request start];
    
    [request release];
    
    return fm_request;
}

-(FMNetworkRequest*)downloadImageUrl:(NSString*)urlString
                         requestName:(NSString*)requestName
                         requestData:(NSString*)requestData
                            delegate:(id<FMNetworkProtocol>)networkDelegate
{
    FMNetworkRequest *fm_request = [[FMNetworkRequest alloc] init];
	fm_request.networkDelegate = networkDelegate;
    
    if (![self checkNetwork:fm_request]) {
        return nil;
    }
    
    [self registNetwork:networkDelegate];
    
    FMStorageManager *storage_manager = [FMStorageManager sharedInstance];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[request setDelegate:self];
	request.timeOutSeconds = TIME_OUT_SECOND_GET;
    request.shouldAttemptPersistentConnection = NO;
    request.uploadProgressDelegate = self;
    request.downloadProgressDelegate = self;
    request.showAccurateProgress = YES;
    
    NSString *downloadPath = [NSString stringWithFormat:@"%@/%@",[storage_manager getCachedImagePath], requestData];
    request.downloadDestinationPath = downloadPath;
    request.allowResumeForFileDownloads = YES;
    
	fm_request.asiHttpRequest = request;
	fm_request.requestName = requestName;
    fm_request.requestData = requestData;
    fm_request.isSkipFilterRequest = YES;
    
    request.userInfo = [NSDictionary dictionaryWithObject:fm_request forKey:@"NetworkRequest"];
    
	[self addNetworkRequest:fm_request forInstance:networkDelegate];
    
    [request release];
    
    return fm_request;
}

//encoding
-(FMNetworkRequest*)addPostUrl:(NSString*)urlString
                   requestName:(NSString*)requestName
                     formDatas:(NSDictionary*)formDatas
                           enc:(NSStringEncoding)enc
                      delegate:(id<FMNetworkProtocol>)networkDelegate
{
    FMNetworkRequest *fm_request = [[[FMNetworkRequest alloc] init] autorelease];
	fm_request.networkDelegate = networkDelegate;
    
    if (![self checkNetwork:fm_request]) {
        return nil;
    }
    
    [self registNetwork:networkDelegate];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[request setDelegate:self];
    request.timeOutSeconds = TIME_OUT_SECOND_POST;
    request.shouldAttemptPersistentConnection = NO;
    request.uploadProgressDelegate = self;
    request.downloadProgressDelegate = self;
    request.showAccurateProgress = YES;
    request.stringEncoding = enc;
    
    for (NSString *key in [formDatas allKeys])
    {
        id value = [formDatas objectForKey:key];
        if ([value isKindOfClass:[NSData class]])
        {
            //            [request addData:value forKey:key];
            [request addData:value withFileName:@"pic.jpg" andContentType:@"file" forKey:key];
        }
        else
        {
            [request addPostValue:value forKey:key];
        }
    }
    
    
	fm_request.asiHttpRequest = request;
	fm_request.requestName = requestName;
	
    request.userInfo = [NSDictionary dictionaryWithObject:fm_request forKey:@"NetworkRequest"];
	[self addNetworkRequest:fm_request forInstance:networkDelegate];
    [fm_request start];
    
    [request release];
    
    return fm_request;
}

#pragma mark -
#pragma mark === 内部数据控制 ===
#pragma mark -
-(BOOL)registNetwork:(id)instanceAddress
{
    if (!instanceAddress) {
        return NO;
    }
    
    NSString *key = [FMNetworkManager keyForInstance:instanceAddress];
    @synchronized(_registedInstances)
    {
        NSMutableDictionary *instanceRequests = [_registedInstances objectForKey:key];
        if (!instanceRequests) {
            instanceRequests = [NSMutableDictionary dictionaryWithCapacity:10];
            [_registedInstances setObject:instanceRequests forKey:key];
        }
    }
    
    return YES;
}

-(BOOL)unregistNetwork:(id)instanceAddress
{
    if (!instanceAddress) {
        return NO;
    }
    NSString *key = [FMNetworkManager keyForInstance:instanceAddress];
    
    @synchronized(_registedInstances)
    {
        NSMutableDictionary *instance_requests = [_registedInstances objectForKey:key];
        
        NSArray *request_keys = [instance_requests allKeys];
        for (int i=0; i<[request_keys count]; i++)
        {
            NSString *req_key = [request_keys objectAtIndex:i];
            FMNetworkRequest *fm_request = [instance_requests objectForKey:req_key];
            
            NSString *k = [FMNetworkManager keyForInstanceData:fm_request];
            if ([key isEqualToString:k])
            {
                [fm_request stop];
            }
        }
        
        [_registedInstances removeObjectForKey:key];
    }
    
    return YES;
}

-(BOOL)checkRegist:(id)instanceAddress
{
    if (!instanceAddress) {
        return NO;
    }
    
    NSString *key = [FMNetworkManager keyForInstance:instanceAddress];
    NSObject *obj = nil;
    @synchronized(_registedInstances)
    {
        obj = [_registedInstances objectForKey:key];
    }
    
    if (obj)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)addNetworkRequest:(FMNetworkRequest*)networkRequest forInstance:(id)instance
{
    if (!networkRequest) {
        return NO;
    }
    
    @synchronized(_registedInstances)
    {
        NSString *instance_key = [FMNetworkManager keyForInstance:instance];
        NSMutableDictionary *instance_requests = [_registedInstances objectForKey:instance_key];
        if (instance_requests)
        {
            NSString *request_key = [FMNetworkManager keyForInstanceData:networkRequest];
            [instance_requests setObject:networkRequest forKey:request_key];
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)removeNetworkRequest:(FMNetworkRequest*)networkRequest
{
    if (!networkRequest) {
        return NO;
    }
    
    @synchronized(_registedInstances)
    {
        for (NSString *key1 in [_registedInstances allKeys])
        {
            NSMutableDictionary *instance_requests = [_registedInstances objectForKey:key1];
            for (NSString *key2 in [instance_requests allKeys])
            {
                FMNetworkRequest *fm_request = [instance_requests objectForKey:key2];
                if (fm_request == networkRequest)
                {
                    NSString *key = [FMNetworkManager keyForInstanceData:networkRequest];
                    [fm_request stop];
                    [instance_requests removeObjectForKey:key];
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark === ASIHttpRequest 请求返回 ===
#pragma mark -
- (void)requestFinished:(ASIHTTPRequest *)request
{
    FMNetworkRequest *fm_request = [request.userInfo objectForKey:@"NetworkRequest"];
    @synchronized(_registedInstances)
    {
        if (fm_request)
        {
            fm_request.responseData = [request responseString];
            
            if ([self filter:fm_request])
            {
                if ([self checkRegist:fm_request.networkDelegate] &&
                    [fm_request.networkDelegate respondsToSelector:@selector(fmNetworkFinished:)])
                {
                    [fm_request.networkDelegate fmNetworkFinished:fm_request];
                }
            }
            else
            {
                if ([self checkRegist:fm_request.networkDelegate] &&
                    [fm_request.networkDelegate respondsToSelector:@selector(fmNetworkFailed:)])
                {
                    [fm_request.networkDelegate fmNetworkFailed:fm_request];
                }
            }
        }
    }

	[self removeNetworkRequest:fm_request];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    FMNetworkRequest *fm_request = [request.userInfo objectForKey:@"NetworkRequest"];
    @synchronized(_registedInstances)
    {
        if (fm_request)
        {
            fm_request.responseData = NETWORK_FAILED_MSG;
            
            error = [request error];
            if (2 == error.code) {
                fm_request.responseData = NETWORK_TIMEOUT_MSG;
            }
            
            if ([self checkRegist:fm_request.networkDelegate] &&
                [fm_request.networkDelegate respondsToSelector:@selector(fmNetworkFailed:)])
            {
                [fm_request.networkDelegate fmNetworkFailed:fm_request];
            }
        }
        else
        {
            error = [request error];
        }
        
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [self removeNetworkRequest:fm_request];
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    FMNetworkRequest *fm_request = [request.userInfo objectForKey:@"NetworkRequest"];
    [fm_request receivedBytes:bytes];
}

- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
    FMNetworkRequest *fm_request = [request.userInfo objectForKey:@"NetworkRequest"];
    [fm_request sendBytes:bytes];
}

-(BOOL)checkNetwork:(FMNetworkRequest*)fm_request
{
    return YES;
    if (![FMNetworkManager isNetworkReachable])
    {
        fm_request.responseData = @"网络很不给力哦";
        if ([fm_request.networkDelegate respondsToSelector:@selector(fmNetworkFailed:)])
        {
            [fm_request.networkDelegate fmNetworkFailed:fm_request];
        }
        return NO;
    }
    
    return YES;
}

//处理返回值转换 子类继承
-(BOOL)filter:(FMNetworkRequest*)networkRequest
{
    if (networkRequest.isSkipFilterRequest) {
        return YES;
    }
    
	return NO;
}

#pragma mark -
#pragma mark === 公用工具方法 ===
#pragma mark -
+(NSString*)keyForInstance:(id)instance
{
    return [NSString stringWithFormat:@"%p", instance];
}

+(NSString*)keyForInstanceData:(id)instanceData
{
    return [NSString stringWithFormat:@"%p", instanceData];
}

+(NSString*)encodedUrlForUrlPrefix:(NSString*)prefix params:(NSDictionary*)params
{
    return [FMNetworkManager encodedUrlForUrlPrefix:prefix params:params encoding:NSUTF8StringEncoding];
}

+(NSString*)encodedUrlForUrlPrefix:(NSString*)prefix params:(NSDictionary*)params enc:(NSStringEncoding)encoding
{
    if (encoding == 0) {
        encoding = NSUTF8StringEncoding;
    }
    return [FMNetworkManager encodedUrlForUrlPrefix:prefix params:params encoding:encoding];
}
                           
+(NSString*)encodedUrlForUrlPrefix:(NSString*)prefix params:(NSDictionary*)params encoding:(NSStringEncoding)encoding
{
    NSMutableString *ms = [NSMutableString stringWithCapacity:100];
    if (prefix.length!=0)
    {
        [ms appendString:prefix];
    }
    
    NSArray *keys = [params allKeys];
    for (int i=0; i<keys.count; i++)
    {
        NSString *k = [keys objectAtIndex:i];
        NSString *value = [NSString stringWithFormat:@"%@", [params objectForKey:k]];
        if (i != 0) {
            [ms appendString:@"&"];
        }
        
        [ms appendFormat:@"%@=%@", k, value];
    }
    
    return [ms stringByAddingPercentEscapesUsingEncoding:encoding];
}

+(BOOL)isNetworkReachable
{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    return [reach isReachable];
}

+(NetworkStatus)networkReachableStatus
{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    return [reach currentReachabilityStatus];
}

+(NSString*)networkReachableDescriptionForStatus:(NetworkStatus)status
{
    NSString *statusString = nil;
	
	switch (status) {
		case kNotReachable:
			statusString = @"无网络";
			break;
		case kReachableViaWWAN:
			statusString = @"3G";
			break;
		case kReachableViaWiFi:
			statusString = @"WiFi";
			break;
	}
    return statusString;
}
@end
