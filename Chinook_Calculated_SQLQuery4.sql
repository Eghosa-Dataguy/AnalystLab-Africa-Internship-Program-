
USE Sales_Data_Analystlab;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sales_dataDB';

-- CLEANING QUERIES

SELECT * FROM Sales_dataDB;

SELECT CONVERT(DATE, ORDERDATE) AS ORDERDATE
FROM Sales_dataDB;

ALTER TABLE sales_dataDB
ALTER COLUMN ORDERDATE DATE;

SELECT * FROM Sales_dataDB;

SELECT CONVERT(DECIMAL(10,2), ROUND(PRICEEACH, 2)) AS PRICEEACH
FROM Sales_dataDB;

ALTER TABLE sales_dataDB
ALTER COLUMN PRICEEACH DECIMAL(10,2);

SELECT * FROM Sales_dataDB;

SELECT CONVERT(DECIMAL(10,2), ROUND(SALES, 2)) AS SALES
FROM Sales_dataDB;

ALTER TABLE sales_dataDB
ALTER COLUMN SALES DECIMAL(10,2);

SELECT * FROM Sales_dataDB;

ALTER TABLE sales_dataDB
DROP COLUMN CLEANEPHONENUMBER;

SELECT CASE WHEN LEN(Digits) > 10 THEN 
            '+' + LEFT(Digits, LEN(Digits) - 10) + ' ' +
            '(' + SUBSTRING(Digits, LEN(Digits) - 9, 3) + ') ' +
            SUBSTRING(Digits, LEN(Digits) - 6, 3) + '-' +
            SUBSTRING(Digits, LEN(Digits) - 3, 4)
ELSE
    '(' + SUBSTRING(Digits, 1, 3) + ') ' +
            SUBSTRING(Digits, 4, 3) + '-' +
            SUBSTRING(Digits, 7, 4)  END AS FormattedPhoneNumber
FROM (
    SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
    PHONE,'(','') ,')','') ,'-','') ,' ','') ,'.','') ,'+','') ,'[','') ,']','') ,'{','') ,'}',''
    ) AS Digits
    FROM Sales_dataDB
) t;

SELECT Phone AS OldValue,
       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
       Phone,'(','') ,')','') ,'-','') ,' ','') ,'.','') ,'+','') ,'[','') ,']','') ,'{','') ,'}',''
       ) AS CleanValue
FROM Sales_dataDB;

UPDATE Sales_dataDB
SET PHONE = CASE WHEN LEN(Digits) > 10 THEN 
            '+' + LEFT(Digits, LEN(Digits) - 10) + ' ' +
            '(' + SUBSTRING(Digits, LEN(Digits) - 9, 3) + ') ' +
            SUBSTRING(Digits, LEN(Digits) - 6, 3) + '-' +
            SUBSTRING(Digits, LEN(Digits) - 3, 4)
ELSE
            '(' + SUBSTRING(Digits, 1, 3) + ') ' +
            SUBSTRING(Digits, 4, 3) + '-' +
            SUBSTRING(Digits, 7, 4) END
FROM Sales_dataDB
CROSS APPLY (
    SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
    PHONE,'(','') ,')','') ,'-','') ,' ','') ,'.','') ,'+','') ,'[','') ,']','') ,'{','') ,'}',''
    ) AS Digits
) c;


UPDATE Sales_dataDB
SET ADDRESSLINE2 = ISNULL(ADDRESSLINE2, 'UNKNOWN')
WHERE ADDRESSLINE2 IS NULL;

UPDATE Sales_dataDB
SET STATE = ISNULL(STATE, 'UNKNOWN')
WHERE STATE IS NULL;

UPDATE Sales_dataDB
SET POSTALCODE = ISNULL(POSTALCODE, 'UNKNOWN')
WHERE POSTALCODE IS NULL;

SELECT * 
FROM Sales_dataDB;

-- ANALYZING QUERIES

-- BASIC SQL QUERIES 


---- Total Revenue 

SELECT SUM (Sales) AS Total_Revenue
FROM Sales_dataDB;

---- Total Customers 

SELECT COUNT(DISTINCT CUSTOMERNAME) AS Total_Customers
FROM Sales_dataDB;

---- Total Quantity Orderd

SELECT SUM (QUANTITYORDERED) AS Total_Quantity_Ordered
FROM Sales_dataDB;

---- Total Orders(Sales Transactions)

SELECT COUNT(DISTINCT ordernumber) AS total_orders
FROM sales_dataDB;

-- Average Order Value

SELECT AVG(sales) AS avg_order_value
FROM sales_dataDB;

-- Top 10 Products by Revenue

SELECT TOP 10 PRODUCTCODE, PRODUCTLINE, SUM(sales) AS total_revenue
FROM sales_dataDB
GROUP BY PRODUCTCODE, PRODUCTLINE
ORDER BY total_revenue DESC;

-- Top 10 Performing Product BY Quantity

SELECT TOP 10 PRODUCTCODE, 
 SUM(QUANTITYORDERED) AS TOTAL_QUANTITY_ORDERED
FROM sales_dataDB
GROUP BY PRODUCTCODE
ORDER BY TOTAL_QUANTITY_ORDERED DESC;

-- Top 10 Customers by Revenue

SELECT TOP 10 customername, SUM(sales) AS total_revenue
FROM sales_dataDB
GROUP BY customername
ORDER BY total_revenue DESC;


-- Top 10 Customers by Number of Orders

SELECT TOP 10 customername, COUNT(DISTINCT ordernumber) AS total_orders
FROM sales_dataDB
GROUP BY customername
ORDER BY total_orders DESC;

-- Yearly Revenue Trend

SELECT year_id, SUM(sales) AS total_revenue
FROM sales_dataDB
GROUP BY year_id
ORDER BY year_id;

-- Monthly Revenue Trend (within each year)

SELECT year_id, month_id, SUM(sales) AS Monthly_revenue
FROM sales_dataDB
GROUP BY year_id, month_id
ORDER BY year_id, month_id;

-- Country with Highest Revenue

SELECT country, SUM(sales) AS total_revenue
FROM sales_dataDB
GROUP BY country
ORDER BY total_revenue DESC;

-- JOINS

-- CREATING CUSTOMER TABLE

CREATE TABLE CUSTOMER(
    CUSTOMERID INT PRIMARY KEY IDENTITY(1,1),
    CUSTOMERNAME VARCHAR(255)NOT NULL,
    PRODUCTLINE VARCHAR (255)
    );

  INSERT INTO CUSTOMER(CUSTOMERNAME, PRODUCTLINE)
  SELECT DISTINCT CUSTOMERNAME,PRODUCTLINE
  FROM Sales_dataDB;

  SELECT * FROM CUSTOMER

-- INNER JOIN

SELECT S.CUSTOMERNAME, C.PRODUCTLINE,S.SALES
FROM Sales_dataDB S
INNER JOIN CUSTOMER C
ON S.CUSTOMERNAME = C.CUSTOMERNAME;

SELECT * FROM Sales_dataDB;

CREATE INDEX idx_customer
ON sales_dataDB(CUSTOMERNAME);


CREATE INDEX idx_productline
ON sales_dataDB(PRODUCTLINE);


CREATE INDEX idx_country
ON sales_dataDB(COUNTRY);

EXEC sp_helpindex 'sales_dataDB';





