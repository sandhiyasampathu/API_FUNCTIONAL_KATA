@booking @deletebooking
Feature: Delete Booking
    As an authenticated user of the Restful-Booker API
    I want to delete an existing booking by its ID
    So that I can remove reservations that are no longer needed

    Background:
        Given the API base URL is "https://automationintesting.online/api"
        And I am authenticated with username "admin" and password "password"
        And I store the returned auth token as "auth_token"
        And a booking exists with the following details:
            | roomid      | 2                      |
            | firstname   | Emma                   |
            | lastname    | Brûlé                  |
            | depositpaid | true                   |
            | checkin     | 2026-10-13             |
            | checkout    | 2026-10-15             |
            | email       | emma.brule@example.com |
            | phone       | 12345678901            |
        And the created booking ID is stored as "booking_id"

    # ---------------------------- Positive Scenarios ----------------------------

    @deletebooking @positive @smoke
    Scenario: Successfully delete a booking with a valid token
        Given the Cookie header is set to "token={auth_token}"
        When I send a DELETE request to "/booking/{booking_id}"
        Then the response status code should be 201

    @deletebooking @positive @integration
    Scenario: Verify booking exists before deletion
        Given the Cookie header is set to "token={auth_token}"
        When I send a GET request to "/booking/{booking_id}" with Cookie "token={auth_token}"
        Then the response status code should be 200
        And the booking details should be returned in the response body
        When I send a DELETE request to "/booking/{booking_id}"
        Then the response status code should be 201

    @deletebooking @positive @integration @exploratory
    Scenario: Verify booking no longer exists after deletion
        Given the Cookie header is set to "token={auth_token}"
        When I send a DELETE request to "/booking/{booking_id}"
        Then the response status code should be 201
        When I send a GET request to "/booking/{booking_id}" with Cookie "token={auth_token}"
        Then the response status code should be 404

# ---------------------------- Negative Scenarios ----------------------------

    @deletebooking @negative @auth @inputvalidation
    Scenario Outline: Fail to delete booking with invalid or missing token
        Given the Cookie header is set to "<cookie_value>"
        When I send a DELETE request to "/booking/{booking_id}"
        Then the response status code should be <status_code>
        And the response body should contain the key "error"
        And the value of "error" should be "Unauthorized"

        Examples:
            | cookie_value       | status_code |
            |                    | 401         |
            | token=invalidtoken | 401         |
            | token=             | 401         |
            | wrongkey=abc123    | 401         |

    @deletebooking @negative @auth
    Scenario: Fail to delete booking without providing any Cookie header
        When I send a DELETE request to "/booking/{booking_id}" without any Cookie header
        Then the response status code should be 401
        And the response body should contain the key "error"
        And the value of "error" should be "Unauthorized"

    # ---------------------------- Exploratory / Edge Cases ----------------------------

    @deletebooking @negative @exploratory
    Scenario: Fail to delete a non-existent booking
        Given the Cookie header is set to "token={auth_token}"
        When I send a DELETE request to "/booking/9999999"
        Then the response status code should be 404

    @deletebooking @negative @exploratory
    Scenario: Delete the same booking twice returns error on second attempt
        Given the Cookie header is set to "token={auth_token}"
        When I send a DELETE request to "/booking/{booking_id}"
        Then the response status code should be 201
        When I send a DELETE request to "/booking/{booking_id}" again
        Then the response status code should be 404

    @deletebooking @negative @inputvalidation @exploratory
    Scenario Outline: Fail to delete booking with invalid ID formats
        Given the Cookie header is set to "token={auth_token}"
        When I send a DELETE request to "/booking/<invalid_id>"
        Then the response status code should be <status_code>

        Examples:
            | invalid_id | status_code |
            | 0          | 404         |
            | -1         | 404         |
            | abc        | 400         |

    @deletebooking @negative @auth @exploratory
    Scenario: Fail to delete booking with expired token
        Given the Cookie header is set to "token=expired_token"
        When I send a DELETE request to "/booking/{booking_id}"
        Then the response status code should be 401