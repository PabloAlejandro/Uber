//
//  NSUserDefaults+History.h
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (History)

- (NSArray <NSString *> *)retrieveSearchHistory;
- (void)addSearchToHistory:(NSString *)search;
- (void)clearHistory;

@end
