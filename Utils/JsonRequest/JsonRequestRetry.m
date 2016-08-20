//
//  JsonRequestRetry.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "JsonRequestRetry.h"
#import "RequestsManager.h"

static NSTimeInterval const kMinTimeInterval = 5;

@interface JsonRequestRetry ()

@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic, strong) RequestsManager *request;

@end

@implementation JsonRequestRetry

- (instancetype)initWithUrl:(NSURL *)url parameters:(NSDictionary *)parameters httpHeaderFields:(NSDictionary *)httpHeaderFields method:(HTTP_METHOD)method referer:(NSURL *)referer requestKey:(NSString *)requestKey requestSecretKey:(NSString *)requestSecretKey userAgent:(NSString *)userAgent data:(NSData *)data userToken:(NSString *)userToken
{
    if(self = [super init]) {
        _url = url;
        _parameters = parameters;
        _httpHeaderFields = httpHeaderFields;
        _method = method;
        _referer = referer;
        _requestKey = requestKey;
        _requestSecretKey = requestSecretKey;
        _userAgent = userAgent;
        _data = data;
        _userToken = userToken;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithUrl:nil parameters:nil httpHeaderFields:nil method:HTTP_METHOD_GET referer:nil requestKey:nil requestSecretKey:nil userAgent:nil data:nil userToken:nil];
}

- (instancetype)initWithUrl:(NSURL *)url
{
    return [self initWithUrl:url parameters:nil httpHeaderFields:nil method:HTTP_METHOD_GET referer:nil requestKey:nil requestSecretKey:nil userAgent:nil data:nil userToken:nil];
}

- (NSURLSessionDataTask *)retrieveDataWithCompletion:(RequestResultBlock)completion
{
    self.completion = completion;
    self.request.timeout = self.timeout;
    self.request.debug = NO;
    
    NSAssert(self.url != nil, @"URL can't be null");
    NSAssert(self.completion != nil, @"Completion can't be null");
    
    __weak typeof(self) weakSelf = self;
    return [self.request getObjectFromUrl:self.url parameters:self.parameters httpHeaderFields:self.httpHeaderFields method:[ServerRequestUtils methodName:self.method] referer:self.referer requestKey:self.requestKey requestSecretKey:self.requestSecretKey userAgent:self.userAgent data:self.data userToken:self.userToken done:^(NSObject *object, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf handleResponse:object error:error];
    }];
}

- (NSURLSessionDataTask *)retrieveDataForUrl:(NSURL *)url completionBlock:(RequestResultBlock)completion
{
    self.url = url;
    return [self retrieveDataWithCompletion:completion];
}

#pragma mark - Private methods

- (void)handleResponse:(NSObject *)object error:(NSError *)error
{
    if(error == nil) {
        
        self.timeInterval = kMinTimeInterval;
        self.completion(object, nil);
    }
    else {
        
        // TODO: We can implement different options:
        // - Retry after a time (I recommend using Reachability library in order to check network connection)
        // - Let the user to manually retry with a popup (this option requires to implement a
        // delegate or callback in order to notify the parent)
        // - Implement other ways to manually retry (this also requires to notify the paren object)
        
        /**
         * This is an example of how we could catch the download error
         */
        // if(networkAvailable) ...
        [self performSelector:@selector(retrieveDataWithCompletion:) withObject:self.completion afterDelay:self.timeInterval];
        
        // We increase the time interval for the next try
        self.timeInterval *= 2;
    }
}

#pragma mark - Getters

- (NSTimeInterval)timeInterval
{
    if(_timeInterval <= 0) {
        _timeInterval = kMinTimeInterval;
    }
    return _timeInterval;
}

- (RequestsManager *)request
{
    if(_request == nil) {
        _request = [RequestsManager new];
    }
    return _request;
}

- (float)timeout
{
    if(_timeout <= 0) {
        _timeout = 30;
    }
    return _timeout;
}

@end
