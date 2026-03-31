@booking @deletebooking
Feature: Delete Booking
    As an authenticated user of the Restful-Booker API
    I want to delete an existing booking by its ID
    So that I can remove reservations that are no longer needed

    Background:
        Given the API base URL is "https://automationintesting.online/api"
        And I am authenticated with valid auth token stored in "auth_token"
        And there is a existing booking with the booking ID stored in "booking_id"

    # ---------------------------- Positive Scenarios ----------------------------

    @deletebooking @positive @smoke
    Scenario: Successfully delete a booking with a valid token
        Given the Cookie header is set to "token={auth_token}"
        When I send a DELETE request to "/booking/{booking_id}"
        Then the response status code should be 201

    @deletebooking @positive @integration
    Scenario: Verify booking exists before deletion
        Given the Cookie header is set to "token={auth_token}"
        When I send a GET request to "/booking/{booking_id}"
        Then the response status code should be 200
        And the response body should contain all the expected booking details
        When I send a DELETE request to "/booking/{booking_id}"
        Then the response status code should be 201

    @deletebooking @positive @integration @exploratory
    Scenario: Verify booking no longer exists after deletion
        Given the Cookie header is set to "token={auth_token}"
        When I send a DELETE request to "/booking/{booking_id}"
        Then the response status code should be 201
        When I send a GET request to "/booking/{booking_id}"
        Then the response status code should be 404

    # ---------------------------- Negative Scenarios ----------------------------

    @deletebooking @negative @auth @inputvalidation
    Scenario Outline: Fail to delete booking with invalid or missing token
        Given the Cookie header is set to "<cookie_value>"
        When I send a DELETE request to "/booking/{booking_id}" with the specified cookie
        Then the response status code should be <status_code>
        And the response body should contain the key "error"
        And the value of "error" should be "Unauthorized"

        Examples:
            | cookie_value       | status_code | reason              |
            | removed            | 401         | missing token       |
            | token=invalidtoken | 401         | invalid token value |
            | token=             | 401         | empty token value   |
            | wrongcookie=abc123 | 401         | wrong cookie key    |


    # ---------------------------- Exploratory / Edge Cases ----------------------------

    @deletebooking @negative @exploratory
    Scenario Outline: Fail to delete a non-existent booking
        Given the Cookie header is set to "token={auth_token}"
        When I send a DELETE request to "/booking/<booking_id>" with a non-existent booking ID
        Then the response status code should be <status_code>
        And the response body should contain the key "error"

        Examples:
            | booking_id | status_code | reason          |
            | 9999999    | 404         | non-existent ID |
            | 0          | 404         | zero ID         |
            | -1         | 404         | negative ID     |

    @deletebooking @negative @exploratory
    Scenario: Delete the same booking twice returns error on second attempt
        Given the Cookie header is set to "token={auth_token}"
        When I send a DELETE request to "/booking/{booking_id}"
        Then the response status code should be 201
        When I send a DELETE request to "/booking/{booking_id}" again
        Then the response body should contain the key "error"
        And the response status code should be 404