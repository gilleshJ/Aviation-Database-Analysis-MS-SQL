-- ============================================================
-- Air Cargo Database Analysis
-- Script 02: Create Tables
-- Author: gilleshJ
-- Database: MS SQL Server 2019
-- ============================================================

USE air_cargo;
GO

-- ============================================================
-- Create customer table
-- Stores passenger personal information
-- ============================================================
CREATE TABLE customer (
    customer_id  INT           NOT NULL PRIMARY KEY,
    first_name   VARCHAR(50)   NOT NULL,
    last_name    VARCHAR(50)   NOT NULL,
    date_of_birth DATE         NOT NULL,
    gender       VARCHAR(10)   NOT NULL
);
GO

-- ============================================================
-- Create routes table
-- Stores flight route information
-- ============================================================
CREATE TABLE routes (
    route_id            INT          NOT NULL PRIMARY KEY,
    flight_num          VARCHAR(20)  NOT NULL,
    origin_airport      VARCHAR(100) NOT NULL,
    destination_airport VARCHAR(100) NOT NULL,
    aircraft_id         VARCHAR(20)  NOT NULL,
    distance_miles      INT          NOT NULL
);
GO

-- ============================================================
-- Create route_details table
-- Includes UNIQUE constraint on route_id
-- CHECK constraint on distance_miles (must be > 0)
-- ============================================================
CREATE TABLE route_details (
    route_id            INT          NOT NULL,
    flight_num          VARCHAR(20)  NOT NULL,
    origin_airport      VARCHAR(100) NOT NULL,
    destination_airport VARCHAR(100) NOT NULL,
    aircraft_id         VARCHAR(20)  NOT NULL,
    distance_miles      INT          NOT NULL,

    CONSTRAINT uq_route_id UNIQUE (route_id),
    CONSTRAINT chk_distance CHECK (distance_miles > 0)
);
GO

-- ============================================================
-- Create passengers_on_flights table
-- Links customers to routes with travel details
-- ============================================================
CREATE TABLE passengers_on_flights (
    aircraft_id  VARCHAR(20)  NOT NULL,
    route_id     INT          NOT NULL,
    customer_id  INT          NOT NULL,
    depart       VARCHAR(100) NOT NULL,
    arrival      VARCHAR(100) NOT NULL,
    seat_num     VARCHAR(10)  NOT NULL,
    class_id     VARCHAR(20)  NOT NULL,
    travel_date  DATE         NOT NULL,
    flight_num   VARCHAR(20)  NOT NULL
);
GO

-- ============================================================
-- Create ticket_details table
-- Stores ticket purchase information for each customer
-- ============================================================
CREATE TABLE ticket_details (
    p_date           DATE          NOT NULL,
    customer_id      INT           NOT NULL,
    aircraft_id      VARCHAR(20)   NOT NULL,
    class_id         VARCHAR(20)   NOT NULL,
    no_of_tickets    INT           NOT NULL,
    a_code           VARCHAR(10)   NOT NULL,
    price_per_ticket DECIMAL(10,2) NOT NULL,
    brand            VARCHAR(50)   NOT NULL
);
GO

PRINT 'All tables created successfully.';
