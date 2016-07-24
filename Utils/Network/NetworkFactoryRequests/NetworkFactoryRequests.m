//
//  NetworkFactoryRequests.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "NetworkFactoryRequests.h"

@interface NetworkFactoryRequests ()

@end

@implementation NetworkFactoryRequests

- (void)sendAsynchronousRequest:(NSURLRequest *)request
              completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))completionHandler {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      completionHandler(response, data, error);
                                  }];
    [task resume];
}

@end
