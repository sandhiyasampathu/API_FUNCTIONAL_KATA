# API Functional KATA

## Overview

This project focuses on creating Behavior-Driven Development (BDD) feature files for the API Functional KATA, using the provided Swagger specification as the source of truth.

## Swagger File Location

The Swagger specification file is stored in the repository at:
[booking.yaml](src/test/resources/spec/booking.yaml)

This file defines the API contract, including endpoints, request/response structures, and expected behaviors.

## Feature Files

BDD feature files are created based on the `booking.yaml` specification.  
These feature files describe the expected behavior of the API in a human-readable format and ensure alignment with the API contract.

## Manual Validation (Bruno)

The Swagger file is imported into Bruno for manual validation of the API.

### Steps

1. Import the Swagger file from:
[booking.yaml](src/test/resources/spec/booking.yaml)
2. Load the collection in Bruno.
3. Execute the requests generated from the Swagger file.
4. Validate that the API responses match the scenarios defined in the feature files.

## Purpose

- Define API behavior using BDD feature files
- Ensure consistency with the Swagger (OpenAPI) specification
- Support manual validation of API endpoints using Bruno

## Tools and Artifacts Used

- **Swagger Editor** (<https://editor.swagger.io/>) – online tool to view Swagger files
- **Bruno (API Client)** – for manual API testing and validation
- **BDD Feature Files** – to define and validate API behavior in a human-readable way (Behavior-Driven Development)


## Observations

| #  | Endpoint / Action       | Observation / Issue                                                                 | Screenshot |
|----|------------------------|-----------------------------------------------------------------------------------|------------|
| 1  | Create Booking         | Returns **201** instead of **200** as per Swagger.                                  | ![1_create_booking_201](src/test/resources/observations/1_create_booking_201.png) |
| 2  | Create Booking         | **booking, email, phone** missing in response.                                      | ![2_create_booking_missing](src/test/resources/observations/2_create_booking_missing.png) |
| 3  | Create Booking         | Allows **back-dated** bookings.                                                    | ![3_create_booking_backdated](src/test/resources/observations/3_create_booking_backdated.png) |
| 4  | Create Booking         | **Date validation** incorrect; check-in dates modified in response.                       | ![4_create_booking_dates](src/test/resources/observations/4_create_booking_dates.png) |
| 5  | Create Booking         | Last name >18 chars allowed; Swagger specifies **3–18 chars**.                       | ![5_create_booking_lastname](src/test/resources/observations/5_create_booking_lastname.png) |
| 6  | Create Booking         | Last name >30 chars triggers error instead of 18-char max.                          | ![6_create_booking_lastname30](src/test/resources/observations/6_create_booking_lastname30.png) |
| 7  | Create Booking         | No error for email with **invalid TLD**.                                           | ![7_create_booking_email](src/test/resources/observations/7_create_booking_email.png) |
| 8  | Create Booking         | Duplicate room ID returns **409 Conflict**.                                         | ![8_create_booking_409](src/test/resources/observations/8_create_booking_409.png) |
| 9  | Create Booking         | Check-out before check-in returns **409 Conflict** with `error` key instead of 400/`errors`. | ![9_create_booking_dates409](src/test/resources/observations/9_create_booking_dates409.png) |
| 10 | Delete Booking         | Returns **200** instead of 201; positive flow has **no schema**.                   | ![10_delete_booking_200](src/test/resources/observations/10_delete_booking_200.png) |
| 11 | Delete Booking         | 401 shows “Authentication required” instead of “Unauthorized”.                     | ![11_delete_booking_401](src/test/resources/observations/11_delete_booking_401.png) |
| 12 | Delete Booking         | Missing/invalid token returns **500** instead of 401.                               | ![12_delete_booking_invalid_token](src/test/resources/observations/12_create_booking_invalid_token_1.png) |
| 13 | Delete Booking         | Invalid booking ID returns **500** instead of 404.                                  | ![13_delete_booking_invalid_id](src/test/resources/observations/13_delete_booking_invalid_id.png) |
| 14 | Delete Booking         | Deleting same booking twice returns **500** instead of 404.                          | ![14_delete_booking_twice](src/test/resources/observations/14_delete_booking_twice_2.png) |
