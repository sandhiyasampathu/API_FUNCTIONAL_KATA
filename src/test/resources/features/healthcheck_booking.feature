@healthcheck @sanity
Feature: API Health Check
    As a consumer of the Restful-Booker API
    I want to verify the API is up and running
    So that I can confirm service availability before executing tests

    Background:
        Given the API base URL is "https://automationintesting.online/api"
        And the response content-type is set to "application/json"

    @healthcheck @positive
    Scenario Outline: Check API health status
        When I send a GET request to "/booking/actuator/health"
        Then the response status code should be <status_code>
        And the response body should contain the key "status"
        And the value of "status" should be "<expected_status>"

        Examples:
            | status_code | expected_status |
            | 200         | UP              |
