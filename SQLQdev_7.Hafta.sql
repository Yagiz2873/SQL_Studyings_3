--ÖDEV-1
SELECT AVG(T1.Gecikme_Süresi) Gecikme FROM
(SELECT OrderID, RequiredDate, ShippedDate, DATEDIFF(day,RequiredDate,ShippedDate) Gecikme_Süresi FROM Orders
WHERE DATEDIFF(day,RequiredDate,ShippedDate) > 0
) T1

--ÖDEV-2
SELECT AVG(T1.Erken_Gelme_Süresi) Erken_Gelme FROM
(SELECT OrderID, RequiredDate, ShippedDate, DATEDIFF(day,ShippedDate,RequiredDate) Erken_Gelme_Süresi FROM Orders
WHERE DATEDIFF(day,ShippedDate,RequiredDate) > 0 
) T1

--ÖDEV-3
SELECT Customer_ID , SUM(T1.Monetary) FROM
(SELECT * , (Quantity*Price) AS Monetary FROM dbo.retail_2010_2011) T1
GROUP BY Customer_ID
ORDER BY Customer_ID

--ÖDEV-4
SELECT *, DATEDIFF(DAY,Last_Shopping_Date,'2011-12-30 00:00:00.000') Recency FROM
(SELECT Customer_ID,MAX(InvoiceDate) AS Last_Shopping_Date FROM dbo.retail_2010_2011
GROUP BY Customer_ID) T1
ORDER BY T1.Last_Shopping_Date DESC 

--ÖDEV-5
SELECT
    Country,
    [Description],
    TotalQuantity,
    TotalRevenue
FROM
(
    SELECT
       Country,
       [Description],
        SUM(Quantity) as TotalQuantity,
        SUM(Quantity * Price) as TotalRevenue,
        ROW_NUMBER() OVER (PARTITION BY Country ORDER BY SUM(Quantity) DESC) as RowNum
    FROM [retail_2010_2011] R
    GROUP BY Country, [Description]
) Ranked
WHERE Ranked.RowNum = 1
ORDER BY 3 DESC