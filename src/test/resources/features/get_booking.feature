@booking @getbooking
Feature: Get Booking by ID
    As an authenticated user of the Restful-Booker API
    I want to retrieve a booking by its ID
    So that I can view the full details of a specific reservation

    Background:
        Given the API base URL is "https://automationintesting.online/api"
        And I am authenticated with username "admin" and password "password"
        And I store the returned auth token as "auth_token"
        And a booking exists with the following details:
            | roomid      | 2                          |
            | firstname   | Lëyla                      |
            | lastname    | Fontàine                   |
            | depositpaid | true                       |
            | checkin     | 2026-08-13                 |
            | checkout    | 2026-08-15                 |
            | email       | lëyla.fontàine@example.com |
            | phone       | 12345678901                |
        And the created booking ID is stored as "booking_id"

    # ---------------------------- Positive Scenarios ----------------------------
    @positive @smoke
    Scenario Outline: Successfully retrieve a booking by ID with valid token
        Given the Cookie header is set to "token=<token>"
        When I send a GET request to "/booking/<booking_id>"
        Then the response status code should be <status_code>
        And the response body should contain the key "firstname"
        And the response body should contain the key "lastname"
        And the response body should contain the key "roomid"
        And the response body should contain the key "depositpaid"
        And the response body should contain the key "bookingdates"
        And the response body should contain the key "email"
        And the response body should contain the key "phone"

        Examples:
            | token        | booking_id   | status_code |
            | {auth_token} | {booking_id} | 200         |

    @positive @integration
    Scenario: Retrieve booking and validate all response field values
        Given the Cookie header is set to "token={auth_token}"
        When I send a GET request to "/booking/{booking_id}"
        Then the response status code should be 200
        And the value of "firstname" should be "Lëyla"
        And the value of "lastname" should be "Fontàine"
        And the value of "roomid" should be 2
        And the value of "depositpaid" should be true
        And the value of "bookingdates.checkin" should be "2026-08-13"
        And the value of "bookingdates.checkout" should be "2026-08-15"
        And the value of "email" should be "lëyla.fontàine@example.com"
        And the value of "phone" should be "12345678901"

    # ---------------------------- Negative Scenarios ----------------------------
    @getbooking @negative @auth
    Scenario Outline: Fail to retrieve booking with missing or invalid token
        Given the Cookie header is set to "<cookie_value>"
        When I send a GET request to "/booking/{booking_id}"
        Then the response status code should be <status_code>
        And the response body should contain the key "error"
        And the value of "error" should be "Unauthorized"

        Examples:
            | cookie_value       | status_code | reason              |
            |                    | 401         | missing token       |
            | token=invalidtoken | 401         | invalid token value |
            | token=             | 401         | empty token value   |
            | wrongheader=abc123 | 401         | wrong cookie key    |

    # ---------------------------- Exploratory / Edge Cases ----------------------------
    @getbooking @negative @exploratory @inputvalidation
    Scenario Outline: Fail to retrieve a non-existent booking
        Given the Cookie header is set to "token={auth_token}"
        When I send a GET request to "/booking/<booking_id>"
        Then the response status code should be <status_code>

        Examples:
            | booking_id | status_code | reason          |
            | 9999999    | 404         | non-existent ID |
            | 0          | 404         | zero ID         |

    @getbooking @negative @auth @exploratory
    Scenario: Retrieve booking without providing any Cookie header
        When I send a GET request to "/booking/{booking_id}" without any Cookie header
        Then the response status code should be 401
        And the response body should contain the key "error"
        And the value of "error" should be "Unauthorized"
