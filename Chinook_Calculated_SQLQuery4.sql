
 SELECT *
  FROM Track;

  UPDATE Track
  SET Composer = 'Unknown'
  WHERE  Composer IS NULL;

   SELECT *
  FROM Track;

  UPDATE Customer
  SET Company  = 'Unknown'
  WHERE Company  IS NULL;

  UPDATE Customer
  SET State  = 'Unknown'
  WHERE State  IS NULL;

  UPDATE Customer
  SET Fax  = 'Unknown'
  WHERE Fax  IS NULL;

  UPDATE Customer
  SET Phone  = 'Unknown'
  WHERE Phone  IS NULL;

  UPDATE Customer
  SET PostalCode  = 'Unknown'
  WHERE PostalCode  IS NULL;

   SELECT *
  FROM Customer;

 UPDATE Invoice
  SET BillingState  = 'Unknown'
  WHERE BillingState IS NULL;

 
 SELECT *
  FROM InvoiceLine;

---- Total Revenue

SELECT SUM (Total) AS TotalRevenue
FROM Invoice;

---- Total Customers

SELECT COUNT(CustomerID) AS TotalCustomers
FROM Customer;

---- Average Order Value(per invoice)

SELECT AVG(Total)  AS AvgOrderValue
FROM Invoice;

ALTER TABLE Invoice
ALTER COLUMN Invoicedate
DATE;

---- TRACK WITH THE MOST REVENUE

SELECT T.Name AS Track, SUM(IL.UnitPrice * IL.Quantity) AS Revenue
FROM InvoiceLine AS IL
INNER JOIN Track AS T
ON IL.TrackId = T.TrackId
GROUP BY T. Name
ORDER BY Revenue DESC;

---- Top Popular Genre by Revenue

SELECT g.Name AS Genre, SUM(il.UnitPrice * il.Quantity) AS Revenue
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY Revenue DESC;

---- Top artist by unit sold 

SELECT ar.Name AS Artist, SUM(il.Quantity) AS UnitsSold
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name
ORDER BY UnitsSold DESC;

---- Revenue by country 

SELECT c.Country, SUM(i.Total) AS Revenue, COUNT(DISTINCT c.CustomerId) AS Customers
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.Country
ORDER BY Revenue DESC;

---- CUSTOMERS WITH THE MOST PURCHASES

SELECT C.FirstName, C. LastName, COUNT(I. InvoiceId) AS Number_Of_Purchas FROM Customer AS C INNER JOIN Invoice AS I
ON C. CustomerId = I. CustomerId
GROUP BY C. FirstName, C. LastName
ORDER BY Number_Of_Purchas DESC;

----  Top Customer by Revenue
SELECT
c.FIRSTNAME,
c.LASTNAME,
SUM(I.TOTAL) AS Total_Revenue
FROM Customer C
JOIN Invoice i
ON C.CustomerId = i.CustomerId
GROUP BY c.CustomerId, C.FirstName,  C.LastName
ORDER BY Total_Revenue DESC;

---- PLAYLISTS WITH THE MOST TRACKS

SELECT P.Name AS Playlist, COUNT(PT.TrackId) AS Total_Tracks
FROM Playlist AS P
INNER JOIN PlaylistTrack AS PT
ON P.PlaylistId = PT.PlaylistId
GROUP BY P.Name
ORDER BY Total_Tracks DESC;


---- MOST USED MEDIA TYPE

SELECT MT.Name AS MediaType, COUNT(T.TrackId) AS Total_Tracks
FROM MediaType AS MT
INNER JOIN Track AS T
ON MT.MediaTypeId = T.MediaTypeId
GROUP BY MT.Name
ORDER BY Total_Tracks DESC;
