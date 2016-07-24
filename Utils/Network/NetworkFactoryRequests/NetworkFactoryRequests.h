//
//  NetworkFactoryRequests.h
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This interface is used to abstract network operations in a way that asynchronous operations can be called
 * from a testing environment.
 * Production code should never set the 'testing' flag to true, while unit tests always should!
 */

@interface NetworkFactoryRequests : NSObject

- (void)sendAsynchronousRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;

@end