Feature: Create Booking
    As a user of the Restful-Booker API
    I want to create a new hotel booking
    So that I can reserve a room with the required guest and date details

    Background:
        Given the API base URL is "https://automationintesting.online/api"
        And the booking endpoint is "/booking"
        And the request Content-Type header is set to "application/json"

    # ---------------------------- Positive Scenarios ----------------------------
    @smoke @createbooking @positive
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
        And the value of "booking.firstname" should be "<firstname>"
        And the value of "booking.lastname" should be "<lastname>"
        And the value of "booking.roomid" should be <roomid>
        And the value of "booking.depositpaid" should be <depositpaid>
        And the value of "booking.bookingdates.checkin" should be "<checkin>"
        And the value of "booking.bookingdates.checkout" should be "<checkout>"
        And the value of "booking.email" should be "<email>"
        And the value of "booking.phone" should be "<phone>"

        Examples:
            | roomid | firstname | lastname | depositpaid | checkin    | checkout   | email                        | phone        | status_code |
            | 3      | Élodie    | Peeters  | true        | 2026-05-10 | 2026-05-15 | Élodie_peeters@testmail.com  | +32471234567 | 200         |
            | 2      | Emma      | Brûlé    | false       | 2026-06-01 | 2026-06-05 | emma.Brûlé@testmail.com      | 32479876543  | 200         |
            | 1      | Matthias  | De Smet  | true        | 2026-07-20 | 2026-07-26 | matthias.desmet@testmail.com | 32471122334  | 200         |

    # ---------------------------- Negative Scenarios ----------------------------
    @createbooking @negative @inputvalidation
    Scenario Outline: Fail to create booking with invalid firstname
        Given I have the request body with firstname "<firstname>" and other valid fields
        When I send a POST request to the booking endpoint
        Then the response status code should be 400
        And the response body should contain the key "errors"
        And the errors list should contain "size must be between 3 and 18"

        Examples:
            | firstname                | reason                    |
            | Lu                       | too short (below 3 chars) |
            | ThisNameIsWayTooLong1234 | too long (above 18 chars) |

    @createbooking @negative @inputvalidation
    Scenario Outline: Fail to create booking with invalid lastname
        Given I have the request body with lastname "<lastname>" and other valid fields
        When I send a POST request to the booking endpoint
        Then the response status code should be 400
        And the response body should contain the key "errors"
        And the errors list should contain "size must be between 3 and 18"

        Examples:
            | lastname                  | reason                    |
            | Pe                        | too short (below 3 chars) |
            | ThisLastNameIsTooLong1234 | too long (above 18 chars) |

    @createbooking @negative @inputvalidation
    Scenario Outline: Fail to create booking with invalid phone number
        Given I have the request body with phone "<phone>" and other valid fields
        When I send a POST request to the booking endpoint
        Then the response status code should be 400
        And the response body should contain the key "errors"
        And the errors list should contain "size must be between 11 and 21"

        Examples:
            | phone                  | reason                     |
            | 3247123456             | too short (below 11 chars) |
            | 3247123456789012345678 | too long (above 21 chars)  |

    @createbooking @negative @inputvalidation
    Scenario Outline: Fail to create booking with invalid email
        Given I have the request body with email "<email>" and other valid fields
        When I send a POST request to the booking endpoint
        Then the response status code should be 400
        And the response body should contain the key "errors"
        And the errors list should contain "must be a well-formed email address"

        Examples:
            | email              | reason                |
            | émilie             | missing @ and domain  |
            | pierre@domain      | missing TLD           |
            | jeanluc@domain_com | invalid domain format |
            | @angélique.fr      | missing local part    |

    @createbooking @negative @inputvalidation
    Scenario: Fail to create booking when checkout is before checkin
        Given I have the request body with checkin "2026-05-15" and checkout "2026-05-10"
        When I send a POST request to the booking endpoint
        Then the response status code should be 400
        And the response body should contain the key "errors"
        And the errors list should contain "Failed to create booking"

    @createbooking @negative @inputvalidation
    Scenario: Fail to create booking when checkout equals checkin
        Given I have the request body with checkin "2026-05-10" and checkout "2026-05-10"
        When I send a POST request to the booking endpoint
        Then the response status code should be 400
        And the response body should contain the key "errors"
        And the errors list should contain "Failed to create booking"