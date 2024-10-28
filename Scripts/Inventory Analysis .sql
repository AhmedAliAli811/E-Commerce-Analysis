use cafe
GO

-- Inventory Analysis -- 

-- ABC Analysis -- 
with AvgAnnualDemand_CostPerUnit as (
		select FS.ProductID 
			, AVG(Sum(FS.SalesQuantity)) over (partition by FS.ProductID) as [Average Annual Demand]
			, avg(DP.UnitPrice) as [Cost Per Unit]
		from Fact_Sales FS 
			join Dim_Products DP on Fs.ProductID = DP.ProductID
			join Dim_Time DT on DT.ID = FS.SalesDate_ID 
		group by FS.ProductID , DT.Year
	),
	ProductCostRank as (
		select ProductID
			,[Average Annual Demand]
			,[Cost Per Unit]
			,[Average Annual Demand] * [Cost Per Unit] as [Annual Cost]
		from 
			AvgAnnualDemand_CostPerUnit
	),
	CumulativeCost as (
		select ProductID
			,[Average Annual Demand]
			,[Cost Per Unit]
			,[Annual Cost]
			,SUM([Annual Cost]) over () as TotalSumCost
			,RANK() over (order by  [Annual Cost] DESC) as ProductRank
			,SUM([Annual Cost]) over (order by   [Annual Cost] desc) / SUM([Annual Cost]) over () * 100 as CumulativePercentage
		from 
			ProductCostRank
	)
	select 
		CC.ProductID
		, DP.Description
		, CC.[Average Annual Demand]
		, CC.[Cost Per Unit]
		, case 
			when CC.CumulativePercentage <= 70 then 'A'
			when CC.CumulativePercentage <= 90 then 'B'
			else 'C'
		end as ABC_Category
	from CumulativeCost CC 
	join Dim_Products DP on CC.ProductID = DP.ProductID

-- VED Analysis -- 
with ProductSales as (
	select FS.ProductID 
		, DP.Description as ProductName
		, min(DP.Size) as Size
		, Sum(FS.SalesQuantity) as TotalSalesQuantity
	from Fact_Sales FS 
		join Dim_Products DP on Fs.ProductID = DP.ProductID
	group by FS.ProductID , DP.Description
), ProductClassification as (
	select ProductID
		, ProductName
		, TotalSalesQuantity
		, case 
			when TotalSalesQuantity >= (select top 1 PERCENTILE_CONT(0.7) within group (order by TotalSalesQuantity ) over() from ProductSales) then 'Vital'
			when TotalSalesQuantity >= (select top 1 PERCENTILE_CONT(0.3) within group (order by TotalSalesQuantity ) over() from ProductSales) then 'Essential'
			else 'Desirable'
		  end as VED_Category   
	from ProductSales PS 
)
select * 
from ProductClassification
order by TotalSalesQuantity desc

-- HML Analysis --
with ProductCost as (
	select ProductID
		, Description as ProductName
		, Size 
		, Avg(UnitPrice) as AvgUnitPrice
	from Dim_Products 
	group by ProductID
		, Description
		, Size
), ProductClassification as (
	select ProductID
		, ProductName
		, Size
		, AvgUnitPrice
		, case 
			when AvgUnitPrice >= (select top 1 PERCENTILE_CONT(0.7) within group (order by AvgUnitPrice ) over() from ProductCost) then 'High'
			when AvgUnitPrice >= (select top 1 PERCENTILE_CONT(0.3) within group (order by AvgUnitPrice ) over() from ProductCost) then 'Medium'
			else 'Low'
		  end as HML_Category   
	from ProductCost 
)select * 
from ProductClassification
order by AvgUnitPrice desc



-- EOQ Analysis --
with AvgAnnualDemand as (
	select FS.ProductID 
		, AVG(Sum(FS.SalesQuantity)) over (partition by FS.ProductID) as [Average Annual Demand]
	from Dim_Products DP 
		left join Fact_Sales FS on Fs.ProductID = DP.ProductID
		join Dim_Time DT on DT.ID = FS.SalesDate_ID 
	group by FS.ProductID , DT.Year
),OrderingCostPerUnit as (
	select DP.ProductID  , avg(FO.Freight / FO.Quantity ) as S
	from Dim_Products DP 
		left join Fact_Order_items FOI on DP.ProductID = FOI.ProductID
		join Fact_Orders FO on FOI.OrderID = FO.OrderID
	group by DP.ProductID 
), EconomicOrderQuantity as (
	select DP.ProductID , DP.Description , ceiling(  SQRT((2.0* ADemand.[Average Annual Demand] * OCPU.S) / 1.0)) as EOQ
	from Dim_Products DP 
	left join OrderingCostPerUnit OCPU on DP.ProductID = OCPU.ProductID
	left join AvgAnnualDemand ADemand on DP.ProductID = ADemand.ProductID
)select * from EconomicOrderQuantity order by EOQ desc




-- Reorder Point --
with AvgMonthlySales as (
    select distinct
        FS.ProductID,
        FS.StoreID,
        AVG(SUM(FS.SalesQuantity)) over (partition by FS.ProductID, FS.StoreID) as AvgMonthlySales
    from Fact_Sales FS
    join Dim_Time DT on FS.SalesDate_ID = DT.ID
    group by FS.ProductID, FS.StoreID, DT.Year, DT.Month
), 
LeadTime as (
    select 
        FOI.ProductID,
        AVG(DATEDIFF(day, DTVOI.Date, DTPAY.Date)) as AvgLeadTimeDays
    from Fact_Orders FO 
    join Fact_Order_items FOI on FO.OrderID = FOI.OrderID 
    join Dim_Time DTVOI on FO.InvoiceDate_ID = DTVOI.ID
    join Dim_Time DTPAY on FO.PayDate_ID = DTPAY.ID
    group by FOI.ProductID
), 
ReorderPoint as (
    select
        AMS.ProductID,
        AMS.StoreID,
        AMS.AvgMonthlySales / 30 as AvgDailySales,  
        LT.AvgLeadTimeDays,
        (AMS.AvgMonthlySales / 30) * LT.AvgLeadTimeDays as ReorderPoint
    from AvgMonthlySales AMS
    join LeadTime LT on AMS.ProductID = LT.ProductID
)
select 
    FI.ProductID,
    FI.StoreID,
    max(FI.Quantity) as CurrentStock,
    max(RP.ReorderPoint) as ReorderPoint,
    case 
        when max(FI.Quantity) <= max(RP.ReorderPoint) then 'Reorder Required'
        else 'Sufficient Stock'
    end as ReorderStatus
from Fact_Inverntory FI
join ReorderPoint RP on FI.ProductID = RP.ProductID and FI.StoreID = RP.StoreID
group by FI.ProductID, FI.StoreID
order by FI.ProductID, FI.StoreID, ReorderStatus;

-- inventory turnOver-- 
WITH InventorySummary AS (
    SELECT 
        ProductID,
        AVG(Quantity) AS AvgInventory
    FROM 
        Fact_Inverntory
    GROUP BY 
        ProductID
),
SalesSummary AS (
    SELECT 
        ProductID,
        SUM(TotalSalesAmount + Tax * TotalSalesAmount) AS TotalCOGS
    FROM 
        Fact_Sales
    GROUP BY 
        ProductID
)
SELECT 
    SS.ProductID,
    SS.TotalCOGS,
    ISs.AvgInventory,
    SS.TotalCOGS / NULLIF(ISs.AvgInventory, 0) AS InventoryTurnoverRate
FROM SalesSummary SS JOIN InventorySummary ISs ON SS.ProductID = ISs.ProductID
order by InventoryTurnoverRate desc

