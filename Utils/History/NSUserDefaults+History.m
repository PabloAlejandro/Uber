//
//  NSUserDefaults+History.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "NSUserDefaults+History.h"

static NSUInteger const kMaxHistoryCount = 30;
static NSString * const kHisrotyPropertyName = @"HisrotyPropertyName";

@implementation NSUserDefaults (History)

- (NSArray <NSString *> *)retrieveSearchHistory
{
    return [[NSUserDefaults standardUserDefaults] getArrayProperty:kHisrotyPropertyName orDefault:nil];
}

- (void)addSearchToHistory:(NSString *)search
{
    NSArray * history = [[NSUserDefaults standardUserDefaults] retrieveSearchHistory] ? [[[NSUserDefaults standardUserDefaults] retrieveSearchHistory] arrayByAddingObject:search] : @[search];
    if(history.count > kMaxHistoryCount) {
        history = [history subarrayWithRange:NSMakeRange(history.count - kMaxHistoryCount, kMaxHistoryCount)];
    }
    [[NSUserDefaults standardUserDefaults] setArrayProperty:kHisrotyPropertyName value:history];
}

- (void)clearHistory
{
    [[NSUserDefaults standardUserDefaults] setArrayProperty:kHisrotyPropertyName value:@[]];
}

#pragma mark - Private

- (NSArray *)getArrayProperty:(const NSString *)propertyName orDefault:(NSArray *)defaultValue {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *property = [defaults objectForKey:(NSString *)propertyName];
    return property != nil ? property : defaultValue;
}

- (void)setArrayProperty:(const NSString *)propertyName value:(NSArray *)value {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:(NSString *)propertyName];
    [defaults synchronize];
}

@end
