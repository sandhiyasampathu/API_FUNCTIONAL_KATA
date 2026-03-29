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

    @deletebooking@positive @integration
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
