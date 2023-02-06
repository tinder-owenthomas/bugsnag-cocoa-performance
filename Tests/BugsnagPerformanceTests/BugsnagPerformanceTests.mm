//
//  BugsnagPerformanceTests.m
//  BugsnagPerformance
//
//  Created by Nick Dowell on 26/09/2022.
//

#import <XCTest/XCTest.h>

#import <BugsnagPerformance/BugsnagPerformance.h>

@interface BugsnagPerformanceTests : XCTestCase

@end

@implementation BugsnagPerformanceTests

- (void)setUp {
    NSError *error = nil;
    auto config = [[BugsnagPerformanceConfiguration alloc] initWithApiKey:@"00000000000000000000000000000003" error:&error];
    XCTAssertNil(error);
    XCTAssertTrue([BugsnagPerformance startWithConfiguration:config error:&error]);
    XCTAssertNil(error);
}

- (void)testStartSpanWithName {
    auto span = [BugsnagPerformance startSpanWithName:@"Test"];
    XCTAssertNotNil(span);
    [span end];
}

@end
