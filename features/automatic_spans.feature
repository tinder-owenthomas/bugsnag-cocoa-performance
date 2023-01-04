Feature: Automatic instrumentation spans

  Scenario: AutoInstrumentAppStartsScenario
    Given I run "AutoInstrumentAppStartsScenario" and discard the initial p-value request
    And I wait for 1 span
    Then the trace "Content-Type" header equals "application/json"
    * all span name equals "AppStart/Cold"
    * all span spanId matches the regex "^[A-Fa-f0-9]{16}$"
    * all span traceId matches the regex "^[A-Fa-f0-9]{32}$"
    * all span kind equals "SPAN_KIND_INTERNAL"
    * all span startTimeUnixNano matches the regex "^[0-9]+$"
    * all span endTimeUnixNano matches the regex "^[0-9]+$"
    * all span string attribute "bugsnag.app_start.type" equals "cold"
    * all span string attribute "bugsnag.span_category" equals "app_start"
    * the trace payload field "resourceSpans.0.resource" string attribute "service.name" equals "com.bugsnag.Fixture"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.name" equals "bugsnag.performance.cocoa"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.version" equals "0.0"

  Scenario: AutoInstrumentViewLoadScenario
    Given I run "AutoInstrumentViewLoadScenario" and discard the initial p-value request
    And I wait for 1 span
    Then the trace "Content-Type" header equals "application/json"
    * all span name equals "ViewLoaded/UIKit/Fixture.AutoInstrumentViewLoadScenario_ViewController"
    * all span spanId matches the regex "^[A-Fa-f0-9]{16}$"
    * all span traceId matches the regex "^[A-Fa-f0-9]{32}$"
    * all span kind equals "SPAN_KIND_INTERNAL"
    * all span startTimeUnixNano matches the regex "^[0-9]+$"
    * all span endTimeUnixNano matches the regex "^[0-9]+$"
    * all span string attribute "bugsnag.span_category" equals "view_load"
    * all span string attribute "bugsnag.view.name" equals "Fixture.AutoInstrumentViewLoadScenario_ViewController"
    * the trace payload field "resourceSpans.0.scopeSpans.0.spans.0" string attribute "bugsnag.view.type" equals "UIKit"
    * the trace payload field "resourceSpans.0.resource" string attribute "service.name" equals "com.bugsnag.Fixture"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.name" equals "bugsnag.performance.cocoa"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.version" equals "0.0"

  Scenario: Automatically start a network span
    Given I run "AutoInstrumentNetworkScenario" and discard the initial p-value request
    And I wait for 1 span
    Then the trace "Content-Type" header equals "application/json"
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
    * the trace payload field "resourceSpans.0.resource" string attribute "service.name" equals "com.bugsnag.Fixture"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.name" equals "bugsnag.performance.cocoa"
    * the trace payload field "resourceSpans.0.resource" string attribute "telemetry.sdk.version" equals "0.0"
