-- ============================================================
-- Air Cargo Database Analysis
-- Script 04: Views, Stored Procedures, Functions & Cursor
-- Queries 15 to 20
-- Author: gilleshJ
-- Database: MS SQL Server 2019
-- ============================================================

USE air_cargo;
GO

-- ============================================================
-- Query 15: Create a VIEW for business class customers
-- Shows customer details for Business class ticket holders
-- ============================================================
CREATE VIEW vw_business_class_customers AS
SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name,
    t.class_id,
    t.price_per_ticket,
    t.brand
FROM customer c
INNER JOIN ticket_details t
    ON c.customer_id = t.customer_id
WHERE t.class_id = 'Bussiness';
GO

-- Execute the view
SELECT * FROM vw_business_class_customers;
GO

-- ============================================================
-- Query 16: Stored Procedure — Get passengers by route range
-- Accepts start and end route_id as parameters
-- ============================================================
CREATE PROCEDURE usp_get_passengers_by_route
    @start_route INT,
    @end_route   INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM passengers_on_flights
    WHERE route_id BETWEEN @start_route AND @end_route;
END;
GO

-- Execute the stored procedure
EXEC usp_get_passengers_by_route @start_route = 1, @end_route = 25;
GO

-- ============================================================
-- Query 17: Stored Procedure — Get ticket revenue by class
-- Returns total revenue and passenger count per class
-- ============================================================
CREATE PROCEDURE usp_revenue_by_class
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        class_id,
        COUNT(*)                               AS total_passengers,
        SUM(price_per_ticket * no_of_tickets)  AS total_revenue
    FROM ticket_details
    GROUP BY class_id
    ORDER BY total_revenue DESC;
END;
GO

-- Execute the stored procedure
EXEC usp_revenue_by_class;
GO

-- ============================================================
-- Query 18: Stored Procedure — Get customer travel history
-- Returns all flights taken by a specific customer
-- ============================================================
CREATE PROCEDURE usp_customer_travel_history
    @customer_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        p.customer_id,
        c.first_name,
        c.last_name,
        p.route_id,
        p.flight_num,
        p.depart,
        p.arrival,
        p.travel_date,
        p.class_id
    FROM passengers_on_flights p
    INNER JOIN customer c
        ON p.customer_id = c.customer_id
    WHERE p.customer_id = @customer_id
    ORDER BY p.travel_date;
END;
GO

-- Execute the stored procedure
EXEC usp_customer_travel_history @customer_id = 1;
GO

-- ============================================================
-- Query 19: Stored Function — Calculate total spend per customer
-- Returns the total amount spent by a given customer
-- ============================================================
CREATE FUNCTION fn_total_customer_spend
(
    @customer_id INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total_spend DECIMAL(10,2);

    SELECT @total_spend = SUM(price_per_ticket * no_of_tickets)
    FROM ticket_details
    WHERE customer_id = @customer_id;

    RETURN ISNULL(@total_spend, 0);
END;
GO

-- Execute the function
SELECT
    customer_id,
    dbo.fn_total_customer_spend(customer_id) AS total_spend
FROM customer
ORDER BY total_spend DESC;
GO

-- ============================================================
-- Query 20: Cursor — Loop through all customers and print spend
-- Demonstrates cursor usage for row-by-row processing
-- ============================================================
DECLARE @cust_id    INT;
DECLARE @first_name VARCHAR(50);
DECLARE @last_name  VARCHAR(50);
DECLARE @spend      DECIMAL(10,2);

DECLARE customer_cursor CURSOR FOR
    SELECT customer_id, first_name, last_name
    FROM customer
    ORDER BY customer_id;

OPEN customer_cursor;

FETCH NEXT FROM customer_cursor
INTO @cust_id, @first_name, @last_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @spend = dbo.fn_total_customer_spend(@cust_id);

    PRINT 'Customer: ' + @first_name + ' ' + @last_name +
          ' | ID: ' + CAST(@cust_id AS VARCHAR) +
          ' | Total Spend: $' + CAST(@spend AS VARCHAR);

    FETCH NEXT FROM customer_cursor
    INTO @cust_id, @first_name, @last_name;
END;

CLOSE customer_cursor;
DEALLOCATE customer_cursor;
GO
