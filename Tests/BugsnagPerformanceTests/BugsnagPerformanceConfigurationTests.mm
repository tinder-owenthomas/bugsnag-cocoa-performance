//
//  BugsnagPerformanceConfigurationTests.m
//  BugsnagPerformance-iOSTests
//
//  Created by Karl Stenerud on 04.01.23.
//  Copyright © 2023 Bugsnag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <BugsnagPerformance/BugsnagPerformance.h>

@interface BugsnagPerformanceConfigurationTests : XCTestCase

@end

@implementation BugsnagPerformanceConfigurationTests

- (void)testValidate {
    // Bad API key format
    NSError *error = nil;
    auto config = [[BugsnagPerformanceConfiguration alloc] initWithApiKey:@"" error:&error];
    XCTAssertNotNil(error);
    XCTAssertNil(config);

    config = [[BugsnagPerformanceConfiguration alloc] initWithApiKey:@"YOUR-API-KEY-HERE" error:&error];
    XCTAssertNotNil(error);
    XCTAssertNil(config);

    // Valid looking API key
    config = [[BugsnagPerformanceConfiguration alloc] initWithApiKey:@"00000000000000000000000000000002" error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(config);

    // Invalid endpoint
    config.endpoint = (NSURL *_Nonnull)[NSURL URLWithString:@""];
    [config validate:&error];
    XCTAssertNotNil(error);

    error = nil;
    config.endpoint = (NSURL *_Nonnull)[NSURL URLWithString:@"x"];
    [config validate:&error];
    XCTAssertNotNil(error);

    // Valid looking URL
    config.endpoint = (NSURL *_Nonnull)[NSURL URLWithString:@"http://bugsnag.com"];
    [config validate:&error];
    XCTAssertNil(error);
}

@end
