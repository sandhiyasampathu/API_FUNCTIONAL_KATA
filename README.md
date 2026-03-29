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
| 1  | Create Booking         | Returns **201** instead of 200 as per Swagger documentation                       | ![1_create_booking_201](src/test/resources/observations/1_create_booking_201.png) |
| 2  | Create Booking         | Booking key **email and phone** not available in the response                        | ![2_create_booking_missing](src/test/resources/observations/2_create_booking_missing.png) |
| 3  | Create Booking         | Allows **back-dated** booking                                                          | ![3_create_booking_backdated](src/test/resources/observations/3_create_booking_backdated.png) |
| 4  | Create Booking         | **Incorrect** input date validations; check-in dates in response are modified         | ![4_create_booking_dates](src/test/resources/observations/4_create_booking_dates.png) |
| 5  | Create Booking         | Swagger specifies **3–18 chars** for last name, but no error displayed                | ![5_create_booking_lastname](src/test/resources/observations/5_create_booking_lastname.png) |
| 6  | Create Booking         | Error displayed when last name is **more than 30 characters**                          | ![6_create_booking_lastname30](src/test/resources/observations/6_create_booking_lastname30.png) |
| 7  | Create Booking         | **No error** displayed for email addresses with **incorrect TLD**(Top-Level Domain)                          | ![7_create_booking_email](src/test/resources/observations/7_create_booking_email.png) |
| 8  | Create Booking         | Returns **409 Conflict** when the same room ID is used                             | ![8_create_booking_409](src/test/resources/observations/8_create_booking_409.png) |
| 9  | Create Booking         | Invalid dates (check-out before check-in) also return **409 Conflict**             | ![9_create_booking_dates409](src/test/resources/observations/9_create_booking_dates409.png) |
