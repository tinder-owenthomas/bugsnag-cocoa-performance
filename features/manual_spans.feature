Feature: Manual creation of spans

  # Workaround to clear out the initial startup P request

  Scenario: Retry a manual span
    Given I set the HTTP status code for the next requests to "200,500,200,200"
    And I run "RetryScenario"
    And I wait to receive 4 traces
    And the trace payload field "resourceSpans" is an array with 0 elements
    And I discard the oldest trace
    * the trace payload field "resourceSpans.0.scopeSpans.0.spans.0.name" equals "WillRetry"
    And I discard the oldest trace
    * the trace payload field "resourceSpans.0.scopeSpans.0.spans.0.name" equals "Success"
    And I discard the oldest trace
    * the trace payload field "resourceSpans.0.scopeSpans.0.spans.0.name" equals "WillRetry"

  Scenario: Manually start and end a span
    Given I run "ManualSpanScenario" and discard the initial p-value request
    And I wait to receive an error
    And the error payload field "events.0.device.id" is stored as the value "bugsnag_device_id"
    And I wait for 1 span
    Then the trace "Content-Type" header equals "application/json"
    * the trace "Bugsnag-Integrity" header matches the regex "^sha1 [A-Fa-f0-9]{40}$"
    * all span name equals "ManualSpanScenario"
    * all span spanId matches the regex "^[A-Fa-f0-9]{16}$"
    * all span traceId matches the regex "^[A-Fa-f0-9]{32}$"
    * all span kind equals "SPAN_KIND_INTERNAL"
    * all span startTimeUnixNano matches the regex "^[0-9]+$"
    * all span endTimeUnixNano matches the regex "^[0-9]+$"
    * all span bool attribute "bugsnag.app.in_foreground" is true
    * all span string attribute "net.host.connection.type" equals "wifi"
    * the trace payload field "resourceSpans.0.resource" string attribute "bugsnag.app.bundle_version" equals "1"
    * the trace payload field "resourceSpans.0.resource" string attribute "deployment.environment" equals "production"
    * the trace payload field "resourceSpans.0.resource" string attribute "device.id" equals the stored value "bugsnag_device_id"
    * the trace payload field "resourceSpans.0.resource" string attribute "device.manufacturer" equals "Apple"
    * the trace payload field "resourceSpans.0.resource" string attribute "device.model.identifier" exists
    * the trace payload field "resourceSpans.0.resource" string attribute "host.arch" matches the regex "arm64|amd64"
    * the trace payload field "resourceSpans.0.resource" string attribute "os.name" equals "iOS"
    * the trace payload field "resourceSpans.0.resource" string attribute "os.type" equals "darwin"
    * the trace payload field "resourceSpans.0.resource" string attribute "os.version" exists
    * the trace payload field "resourceSpans.0.resource" string attribute "service.name" equals "com.bugsnag.Fixture"
    * the trace payload field "resourceSpans.0.resource" string attribute "service.version" equals "1.0"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.name" equals "bugsnag.performance.cocoa"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.version" equals "0.0"

  Scenario: Starting and ending a span before starting the SDK
    Given I run "ManualSpanBeforeStartScenario" and discard the initial p-value request
    And I wait for 1 span
    * all span name equals "BeforeStart"
    * all span spanId matches the regex "^[A-Fa-f0-9]{16}$"
    * all span traceId matches the regex "^[A-Fa-f0-9]{32}$"
    * all span kind equals "SPAN_KIND_INTERNAL"
    * all span startTimeUnixNano matches the regex "^[0-9]+$"
    * all span endTimeUnixNano matches the regex "^[0-9]+$"
    * the trace payload field "resourceSpans.0.resource" string attribute "service.name" equals "com.bugsnag.Fixture"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.name" equals "bugsnag.performance.cocoa"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.version" equals "0.0"

  Scenario: Manually report a view load span
    Given I run "ManualViewLoadScenario" and discard the initial p-value request
    And I wait for 2 spans
    * a span name equals "ViewLoaded/UIKit/ManualViewController"
    * a span string attribute "bugsnag.view.name" equals "ManualViewController"
    * a span string attribute "bugsnag.view.type" equals "UIKit"
    * a span name equals "ViewLoaded/SwiftUI/ManualView"
    * a span string attribute "bugsnag.view.name" equals "ManualView"
    * a span string attribute "bugsnag.view.type" equals "SwiftUI"
    * all span kind equals "SPAN_KIND_INTERNAL"
    * all span startTimeUnixNano matches the regex "^[0-9]+$"
    * all span endTimeUnixNano matches the regex "^[0-9]+$"
    * all span string attribute "bugsnag.span_category" equals "view_load"

  Scenario: Manually start a network span
    Given I run "ManualNetworkSpanScenario" and discard the initial p-value request
    And I wait for 1 span
    Then the trace "Content-Type" header equals "application/json"
    * the trace payload field "resourceSpans.0.resource" string attribute "service.name" equals "com.bugsnag.Fixture"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.name" equals "bugsnag.performance.cocoa"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.version" equals "0.0"
    * all span name equals "HTTP/GET"
    * all span string attribute "http.flavor" exists
    * all span string attribute "http.url" matches the regex "http://.*:9340/reflect/"
    * all span string attribute "http.method" equals "GET"
    * all span integer attribute "http.status_code" is greater than 0
    * all span integer attribute "http.response_content_length" is greater than 0
    * all span string attribute "net.host.connection.type" equals "wifi"
    * all span spanId matches the regex "^[A-Fa-f0-9]{16}$"
    * all span traceId matches the regex "^[A-Fa-f0-9]{32}$"
    * all span kind equals "SPAN_KIND_INTERNAL"
    * all span startTimeUnixNano matches the regex "^[0-9]+$"
    * all span endTimeUnixNano matches the regex "^[0-9]+$"

  Scenario: Manually start and end a span with batching
    Given I run "BatchingScenario" and discard the initial p-value request
    And I wait for 2 spans
    Then the trace "Content-Type" header equals "application/json"
    * the trace payload field "resourceSpans.0.resource" string attribute "service.name" equals "com.bugsnag.Fixture"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.name" equals "bugsnag.performance.cocoa"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.version" equals "0.0"
    * a span name equals "Span1"
    * a span name equals "Span2"
    * all span spanId matches the regex "^[A-Fa-f0-9]{16}$"
    * all span traceId matches the regex "^[A-Fa-f0-9]{32}$"
    * all span kind equals "SPAN_KIND_INTERNAL"
    * all span startTimeUnixNano matches the regex "^[0-9]+$"
    * all span endTimeUnixNano matches the regex "^[0-9]+$"

  Scenario: Manually start and end a span with batching
    Given I run "BatchingScenario" and discard the initial p-value request
    And I wait for 2 spans
    Then the trace "Content-Type" header equals "application/json"
    * a span name equals "Span1"
    * a span name equals "Span2"
    * all span spanId matches the regex "^[A-Fa-f0-9]{16}$"
    * all span traceId matches the regex "^[A-Fa-f0-9]{32}$"
    * all span kind equals "SPAN_KIND_INTERNAL"
    * all span startTimeUnixNano matches the regex "^[0-9]+$"
    * all span endTimeUnixNano matches the regex "^[0-9]+$"
    * the trace payload field "resourceSpans.0.resource" string attribute "service.name" equals "com.bugsnag.Fixture"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.name" equals "bugsnag.performance.cocoa"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.version" equals "0.0"
