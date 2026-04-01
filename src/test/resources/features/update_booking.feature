@booking @updatebooking
Feature: Update Booking (Full Update)
    As an authenticated user of the Restful-Booker API
    I want to fully update an existing booking using a PUT request
    So that I can replace all booking details with new information

    Background:
        Given the API base URL is "https://automationintesting.online/api"
        And I am authenticated with valid auth token stored in "auth_token"
        And there is a existing booking with the booking ID stored in "booking_id"

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
            | roomid | firstname | lastname | depositpaid | checkin   | checkout   | email                       | phone       | status_code |
            | 2      | Élodie    | Peeters  | false       | <today+2> | <today+5>  | elodie.peeters@testmail.com | 32471234567 | 200         |
            | 1      | André     | Brûlé    | true        | <today+7> | <today+12> | andre.brule@testmail.com    | 32479876543 | 200         |

    @updatebooking @positive @integration
    Scenario Outline: Successfully update a booking and verify booking via GET
        Given the Cookie header is set to "token={auth_token}"
        And I have valid booking details for update
        When I send a PUT request to "/booking/{booking_id}"
        Then the response status code should be <status_code>
        And the response body should contain the updated booking details
        When I send a GET request to "/booking/{booking_id}"
        Then the response status code should be 200
        And the response body should contain updated booking details

        Examples:
            | roomid | firstname | lastname | depositpaid | checkin   | checkout   | email                       | phone       | status_code |
            | 2      | Élodie    | Peeters  | false       | <today+2> | <today+5>  | elodie.peeters@testmail.com | 32471234567 | 200         |
            | 1      | André     | Brûlé    | true        | <today+7> | <today+12> | andre.brule@testmail.com    | 32479876543 | 200         |

    # ---------------------------- Negative Scenarios ----------------------------
    @updatebooking @negative @auth
    Scenario Outline: Fail to update booking with invalid or missing token
        Given the Cookie header is set to "<cookie_value>"
        And I have valid booking details for update
        When I send a PUT request to "/booking/{booking_id}" with the specified cookie
        Then the response status code should be <status_code>
        And the response body should contain the key "error"
        And the value of "error" should be "Unauthorized"

        Examples:
            | cookie_value       | status_code | reason              |
            | removed            | 401         | missing token       |
            | token=invalidtoken | 401         | invalid token value |
            | token=             | 401         | empty token value   |
            | wrongcookie=abc123 | 401         | wrong cookie key    |

    @updatebooking @negative @exploratory
    Scenario Outline: Fail to update a non-existent booking
        Given the Cookie header is set to "token={auth_token}"
        When I send a PUT request to "/booking/<booking_id>" with a non-existent booking ID
        Then the response status code should be <status_code>
        And the response body should contain the key "error"

        Examples:
            | booking_id | status_code | reason          |
            | 9999999    | 404         | non-existent ID |
            | 0          | 404         | zero ID         |
            | -1         | 404         | negative ID     |

    @updatebooking @negative @inputvalidation
    Scenario Outline: Fail to update booking with invalid or missing field values
        Given the Cookie header is set to "token={auth_token}"
        And I have request body with <field> "<value>" and other valid fields
        When I send a PUT request to "/booking/{booking_id}"
        Then the response status code should be <status_code>
        And the response body should contain the key "errors"
        And the errors list should contain "<error_message>"

        Examples:
            | field     | value                     | status_code | error_message                       | reason                    |
            | firstname | Lu                        | 400         | size must be between 3 and 18       | firstname too short       |
            | firstname | ThisNameIsWayTooLong1234  | 400         | size must be between 3 and 18       | firstname too long        |
            | lastname  | Pe                        | 400         | size must be between 3 and 18       | lastname too short        |
            | lastname  | ThisLastNameIsTooLong1234 | 400         | size must be between 3 and 18       | lastname too long         |
            | phone     | 3247123456                | 400         | size must be between 11 and 21      | phone too short           |
            | phone     | 3247123456789012345678    | 400         | size must be between 11 and 21      | phone too long            |
            | email     | émilie                    | 400         | must be a well-formed email address | invalid email format      |
            | email     | pierre@domain             | 400         | must be a well-formed email address | missing TLD               |
            | email     | jeanluc@domain_com        | 400         | must be a well-formed email address | invalid domain format     |
            | email     | @angélique.fr             | 400         | must be a well-formed email address | missing local part        |
            | checkin   | <today+7>                 | 400         | Failed to create booking            | checkout before checkin   |
            | checkout  | <today+2>                 | 400         | Failed to create booking            | same checkin and checkout |

    @updatebooking @negative @inputvalidation
    Scenario Outline: Fail to update booking when mandatory fields are missing
        Given the Cookie header is set to "token={auth_token}"
        And I have request body with <field> "<value>" and other valid fields
        When I send a PUT request to "/booking/{booking_id}"
        Then the response status code should be <status_code>
        And the response body should contain the key "errors"
        And the errors list should not be empty

        Examples:
            | field     | value   | status_code | reason                                     |
            | firstname | removed | 400         | firstname is mandatory and cannot be empty |
            | lastname  | removed | 400         | lastname is mandatory and cannot be empty  |
            | checkin   | removed | 400         | checkin date is required                   |
            | checkout  | removed | 400         | checkout date is required                  |
            | email     | removed | 400         | email is mandatory and cannot be empty     |
