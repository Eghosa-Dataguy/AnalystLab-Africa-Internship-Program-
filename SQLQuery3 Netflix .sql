USE Netflix_Analystlab;

SELECT TOP 10 *
FROM NetflixDB;

---number of row
SELECT COUNT(*) AS TotalRows
FROM NetflixDB;

----number of column 
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='NetflixDB';

----data type
SELECT
COLUMN_NAME,
DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='NetflixDB';

----Netflix Contains Netflix movies and TV shows including title, director, cast,
----country, release year, rating and genre.

----TASK 2: DATA CLEANING
----missing value
SELECT
SUM(CASE WHEN Director IS NULL THEN 1 ELSE 0 END) AS MissingDirector,
SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS MissingCountry,
SUM(CASE WHEN CAST IS NULL THEN 1 ELSE 0 END) AS MissingCast
FROM NetflixDB;

---replace missing value
UPDATE NetflixDB
SET Director='Unknown'
WHERE Director IS NULL;

UPDATE NetflixDB
SET Country='Unknown'
WHERE Country IS NULL;

UPDATE NetflixDB
SET CAST ='Unknown'
WHERE CAST IS NULL;

-----C. Standardization
---column name
EXEC sp_rename
'dbo.NetflixDB.date_added',
'DateAdded',
'COLUMN';

---trim spaces
UPDATE NetflixDB
SET Country = LTRIM(RTRIM(Country));

---date format
ALTER TABLE NetflixDB
ALTER COLUMN DateAdded DATE;

----netflix release year
SELECT *
FROM NetflixDB
WHERE Release_year > YEAR(GETDATE());

----TASK 3: EDA
----movies vs tvshow
SELECT
TYPE,
COUNT(*) Total
FROM NetflixDB
GROUP BY TYPE;
---content added by year
SELECT
YEAR(date_added) AS YearAdded,
COUNT(*) Total
FROM NetflixDB
GROUP BY YEAR(date_added)
ORDER BY YearAdded;


----top Content producing country
SELECT TOP 10
Country,
COUNT(*) TotalContent
FROM NetflixDB
GROUP BY Country
ORDER BY TotalContent DESC;

----most common rating
SELECT
Rating,
COUNT(*) Total
FROM NetflixDB
GROUP BY Rating
ORDER BY Total DESC;

---most common genres/categories
SELECT TOP 10
Listed_in,
COUNT(*) Total
FROM NetflixDB
GROUP BY Listed_in
ORDER BY Total DESC;

---SUMMARY STATISTICS
SELECT
AVG(Release_year) AvgYear,
MIN(Release_year) MinYear,
MAX(Release_year) MaxYear,
STDEV(Release_year) StdYear
FROM NetflixDB;

SELECT *
FROM NetflixDB;
Select*
FROM NetflixDB
ORDER BY Show_ID;

SELECT *
FROM NetflixDB;
