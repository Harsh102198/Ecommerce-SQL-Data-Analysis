USE Ecommerce;
GO

-- Select all data from the Staging table
SELECT * 
FROM dbo.Staging;

-- Convert InvoiceDate column to DATETIME type
ALTER TABLE [Staging]
ALTER COLUMN InvoiceDate DATETIME;

-- Convert CustomerID column to INT type and allow NULLs
ALTER TABLE [dbo].[Staging]
ALTER COLUMN CustomerID INT NULL;

-- Delete rows where Description is NULL (invalid entries)
DELETE FROM [Staging Ecommerce]
WHERE Description IS NULL;

-- Delete rows where CustomerID is NULL (invalid entries)
DELETE FROM [Staging]
WHERE CustomerID IS NULL;

-- Delete rows for cancelled orders (InvoiceNo starting with 'C')
DELETE FROM [Staging]
WHERE InvoiceNo LIKE 'C%';

-- Delete rows where Quantity is 0 or negative (invalid transactions)
DELETE FROM [Staging]
WHERE Quantity <= 0;

-- Convert Quantity column to INT
ALTER TABLE [Staging]
ALTER COLUMN Quantity INT;

-- Convert UnitPrice column to DECIMAL with 2 decimal places
ALTER TABLE [Staging]
ALTER COLUMN UnitPrice DECIMAL(18,2);

-- Trim leading and trailing spaces from Description and Country columns
UPDATE [Staging]
SET Description = LTRIM(RTRIM(Description)),
    Country = LTRIM(RTRIM(Country));

-- Count remaining NULLs in Description and CustomerID after cleaning
SELECT 
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS NullDescription,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS NullCustomerID
FROM [Staging];

-- Check if there are any rows with Quantity <= 0 or UnitPrice <= 0
SELECT *
FROM [Staging]
WHERE Quantity <= 0 OR UnitPrice <= 0;

-- Check for cancelled invoices (InvoiceNo starting with 'C')
SELECT *
FROM [Staging]
WHERE InvoiceNo LIKE 'C%';

-- Top 10 products by total quantity sold
SELECT TOP 10 Description, SUM(Quantity) AS TotalQty
FROM [Staging]
GROUP BY Description
ORDER BY TotalQty DESC;

-- Revenue by country
SELECT Country, SUM(Quantity * UnitPrice) AS Revenue
FROM [Staging]
GROUP BY Country
ORDER BY Revenue DESC;

-- Self-join example: Find invoices where the same customer bought more than 1 product
SELECT a.InvoiceNo, a.CustomerID, a.Description AS Product1, b.Description AS Product2
FROM [dbo].[Staging] a
INNER JOIN [dbo].[Staging] b
    ON a.InvoiceNo = b.InvoiceNo AND a.StockCode <> b.StockCode;

-- Top 10 customers by total revenue
SELECT TOP 10 CustomerID, SUM(Quantity * UnitPrice) AS TotalRevenue
FROM dbo.Staging
GROUP BY CustomerID
ORDER BY TotalRevenue DESC;

-- Count of unique customers
SELECT COUNT(DISTINCT CustomerID) AS UniqueCustomers
FROM dbo.Staging;

-- Monthly revenue trend
SELECT YEAR(InvoiceDate) AS Year, MONTH(InvoiceDate) AS Month,
       SUM(Quantity * UnitPrice) AS Revenue
FROM dbo.Staging
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY Year, Month;

-- Revenue by day of the week
SELECT DATENAME(WEEKDAY, InvoiceDate) AS DayOfWeek,
       SUM(Quantity * UnitPrice) AS Revenue
FROM dbo.Staging
GROUP BY DATENAME(WEEKDAY, InvoiceDate)
ORDER BY Revenue DESC;

-- Top 10 products by number of times purchased
SELECT TOP 10 Description, COUNT(*) AS TimesPurchased
FROM dbo.Staging
GROUP BY Description
ORDER BY TimesPurchased DESC;

-- Top 10 products by total revenue
SELECT TOP 10 Description, SUM(Quantity * UnitPrice) AS TotalRevenue
FROM dbo.Staging
GROUP BY Description
ORDER BY TotalRevenue DESC;

-- Top 10 countries by revenue
SELECT TOP 10 Country, SUM(Quantity * UnitPrice) AS Revenue
FROM dbo.Staging
GROUP BY Country
ORDER BY Revenue DESC;
