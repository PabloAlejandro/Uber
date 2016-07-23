//
//  ServerRequestUtils.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "ServerRequestUtils.h"

static NSString * const kTokenAuthorizationKey = @"Authorization";
static NSString * const kRefererKey = @"Referer";
static NSString * const kRequestKey = @"X-Client-ID";
static NSString * const kRequestSecretKey = @"X-Client-Secret";
static NSString * const kUserAgent = @"User-Agent";

static NSString * const methods[] = {
    [HTTP_METHOD_GET] = @"GET",
    [HTTP_METHOD_PUT] = @"PUT",
    [HTTP_METHOD_POST] = @"POST",
    [HTTP_METHOD_DELETE] = @"DELETE",
};

@implementation ServerRequestUtils

#pragma mark - URL Request string compositing methods

+ (NSString *)addObject:(NSObject *)value key:(NSString *)key toRequest:(NSString *)request {
    
    if([request rangeOfString:@"/?"].location != NSNotFound || [request rangeOfString:@"?"].location != NSNotFound) {
        return [NSString stringWithFormat:@"%@&%@=%@", request, key, value];
    }
    else {
        return [NSString stringWithFormat:@"%@?%@=%@", request, key, value];
    }
}

+ (NSString *)methodName:(HTTP_METHOD)method
{
    return methods[method];
}

#pragma mark - URL Request generic string compositing methods

// NSURLRequest

+ (NSMutableURLRequest *)addToken:(NSString *)token toURLRequest:(NSMutableURLRequest *)request
{
    if(token)
        [request addValue:token forHTTPHeaderField: kTokenAuthorizationKey];
    
    return request;
}

+ (NSMutableURLRequest *)addReferer:(NSURL *)referer toURLRequest:(NSMutableURLRequest *)request
{
    if(referer)
        [request addValue:[referer absoluteString] forHTTPHeaderField: kRefererKey];
    
    return request;
}

+ (NSMutableURLRequest *)addRequestKey:(NSString *)key toURLRequest:(NSMutableURLRequest *)request
{
    if(key)
        [request addValue:key forHTTPHeaderField: kRequestKey];
    
    return request;
}

+ (NSMutableURLRequest *)addRequestSecretKey:(NSString *)key toURLRequest:(NSMutableURLRequest *)request
{
    if(key)
        [request addValue:key forHTTPHeaderField: kRequestSecretKey];
    
    return request;
}

+ (NSMutableURLRequest *)addUserAgent:(NSString *)userAgent toURLRequest:(NSMutableURLRequest *)request
{
    if(userAgent)
        [request addValue:userAgent forHTTPHeaderField: kUserAgent];
    
    return request;
}

+ (NSMutableURLRequest *)newRequestWithUrl:(NSString *)url timeoutInterval:(NSTimeInterval)timeout
{
    NSString *encoded = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encoded] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    
    [request setHTTPShouldHandleCookies:NO];
    
    return request;
}

+ (void)processData:(NSData *)data done:(void (^)(NSObject *object, NSError *error))doneBlock
{
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error != nil) {
        // Bad json format
        error = [NSError errorWithDomain:@"Bad json format" code:499 userInfo:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            doneBlock(nil, error);
        });
        return;
    }
    
    if([jsonDictionary isKindOfClass:[NSDictionary class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            doneBlock(jsonDictionary, nil);
        });
        return;
    }
    else if([jsonDictionary isKindOfClass:[NSArray class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            doneBlock((NSArray *)jsonDictionary, nil);
        });
        return;
    }
    
    error = [NSError errorWithDomain:@"Unexpected content format" code:499 userInfo:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        doneBlock(nil, error);
    });
}

@end
