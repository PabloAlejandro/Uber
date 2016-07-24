//
//  ServerRequestUtils.h
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HTTP_METHOD_GET = 0,
    HTTP_METHOD_PUT = 1,
    HTTP_METHOD_POST = 2,
    HTTP_METHOD_DELETE = 3
} HTTP_METHOD;

/**
 * Interface to build standard server requests in GET format.
 */
@interface ServerRequestUtils : NSObject

/* Supported parameter types by key */
+ (NSString *)addObject:(NSObject *)value key:(NSString *)key toRequest:(NSString *)request;

/* New NSURLRequest */
+ (NSMutableURLRequest *)newRequestWithUrl:(NSString *)url timeoutInterval:(NSTimeInterval)timeout;

/* Add parameters to NSURLRequest */
+ (NSMutableURLRequest *)addToken:(NSString *)token toURLRequest:(NSMutableURLRequest *)request;
+ (NSMutableURLRequest *)addReferer:(NSURL *)referer toURLRequest:(NSMutableURLRequest *)request;
+ (NSMutableURLRequest *)addRequestKey:(NSString *)key toURLRequest:(NSMutableURLRequest *)request;
+ (NSMutableURLRequest *)addRequestSecretKey:(NSString *)key toURLRequest:(NSMutableURLRequest *)request;
+ (NSMutableURLRequest *)addUserAgent:(NSString *)key toURLRequest:(NSMutableURLRequest *)request;

/* Process server response */
+ (void)processData:(NSData *)data done:(void (^)(NSObject *object, NSError *error))doneBlock;

/**
 * Get method name for a given method type
 * @param method HTTP method [ GET, PUT, POST, DELETE ]
 * @returns NSString method name
 */
+ (NSString *)methodName:(HTTP_METHOD)method;

@end
