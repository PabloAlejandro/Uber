//
//  UberTests.m
//  UberTests
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSUserDefaults+History.h"
#import "JsonRequestRetry.h"

@interface UberTests : XCTestCase

@end

@implementation UberTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testHistory
{
    [[NSUserDefaults standardUserDefaults] clearHistory];
    
    for(int i = 0; i < 20; i++) {
        [[NSUserDefaults standardUserDefaults] addSearchToHistory:[NSString stringWithFormat:@"Search %d", i]];
    }
    NSArray * history = [[NSUserDefaults standardUserDefaults] retrieveSearchHistory];
    XCTAssertEqual(history.count, 20);
}

- (void)testClearHistory
{
    for(int i = 0; i < 10; i++) {
        [[NSUserDefaults standardUserDefaults] addSearchToHistory:[NSString stringWithFormat:@"Search %d", i]];
    }
    
    [[NSUserDefaults standardUserDefaults] clearHistory];
    
    NSArray * history = [[NSUserDefaults standardUserDefaults] retrieveSearchHistory];
    
    XCTAssertEqual(history.count, 0);
}

- (void)testOverMaxHistory
{
    [[NSUserDefaults standardUserDefaults] clearHistory];
    
    for(int i = 0; i < 50; i++) {
        [[NSUserDefaults standardUserDefaults] addSearchToHistory:[NSString stringWithFormat:@"Search %d", i]];
    }
    NSArray * history = [[NSUserDefaults standardUserDefaults] retrieveSearchHistory];
    XCTAssertEqual(history.count, 30);
    NSAssert([(NSString *)[history lastObject] isEqualToString:@"Search 49"], @"Last object must be Search 49");
}

- (void)testRequest
{
    NSURL * url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=kittens"];
    JsonRequestRetry * jsonRequestRetry = [JsonRequestRetry new];
    [jsonRequestRetry retrieveDataForUrl:url completionBlock:^(id result, NSDictionary *userInfo) {
        XCTAssertNotNil(result);
    }];
}

@end
