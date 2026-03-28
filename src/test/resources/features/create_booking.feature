Feature: Create Booking
    As a user of the Restful-Booker API
    I want to create a new hotel booking
    So that I can reserve a room with the required guest and date details

    Background:
        Given the API base URL is "https://automationintesting.online/api"
        And the booking endpoint is "/booking"
        And the request Content-Type header is set to "application/json"

    # ---------------------------- Positive Scenarios ----------------------------
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
