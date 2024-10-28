use Cafe;
go


select *
from Fact_Orders FO join Fact_Order_items FOI 
on Fo.OrderID = FOI.OrderID join Dim_Products DP 
on FOI.ProductID = DP.ProductID
where FO.OrderID = 1

select * from Dim_Products
order by Description

select *
from Fact_Sales FS join Dim_Products DP 
on FS.ProductID = DP.ProductID

select * , cost / Quantity
from Fact_Inverntory
order by InventoryID

select DT1.Date as Order_date 
, DT2.Date as Invoice_date 
, DT3.Date as Pay_date 
from Fact_Orders FO
join Dim_Time DT1 on DT1.ID = FO.PODate_ID
join Dim_Time DT2 on DT2.ID = FO.InvoiceDate_ID
join Dim_Time DT3 on DT3.ID = FO.PayDate_ID
order by Order_date , Invoice_date , Pay_date



select *  , Total / Quantity + Freight / Quantity
from Fact_Orders

select *
from Fact_Order_items
where OrderID = 1

select * from Dim_Products where ProductID = 2927

select FO.OrderID , FO.Total , FO.Freight ,FOI.ProductID , FOI.UnitPrice , DP.UnitPrice , DP.SalesPrice ,  FOI.UnitPrice + (FO.Freight / FO.Quantity) , DP.SalesPrice  - (FOI.UnitPrice + (FO.Freight / FO.Quantity))
from Fact_Orders FO 
join Fact_Order_items FOI on FO.OrderID = FOI.OrderID
join Dim_Products DP on FOI.ProductID = DP.ProductID
where FO.OrderID = 2

