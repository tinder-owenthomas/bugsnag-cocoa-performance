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

- (void)testShouldPassValidationWithCorrectApiKeyAndDefaultEndpoint {
    auto config = [[BugsnagPerformanceConfiguration alloc] initWithApiKey:@"0123456789abcdef0123456789abcdef"];
    NSError *error = nil;
    XCTAssertTrue([config validate:&error]);
    XCTAssertNil(error);
}

- (void)testShouldNotPassValidationWithAnExceptionWithEmptyApiKeyAndDefaultEndpoint {
    auto config = [[BugsnagPerformanceConfiguration alloc] initWithApiKey:@""];
    NSError *error = nil;
    XCTAssertThrows([config validate:&error]);
}

- (void)testShouldNotPassValidationWithInvalidApiKeyAndDefaultEndpoint {
    auto config = [[BugsnagPerformanceConfiguration alloc] initWithApiKey:@"YOUR-API-KEY-HERE"];
    NSError *error = nil;
    XCTAssertFalse([config validate:&error]);
    XCTAssertNotNil(error);
}

- (void)testShouldPassValidationWithValidApiKeyAndValidCustomEndpoint {
    auto config = [[BugsnagPerformanceConfiguration alloc] initWithApiKey:@"0123456789abcdef0123456789abcdef"];
    config.endpoint = (NSURL *_Nonnull)[NSURL URLWithString:@"http://bugsnag.com"];
    NSError *error = nil;
    XCTAssertTrue([config validate:&error]);
    XCTAssertNil(error);
}

- (void)testShouldNotPassValidationWithValidApiKeyAndInvalidCustomEndpoint {
    auto config = [[BugsnagPerformanceConfiguration alloc] initWithApiKey:@"0123456789abcdef0123456789abcdef"];
    config.endpoint = (NSURL *_Nonnull)[NSURL URLWithString:@"x"];
    NSError *error = nil;
    XCTAssertFalse([config validate:&error]);
    XCTAssertNotNil(error);
}

@end
