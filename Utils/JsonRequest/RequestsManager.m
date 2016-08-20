//
//  RequestsManager.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "RequestsManager.h"
#import "ServerRequestUtils.h"
#import "NSURLSession+Factory.h"

@implementation RequestsManager

- (id)init {
    
    if ((self = [super init])) {
        _timeout = 60;
    }
    return self;
}

#pragma mark - Public instance methods

- (NSURLSessionDataTask *)getObjectFromUrl:(NSURL *)url parameters:(NSDictionary *)parameters httpHeaderFields:(NSDictionary *)httpHeaderFields method:(NSString *)method referer:(NSURL *)referer requestKey:(NSString *)requestKey requestSecretKey:(NSString *)requestSecretKey userAgent:(NSString *)userAgent data:(NSData *)data userToken:(NSString *)userToken done:(void (^)(NSObject *object, NSError *error))doneBlock
{
    NSString *urlRequest = [url absoluteString];
    
    for(NSString *key in parameters) {
        urlRequest = [ServerRequestUtils addObject:[parameters objectForKey:key] key:key toRequest:urlRequest];
    }
    
    NSMutableURLRequest *request = [ServerRequestUtils newRequestWithUrl:urlRequest timeoutInterval:self.timeout];
    
    [request setHTTPMethod:method];
    
    for(NSString *key in httpHeaderFields) {
        [request setValue:[httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
    }
    
    if(data) {
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: data];
    }
    
    request = [ServerRequestUtils addToken:userToken toURLRequest:request];
    request = [ServerRequestUtils addReferer:referer toURLRequest:request];
    request = [ServerRequestUtils addRequestKey:requestKey toURLRequest:request];
    request = [ServerRequestUtils addRequestSecretKey:requestSecretKey toURLRequest:request];
    request = [ServerRequestUtils addUserAgent:userAgent toURLRequest:request];
    
    if(self.debug) {
        NSLog(@"%s %@", __func__, urlRequest);
        NSLog(@"%s %@", __func__, [request allHTTPHeaderFields]);
    }
    
    NSURLSessionDataTask * task = [NSURLSession sendAsynchronousRequest:request
                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                           
                                           if(self.debug) {
                                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                               NSNumber *statusCode = [NSNumber numberWithInteger:[httpResponse statusCode]];
                                               NSLog(@"statusCode: %@", statusCode);
                                           }
                                           
                                           if (error != nil) {
                                               
                                               if(self.debug) {
                                                   NSLog(@"%s Error: %@", __func__, error);
                                               }
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   doneBlock(nil, error);
                                               });
                                           }
                                           else {
                                               [ServerRequestUtils processData:data done:doneBlock];
                                           }
                                       }];
    return task;
}

@end
