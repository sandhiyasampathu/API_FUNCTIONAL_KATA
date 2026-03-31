@booking @createbooking
Feature: Create Booking
    As a user of the Restful-Booker API
    I want to create a new hotel booking
    So that I can reserve a room with the required guest and date details

    Background:
        Given the API base URL is "https://automationintesting.online/api"
        And the booking endpoint is "/booking"
        And the request Content-Type header is set to "application/json"

    # ---------------------------- Positive Scenarios ----------------------------
    @createbooking @smoke @positive
    Scenario Outline: Successfully create a booking with valid data
        Given I have the request body with booking details:
            | roomid      | <roomid>      |
            | firstname   | <firstname>   |
            | lastname    | <lastname>    |
            | depositpaid | <depositpaid> |
            | checkin     | <checkin>     |
            | checkout    | <checkout>    |
            | email       | <email>       |
            | phone       | <phone>       |
        When I send a POST request to the booking endpoint
        Then the response status code should be <status_code>
        And the response body should contain the key "bookingid"
        And the response body should contain the key "booking"
        And the response booking details should match the request details

        Examples:
            | roomid | firstname | lastname | depositpaid | checkin    | checkout   | email                        | phone        | status_code |
            | 3      | Élodie    | Peeters  | true        | <today+2>  | <today+5>  | Élodie_peeters@testmail.com  | +32471234567 | 200         |
            | 2      | Emma      | Brûlé    | false       | <today+7>  | <today+10> | emma.Brûlé@testmail.com      | 32479876543  | 200         |
            | 1      | Matthias  | De Smet  | true        | <today+10> | <today+15> | matthias.desmet@testmail.com | 32471122334  | 200         |

    # ---------------------------- Negative Scenarios ----------------------------
    @createbooking @negative @inputvalidation
    Scenario Outline: Fail to create booking with invalid or missing field values
        Given I have the request body with <field> "<value>" and other valid fields
        When I send a POST request to the booking endpoint
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

    @createbooking @negative @inputvalidation
    Scenario Outline: Fail to create booking when mandatory fields are missing
        Given I have the request body with <field> "<value>" and other valid fields
        When I send a POST request to the booking endpoint
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