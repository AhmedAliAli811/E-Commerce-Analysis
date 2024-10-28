-- Data Cleaning --
/* 
	Update all orders that contains Alchloic products
*/
WITH AlcoholicOrderItems AS (
    SELECT 
        OrderID,
        SUM(Quantity * DP.PurchasePrice) AS AlcoholicTotalCost
    FROM 
        Fact_Order_Items FOI
    JOIN 
        Dim_Products DP ON FOI.ProductID = DP.ProductID
    WHERE 
        DP.Classification = 'Alchloic'
    GROUP BY 
        FOI.OrderID
	ORDER BY 
		AlcoholicTotalCost
)
UPDATE Fact_Orders
SET Total = Total - COALESCE(AO.AlcoholicTotalCost, 0)
FROM Fact_Orders FO
LEFT JOIN AlcoholicOrderItems AO ON FO.OrderID = AO.OrderID
WHERE AO.AlcoholicTotalCost IS NOT NULL

/* 
	Remove from Fact_Sales Table
*/

DELETE FROM Fact_Sales
WHERE ProductID IN (
    SELECT ProductID 
    FROM Dim_Products 
    WHERE Classification = 'Alchloic'
)
/* 
	Remove from Fact_Order_Items Table
*/
DELETE FROM Fact_Order_Items
WHERE ProductID IN (
    SELECT ProductID 
    FROM Dim_Products 
    WHERE Classification = 'Alchloic'
)
/* 
	Remove from Fact_Inverntory Table
*/
DELETE FROM Fact_Inverntory
WHERE ProductID IN (
    SELECT ProductID 
    FROM Dim_Products 
    WHERE Classification = 'Alchloic'
);
/* 
	Remove from Dim_Products Table
*/
DELETE FROM Dim_Products
WHERE Classification = 'Alchloic';


