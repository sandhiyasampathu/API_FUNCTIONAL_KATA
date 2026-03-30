@booking @updatebooking
Feature: Update Booking (Full Update)
    As an authenticated user of the Restful-Booker API
    I want to fully update an existing booking using a PUT request
    So that I can replace all booking details with new information

    Background:
        Given the API base URL is "https://automationintesting.online/api"
        And the request Content-Type header is set to "application/json"
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
        And the updatedbooking ID is stored as "booking_id"

    # ---------------------------- Positive Scenarios ----------------------------
    @updatebooking @positive @smoke
    Scenario Outline: Successfully update a booking with valid data and token
        Given the Cookie header is set to "token={auth_token}"
        And I have the booking details:
            | roomid      | <roomid>      |
            | firstname   | <firstname>   |
            | lastname    | <lastname>    |
            | depositpaid | <depositpaid> |
            | checkin     | <checkin>     |
            | checkout    | <checkout>    |
            | email       | <email>       |
            | phone       | <phone>       |
        When I send a PUT request to "/booking/{booking_id}"
        Then the response status code should be <status_code>
        And the response body should contain the updated booking details

        Examples:
            | roomid | firstname | lastname | depositpaid | checkin    | checkout   | email                       | phone       | status_code |
            | 2      | Élodie    | Peeters  | false       | 2026-05-20 | 2026-05-25 | elodie.peeters@testmail.com | 32471234567 | 200         |
            | 1      | André     | Brûlé    | true        | 2026-06-01 | 2026-06-05 | andre.brule@testmail.com    | 32479876543 | 200         |

    @updatebooking @positive @integration
    Scenario Outline: Successfully update a booking and verify booking via GET
        Given the Cookie header is set to "token={auth_token}"
        And I have the booking details:
            | roomid      | <roomid>      |
            | firstname   | <firstname>   |
            | lastname    | <lastname>    |
            | depositpaid | <depositpaid> |
            | checkin     | <checkin>     |
            | checkout    | <checkout>    |
            | email       | <email>       |
            | phone       | <phone>       |
        When I send a PUT request to "/booking/{booking_id}"
        Then the response status code should be <status_code>
        And the response body should contain the updated booking details
        When I send a GET request to "/booking/{booking_id}"
        Then the response status code should be 200
        And the response body should contain updated booking details

        Examples:
            | roomid | firstname | lastname | depositpaid | checkin    | checkout   | email                       | phone       | status_code |
            | 2      | Élodie    | Peeters  | false       | 2026-05-20 | 2026-05-25 | elodie.peeters@testmail.com | 32471234567 | 200         |
            | 1      | André     | Brûlé    | true        | 2026-06-01 | 2026-06-05 | andre.brule@testmail.com    | 32479876543 | 200         |

    # ---------------------------- Negative Scenarios ----------------------------
    @updatebooking @negative @auth
    Scenario Outline: Fail to update booking with invalid or missing token
        Given the Cookie header is set to "<cookie_value>"
        And I have valid booking details for update
        When I send a PUT request to "/booking/{booking_id}"
        Then the response status code should be <status_code>
        And the response body should contain the key "error"
        And the value of "error" should be "Unauthorized"

        Examples:
            | cookie_value       | status_code | reason        |
            |                    | 401         | missing token |
            | token=invalidtoken | 401         | invalid token |
            | token=             | 401         | empty token   |

    @updatebooking @negative @exploratory
    Scenario: Fail to update a non-existent booking
        Given the Cookie header is set to "token={auth_token}"
        And I have valid booking details for update
        When I send a PUT request to "/booking/9999999"
        Then the response status code should be 404

    @updatebooking @negative @inputvalidation
    Scenario Outline: Fail to update booking with invalid field values
        Given the Cookie header is set to "token={auth_token}"
        And I have the booking details:
            | roomid      | <roomid>      |
            | firstname   | <firstname>   |
            | lastname    | <lastname>    |
            | depositpaid | <depositpaid> |
            | checkin     | <checkin>     |
            | checkout    | <checkout>    |
            | email       | <email>       |
            | phone       | <phone>       |
        When I send a PUT request to "/booking/{booking_id}"
        Then the response status code should be 400
        And the response body should contain the key "errors"
        And the errors list should contain "<error_message>"
        Examples:
            | roomid | firstname                 | lastname                 | depositpaid | checkin    | checkout   | email                       | phone                  | error_message                       | reason                    |
            | 2      | Ém                        | Peeters                  | true        | 2026-05-20 | 2026-05-25 | elodie.peeters@testmail.com | 32471234567            | size must be between 3 and 18       | firstname too short       |
            | 2      | AndréJeanCharles123456789 | Brûlé                    | true        | 2026-06-01 | 2026-06-05 | andre.brule@testmail.com    | 32479876543            | size must be between 3 and 18       | firstname too long        |
            | 2      | Élodie                    | Br                       | true        | 2026-05-20 | 2026-05-25 | elodie.peeters@testmail.com | 32471234567            | size must be between 3 and 18       | lastname too short        |
            | 2      | Élodie                    | ThisLastNameIsTooLong123 | true        | 2026-05-20 | 2026-05-25 | elodie.peeters@testmail.com | 32471234567            | size must be between 3 and 18       | lastname too long         |
            | 2      | Élodie                    | Peeters                  | true        | 2026-05-25 | 2026-05-20 | elodie.peeters@testmail.com | 12345678901            | Failed to create booking            | checkout before checkin   |
            | 2      | Élodie                    | Peeters                  | true        | 2026-05-20 | 2026-05-20 | elo.doe@example.com         | 12345678901            | Failed to create booking            | same checkin and checkout |
            | 2      | Élodie                    | Brûlé                    | true        | 2026-05-20 | 2026-05-25 | invalidemail                | 12345678901            | must be a well-formed email address | invalid email format      |
            | 2      | Élodie                    | Peeters                  | true        | 2026-05-20 | 2026-05-25 | jean@domain                 | 12345678901            | must be a well-formed email address | missing TLD               |
            | 2      | Élodie                    | Peeters                  | true        | 2026-05-20 | 2026-05-25 | @test.com                   | 12345678901            | must be a well-formed email address | missing local part        |
            | 2      | Élodie                    | Peeters                  | true        | 2026-05-20 | 2026-05-25 | elodie.doe@example.com      | 1234567890             | size must be between 11 and 21      | phone too short           |
            | 2      | Élodie                    | Peeters                  | true        | 2026-05-20 | 2026-05-25 | john.peeters@example.com    | 3247123456789012345678 | size must be between 11 and 21      | phone too long            |
            | abc    | Élodie                    | Peeters                  | true        | 2026-05-20 | 2026-05-25 | john.doe@example.com        | 12345678901            | Failed to create booking            | invalid roomid type       |

    @updatebooking @negative @inputvalidation @exploratory
    Scenario: Fail to update booking with missing required fields
        Given the Cookie header is set to "token={auth_token}"
        And I have the booking details:
            | firstname | Élodie |
        When I send a PUT request to "/booking/{booking_id}"
        Then the response status code should be 400
        And the response body should contain the key "errors"