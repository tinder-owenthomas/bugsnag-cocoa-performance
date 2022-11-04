//
//  BugsnagPerformanceUploader.m
//  BugsnagPerformance-iOS
//
//  Created by Karl Stenerud on 04.11.22.
//  Copyright © 2022 Bugsnag. All rights reserved.
//

#import "BugsnagPerformanceUploader.h"

using namespace bugsnag;

typedef NS_ENUM(NSInteger, HTTPStatusCode) {
    /// 402 Payment Required: a nonstandard client error status response code that is reserved for future use.
    ///
    /// This status code is returned by ngrok when a tunnel has expired.
    HTTPStatusCodePaymentRequired = 402,

    /// 407 Proxy Authentication Required: the request has not been applied because it lacks valid authentication credentials
    /// for a proxy server that is between the browser and the server that can access the requested resource.
    HTTPStatusCodeProxyAuthenticationRequired = 407,

    /// 408 Request Timeout: the server would like to shut down this unused connection.
    HTTPStatusCodeClientTimeout = 408,

    /// 429 Too Many Requests: the user has sent too many requests in a given amount of time ("rate limiting").
    HTTPStatusCodeTooManyRequests = 429,
};

void BugsnagPerformanceUploader::upload(const OtlpPackage &package, UploadResultCallback callback) const noexcept {
    auto urlRequest = [NSMutableURLRequest requestWithURL:(NSURL *)endpoint_];
    package.fillURLRequest(urlRequest);

    [[NSURLSession.sharedSession dataTaskWithRequest:urlRequest completionHandler:
      ^(__unused NSData *responseData, NSURLResponse *response, __unused NSError *taskError) {
        if (callback) {
            callback(getUploadResult(response));
        }
        if (newProbabilityCallback_) {
            auto newProbability = getNewProbability(response);
            if (newProbability >= 0 && newProbability <= 1) {
                newProbabilityCallback_(newProbability);
            }
        }
    }] resume];
}

UploadResult BugsnagPerformanceUploader::getUploadResult(NSURLResponse *response) const {
    if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
        return BSG_UPLOAD_FAILED_CANNOT_RETRY;
    }

    auto httpResponse = (NSHTTPURLResponse *_Nonnull)response;
    auto statusCode = httpResponse.statusCode;

    if (statusCode / 100 == 2) {
        return BSG_UPLOAD_SUCCESSFUL;
    }

    if (statusCode / 100 == 4 &&
        statusCode != HTTPStatusCodePaymentRequired &&
        statusCode != HTTPStatusCodeProxyAuthenticationRequired &&
        statusCode != HTTPStatusCodeClientTimeout &&
        statusCode != HTTPStatusCodeTooManyRequests) {
        return BSG_UPLOAD_FAILED_CANNOT_RETRY;
    }

    return BSG_UPLOAD_FAILED_CAN_RETRY;
}

double BugsnagPerformanceUploader::getNewProbability(NSURLResponse *response) const {
    if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
        return -1;
    }

    auto httpResponse = (NSHTTPURLResponse *_Nonnull)response;
    NSString *probability = httpResponse.allHeaderFields[@"Bugsnag-Sampling-Probability"];
    if (probability) {
        return probability.doubleValue;
    }

    return -1;
}
