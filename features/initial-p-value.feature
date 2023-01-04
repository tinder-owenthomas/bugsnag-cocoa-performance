Feature: Initial P values

  Scenario: Initial P value of 0
    Given I set the sampling probability for the next traces to "0"
    And I run "InitialPScenario"
    And I wait to receive 1 traces
    * the trace payload field "resourceSpans" is an array with 0 elements

  Scenario: Initial P value of 1
    Given I set the sampling probability for the next traces to "1"
    And I run "InitialPScenario"
    And I wait for 2 spans
    * a span name equals "First"
    * a span name equals "Second"
    * all span spanId matches the regex "^[A-Fa-f0-9]{16}$"
    * all span traceId matches the regex "^[A-Fa-f0-9]{32}$"
    * all span kind equals "SPAN_KIND_INTERNAL"
    * all span startTimeUnixNano matches the regex "^[0-9]+$"
    * all span endTimeUnixNano matches the regex "^[0-9]+$"
