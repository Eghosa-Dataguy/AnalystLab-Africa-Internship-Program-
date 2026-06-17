----------------------------Task 1
USE E_Commerce_Analystlab;

----1. Display First Rows
SELECT TOP 10 *
FROM OnlineRetailDB;

----2. Number of Row
SELECT COUNT(*) AS TotalRows
FROM OnlineRetailDB;

----Number of Columns
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='OnlineRetailDB';

------Data type
SELECT
COLUMN_NAME,
DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='OnlineRetailDB';

----Dataset Description
----Online Retail Contains transactions from a UK online retail store including products purchased,
----quantities, customer IDs, countries and prices,with 541,909 Total rows and 8 Total Columns .

------------------------------------------TASK 2: DATA CLEANING
----missing value
SELECT
SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS MissingDescription,
SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID
FROM OnlineRetailDB;

---Remove rows with missing CustomerID
DELETE
FROM OnlineRetailDB
WHERE CustomerID IS NULL;

------check for duplicate
SELECT *,
COUNT(*) AS DuplicateCount
FROM OnlineRetailDB
GROUP BY
InvoiceNo,
StockCode,
Description,
Quantity,
InvoiceDate,
UnitPrice,
CustomerID,
Country
HAVING COUNT(*) > 1;

----remove duplicate
WITH CTE AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY
InvoiceNo,
StockCode,
Description,
Quantity,
InvoiceDate,
UnitPrice,
CustomerID,
Country
ORDER BY InvoiceNo
) rn
FROM OnlineRetailDB
)

DELETE FROM CTE
WHERE rn > 1;

-------------------------------TASK 3: EDA

------Top selling product
SELECT TOP 10
Description,
SUM(Quantity) AS TotalSold
FROM OnlineRetailDB
GROUP BY Description
ORDER BY TotalSold DESC;

------highest revenue country
SELECT TOP 10
Country,
SUM(Quantity * UnitPrice) Revenue
FROM OnlineRetailDB
GROUP BY Country
ORDER BY Revenue DESC;

------monthly sales trend
SELECT
YEAR(InvoiceDate) AS Year_,
MONTH(InvoiceDate) AS Month_,
SUM(Quantity * UnitPrice) Revenue
FROM OnlineRetailDB
GROUP BY
YEAR(InvoiceDate),
MONTH(InvoiceDate)
ORDER BY Year_, Month_;

------most purchased product
SELECT TOP 10
Description,
COUNT(*) Purchases
FROM OnlineRetailDB
GROUP BY Description
ORDER BY Purchases DESC;

----customer purchase behaviour
SELECT TOP 10
CustomerID,
SUM(Quantity*UnitPrice) TotalSpent
FROM OnlineRetailDB
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

----------SUMMARY STATISTICS

 

-----------revenue
SELECT
AVG(UnitPrice) AvgPrice,
MIN(UnitPrice) MinPrice,
MAX(UnitPrice) MaxPrice,
STDEV(UnitPrice) StdPrice
FROM OnlineRetailDB;

SELECT *
FROM OnlineRetailDB;

 