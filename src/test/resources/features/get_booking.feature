@booking @getbooking
Feature: Get Booking by ID
    As an authenticated user of the Restful-Booker API
    I want to retrieve a booking by its ID
    So that I can view the full details of a specific reservation

    Background:
        Given the API base URL is "https://automationintesting.online/api"
        And I am authenticated with valid auth token stored in "auth_token"
        And there is a existing booking with the booking ID stored in "booking_id"

    # ---------------------------- Positive Scenarios ----------------------------
    @getbooking @positive @smoke @integration
    Scenario Outline: Successfully retrieve a booking by ID with valid token
        Given the Cookie header is set to "token={auth_token}"
        When I send a GET request to view an existing booking at "/booking/{booking_id}"
        Then the response status code should be <status_code>
        And the response body should contain all the expected booking details

        Examples:
            | status_code |
            | 200         |

    # ---------------------------- Negative Scenarios ----------------------------
    @getbooking @negative @auth
    Scenario Outline: Fail to retrieve booking with missing or invalid token
        Given the Cookie header is set to "<cookie_value>"
        When I send a GET request to view an existing booking at "/booking/{booking_id}"
        Then the response status code should be <status_code>
        And the response body should contain the key "error"
        And the value of "error" should be "Unauthorized"

        Examples:
            | cookie_value       | status_code | reason              |
            | removed            | 401         | missing token       |
            | token=invalidtoken | 401         | invalid token value |
            | token=             | 401         | empty token value   |
            | wrongheader=abc123 | 401         | wrong cookie key    |

    # ---------------------------- Exploratory / Edge Cases ----------------------------
    @getbooking @negative @exploratory @inputvalidation
    Scenario Outline: Fail to retrieve a non-existent booking
        Given the Cookie header is set to "token={auth_token}"
        When I send a GET request to "/booking/<booking_id>" with a non-existent booking ID
        Then the response status code should be <status_code>

        Examples:
            | booking_id | status_code | reason          |
            | 9999999    | 404         | non-existent ID |
            | 0          | 404         | zero ID         |
            | -1         | 404         | negative ID     |
