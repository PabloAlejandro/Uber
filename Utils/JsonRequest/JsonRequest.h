//
//  JsonRequest.h
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerRequestUtils.h"

typedef void(^RequestResultBlock)(id result, NSDictionary * userInfo);

@interface JsonRequestRetry : NSObject

- (id)initWithUrl:(NSURL *)url;
- (id)initWithUrl:(NSURL *)url parameters:(NSDictionary *)parameters httpHeaderFields:(NSDictionary *)httpHeaderFields method:(HTTP_METHOD)method referer:(NSURL *)referer requestKey:(NSString *)requestKey requestSecretKey:(NSString *)requestSecretKey userAgent:(NSString *)userAgent data:(NSData *)data userToken:(NSString *)userToken NS_DESIGNATED_INITIALIZER;

- (void)retrieveDataWithCompletion:(RequestResultBlock)completion;
- (void)retrieveDataForUrl:(NSURL *)url completionBlock:(RequestResultBlock)completion;

@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) NSDictionary *httpHeaderFields;
@property (nonatomic) HTTP_METHOD method;
@property (nonatomic, strong) NSURL *referer;
@property (nonatomic, strong) NSString *requestKey;
@property (nonatomic, strong) NSString *requestSecretKey;
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, copy) RequestResultBlock completion;

/**
 * Timeout for requests
 */
@property (nonatomic) float timeout;

@end
