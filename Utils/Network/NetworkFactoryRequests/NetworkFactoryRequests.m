//
//  NetworkFactoryRequests.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "NSURLSession+Factory.h"

@implementation NSURLSession (Factory)

+ (NSURLSessionDataTask *)sendAsynchronousRequest:(NSURLRequest *)request
              completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:completionHandler];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *)getTaskForAsynchronousRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error)) completionHandler
{
    NSURLSession *session = [NSURLSession sharedSession];
    return [session dataTaskWithRequest:request
                      completionHandler:completionHandler];
}

@end
