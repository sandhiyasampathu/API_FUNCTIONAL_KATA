@booking @authentication
Feature: Authentication - Create Token
    As a registered user of the Restful-Booker API
    I want to authenticate with valid credentials
    So that I can obtain a token to access protected endpoints

    Background:
        Given the API base URL is "https://automationintesting.online/api"
        And the authentication endpoint is "/auth/login"
        And the request Content-Type header is set to "application/json"

    # ------------------- Positive Authentication ----------------
    @positive @smoke
    Scenario Outline: Successful authentication with valid credentials
        Given I have the authentication details:
            | username | <username> |
            | password | <password> |
        When I send a POST request to the authentication endpoint
        Then the response status code should be <status_code>
        And the response body should contain the key "token"
        And the value of "token" should not be empty

        Examples:
            | username | password | status_code |
            | admin    | password | 200         |

    # ------------------- Negative Authentication ----------------
    @negative @auth
    Scenario Outline: Failed authentication with invalid credentials
        Given I have the authentication details:
            | username | <username> |
            | password | <password> |
        When I send a POST request to the authentication endpoint
        Then the response status code should be <status_code>
        And the response body should contain the key "error"
        And the value of "error" should be "<error_message>"

        Examples:
            | username    | password      | status_code | error_message       |
            | admin       | wrongpassword | 401         | Invalid credentials |
            | unknownuser | password      | 401         | Invalid credentials |
            | admin       |               | 401         | Invalid credentials |
            |             | password      | 401         | Invalid credentials |
            | wronguser   | wrongpass     | 401         | Invalid credentials |

    @negative @auth
    Scenario: Authentication fails when username is missing
        Given I have the authentication details:
            | password | password |
        When I send a POST request to the authentication endpoint
        Then the response status code should be 401
        And the response body should contain the key "error"
        And the value of "error" should be "Invalid credentials"

    @negative @auth
    Scenario: Authentication fails when password is missing
        Given I have the authentication details:
            | username | admin |
        When I send a POST request to the authentication endpoint
        Then the response status code should be 401
        And the response body should contain the key "error"
        And the value of "error" should be "Invalid credentials"

    # ------------------- Exploratory / Edge Cases ----------------
    @negative @auth @exploratory
    Scenario: Authentication fails with empty request body
        Given I have no authentication details
        When I send a POST request to the authentication endpoint
        Then the response status code should be 401
        And the response body should contain the key "error"

    @negative @exploratory
    Scenario Outline: Authentication with long or special-character credentials
        Given I have the authentication details:
            | username | <username> |
            | password | <password> |
        When I send a POST request to the authentication endpoint
        Then the response status code should be <status_code>
        And the response body should contain the key "<response_key>"

        Examples:
            | username                                           | password                      | status_code | response_key |
            | a_very_long_username_exceeding_50_chars_1234567890 | validpassword                 | 401         | error        |
            | admin                                              | very_long_password_!@#$%^&*() | 401         | error        |
            | special!@#$%^&*()                                  | password                      | 401         | error        |