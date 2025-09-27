# Ecommerce SQL Data Analysis

This repository contains SQL queries performed on the `Staging` table of the **Ecommerce** database. The queries cover **data cleaning, transformation, aggregation, and analysis**, providing key insights into sales, customers, and products.

---

## Repository Structure

- `queries.sql` – SQL queries with descriptive comments  
- `dataset.csv` – Raw dataset  
- `screenshots/` – Output of each query for reference  

---

## Queries Overview

### Data Cleaning & Preparation
- Converted `InvoiceDate` to `DATETIME` and `CustomerID` to `INT`  
- Removed rows with NULL `Description` or `CustomerID`  
- Deleted cancelled orders (`InvoiceNo` starting with 'C')  
- Eliminated rows with invalid `Quantity` or `UnitPrice`  
- Trimmed spaces from text fields for consistency  

### Data Exploration & Aggregation
- Top 10 products by **quantity sold** and **revenue**  
- Revenue by **country**, **month**, and **day of the week**  
- Top 10 customers by **total revenue**  
- Count of **unique customers**  
- Frequency of product purchases  

### Advanced Analysis
- **Self-join** to identify invoices where a customer purchased multiple products  

---
