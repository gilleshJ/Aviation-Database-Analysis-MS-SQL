# Aviation-Database-Analysis-MS-SQL
Air Cargo database analysis project using MS SQL Server. Covers table design, constraints, joins, window functions, stored procedures, functions, cursors and more.
# ✈️ Aviation Database Analysis — MS SQL Server

![SQL Server](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC2927?style=for-the-badge&logo=microsoft%20sql%20server&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=for-the-badge)
![Queries](https://img.shields.io/badge/Queries-20-blue?style=for-the-badge)

## Project Overview

**Air Cargo** is an aviation company that provides air transportation services for passengers and freight. This project involves designing and querying a relational database to support business operations and reporting.

---

##  Database Schema

| Table | Description |
|-------|-------------|
| `customer` | Passenger personal details |
| `routes` | Flight route information |
| `passengers_on_flights` | Booking and travel records |
| `ticket_details` | Ticket pricing and class info |

---

##  Project Structure


---

##  How to Run

Run the scripts in this order:
   - `01_create_database.sql`
   - `02_create_tables.sql`
   - Load CSV data using SSMS Import Wizard
   - `03_queries.sql`
   - `04_stored_procedures.sql`

---

##  Dataset

| Table | Rows |
|-------|------|
| customer | 50 |
| routes | 49 |
| passengers_on_flights | 50 |
| ticket_details | 50 |

---

##  Technologies Used

- **Microsoft SQL Server 2019** (v15.0)
- **SQL Server Management Studio (SSMS) 2022**
- **SSIS** for data import

---

##  Author

**gilleshJ** — DBA in Training  
*This project is part of a course-end database analysis assignment.*

---

##  Coming Soon

- [ ] MySQL Implementation
- [ ] PostgreSQL Implementation
- [ ] Performance comparison across all three databases


