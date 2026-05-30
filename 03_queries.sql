-- ============================================================
-- Air Cargo Database Analysis
-- Script 03: Queries 3 to 14
-- Author: gilleshJ
-- Database: MS SQL Server 2019
-- ============================================================

USE air_cargo;
GO

-- ============================================================
-- Query 3: Display all passengers on routes 01 to 25
-- Uses BETWEEN operator to filter route_id range
-- ============================================================
SELECT *
FROM passengers_on_flights
WHERE route_id BETWEEN 1 AND 25;
GO

-- ============================================================
-- Query 4: Number of passengers and total revenue in Business Class
-- Uses COUNT and SUM aggregate functions
-- ============================================================
SELECT COUNT(*) AS no_of_passengers,
       SUM(price_per_ticket * no_of_tickets) AS total_revenue
FROM ticket_details
WHERE class_id = 'Bussiness';
GO

-- ============================================================
-- Query 5: Display full name of each customer
-- Uses CONCAT to combine first and last name
-- ============================================================
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customer;
GO

-- ============================================================
-- Query 6: Customers who have registered and booked a ticket
-- Uses INNER JOIN between customer and ticket_details
-- ============================================================
SELECT DISTINCT c.customer_id,
       c.first_name,
       c.last_name,
       t.aircraft_id,
       t.class_id,
       t.no_of_tickets
FROM customer c
INNER JOIN ticket_details t
    ON c.customer_id = t.customer_id;
GO

-- ============================================================
-- Query 7: Customers who travelled in Economy Plus class
-- Checks using GROUP BY and HAVING
-- ============================================================
SELECT customer_id,
       class_id,
       COUNT(*) AS total_trips
FROM passengers_on_flights
WHERE class_id = 'Economy Plus'
GROUP BY customer_id, class_id
HAVING COUNT(*) > 0;
GO

-- ============================================================
-- Query 8: Revenue check — if total revenue > 10000 print message
-- Uses aggregate with conditional output
-- ============================================================
SELECT
    CASE
        WHEN SUM(price_per_ticket * no_of_tickets) > 10000
        THEN 'Revenue target achieved'
        ELSE 'Revenue target not achieved'
    END AS revenue_status,
    SUM(price_per_ticket * no_of_tickets) AS total_revenue
FROM ticket_details;
GO

-- ============================================================
-- Query 9: Customers whose ticket was in Economy Plus
-- and who travelled on a complimentary service (brand check)
-- ============================================================
SELECT customer_id,
       brand,
       class_id,
       no_of_tickets
FROM ticket_details
WHERE class_id = 'Economy Plus'
  AND brand = 'Emirates';
GO

-- ============================================================
-- Query 10: Create a new user with required permissions
-- User management: CREATE LOGIN and GRANT privileges
-- ============================================================
CREATE LOGIN new_user WITH PASSWORD = 'StrongPass@123';
GO
CREATE USER new_user FOR LOGIN new_user;
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO new_user;
GO

-- ============================================================
-- Query 11: Maximum ticket price for each class
-- Uses window function MAX() OVER (PARTITION BY class_id)
-- ============================================================
SELECT DISTINCT
       class_id,
       MAX(price_per_ticket) OVER (PARTITION BY class_id) AS max_ticket_price
FROM ticket_details;
GO

-- ============================================================
-- Query 12: Create index on route_details for performance
-- Index on flight_num column to speed up lookups
-- ============================================================
CREATE INDEX idx_route_flight_num
ON route_details (flight_num);
GO

-- ============================================================
-- Query 13: View execution plan using SET STATISTICS
-- Analyzes query performance before and after index creation
-- ============================================================
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT *
FROM route_details
WHERE flight_num = 'MH001';

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

-- ============================================================
-- Query 14: Total passengers per aircraft using ROLLUP
-- Provides subtotals and grand total
-- ============================================================
SELECT
    aircraft_id,
    route_id,
    COUNT(*) AS total_passengers
FROM passengers_on_flights
GROUP BY ROLLUP (aircraft_id, route_id);
GO
