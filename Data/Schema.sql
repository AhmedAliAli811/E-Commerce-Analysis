USE [Ecommerce]
GO
/****** Object:  Table [dbo].[Dim_Brands]    Script Date: 10/29/2024 5:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Brands](
	[BrandID] [int] NOT NULL,
	[Brand] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
 CONSTRAINT [PK_Dim_Brands] PRIMARY KEY CLUSTERED 
(
	[BrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_Products]    Script Date: 10/29/2024 5:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Products](
	[ProductID] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[BrandID] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
	[Size] [nvarchar](50) NULL,
	[Classification] [nvarchar](50) NOT NULL,
	[UnitPrice] [float] NOT NULL,
	[SalesPrice] [float] NULL,
 CONSTRAINT [PK_Dim_Products] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_Stores]    Script Date: 10/29/2024 5:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Stores](
	[ID] [int] NOT NULL,
	[Store] [int] NOT NULL,
	[City] [nvarchar](50) NULL,
 CONSTRAINT [PK_Dim_Stores] PRIMARY KEY CLUSTERED 
(
	[Store] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_Suppliers]    Script Date: 10/29/2024 5:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Suppliers](
	[ID] [int] NOT NULL,
	[VendorNumber] [int] NOT NULL,
	[VendorName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Dim_Suppliers] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_Time]    Script Date: 10/29/2024 5:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Time](
	[ID] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[DayOfWeek] [nvarchar](50) NOT NULL,
	[Month] [int] NOT NULL,
	[Quarter] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[IsWeekend] [bit] NOT NULL,
 CONSTRAINT [PK_Dim_Time] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fact_Inverntory]    Script Date: 10/29/2024 5:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fact_Inverntory](
	[InventoryID] [int] NOT NULL,
	[ReceivingDate_ID] [int] NOT NULL,
	[StoreID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[PONumber] [int] NOT NULL,
	[Cost] [float] NOT NULL,
	[InventoryName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Fact_Inverntory] PRIMARY KEY CLUSTERED 
(
	[InventoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fact_Order_items]    Script Date: 10/29/2024 5:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fact_Order_items](
	[ItemsID] [int] NOT NULL,
	[OrderID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
	[StoreID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [float] NOT NULL,
	[TotalCost] [float] NOT NULL,
 CONSTRAINT [PK_Fact_Order_items] PRIMARY KEY CLUSTERED 
(
	[ItemsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fact_Orders]    Script Date: 10/29/2024 5:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fact_Orders](
	[OrderID] [int] NOT NULL,
	[PODate_ID] [int] NOT NULL,
	[InvoiceDate_ID] [int] NOT NULL,
	[PayDate_ID] [int] NOT NULL,
	[PONumber] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Total] [float] NOT NULL,
	[Freight] [float] NOT NULL,
 CONSTRAINT [PK_Fact_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fact_Sales]    Script Date: 10/29/2024 5:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fact_Sales](
	[SalesID] [int] NOT NULL,
	[SalesDate_ID] [int] NOT NULL,
	[StoreID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[InventoryID] [int] NOT NULL,
	[SalesQuantity] [int] NOT NULL,
	[TotalSalesAmount] [float] NOT NULL,
	[Tax] [float] NOT NULL,
 CONSTRAINT [PK_Fact_Sales] PRIMARY KEY CLUSTERED 
(
	[SalesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dim_Products]  WITH CHECK ADD  CONSTRAINT [FK_Dim_Products_Dim_Brands] FOREIGN KEY([BrandID])
REFERENCES [dbo].[Dim_Brands] ([BrandID])
GO
ALTER TABLE [dbo].[Dim_Products] CHECK CONSTRAINT [FK_Dim_Products_Dim_Brands]
GO
ALTER TABLE [dbo].[Dim_Products]  WITH CHECK ADD  CONSTRAINT [FK_Dim_Products_Dim_Suppliers] FOREIGN KEY([SupplierID])
REFERENCES [dbo].[Dim_Suppliers] ([ID])
GO
ALTER TABLE [dbo].[Dim_Products] CHECK CONSTRAINT [FK_Dim_Products_Dim_Suppliers]
GO
ALTER TABLE [dbo].[Fact_Order_items]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Order_items_Dim_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Dim_Products] ([ProductID])
GO
ALTER TABLE [dbo].[Fact_Order_items] CHECK CONSTRAINT [FK_Fact_Order_items_Dim_Products]
GO
ALTER TABLE [dbo].[Fact_Order_items]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Order_items_Dim_Suppliers] FOREIGN KEY([SupplierID])
REFERENCES [dbo].[Dim_Suppliers] ([ID])
GO
ALTER TABLE [dbo].[Fact_Order_items] CHECK CONSTRAINT [FK_Fact_Order_items_Dim_Suppliers]
GO
ALTER TABLE [dbo].[Fact_Order_items]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Order_items_Fact_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Fact_Orders] ([OrderID])
GO
ALTER TABLE [dbo].[Fact_Order_items] CHECK CONSTRAINT [FK_Fact_Order_items_Fact_Orders]
GO
ALTER TABLE [dbo].[Fact_Orders]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Orders_Dim_Suppliers] FOREIGN KEY([SupplierID])
REFERENCES [dbo].[Dim_Suppliers] ([ID])
GO
ALTER TABLE [dbo].[Fact_Orders] CHECK CONSTRAINT [FK_Fact_Orders_Dim_Suppliers]
GO
ALTER TABLE [dbo].[Fact_Orders]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Orders_Dim_Time] FOREIGN KEY([PODate_ID])
REFERENCES [dbo].[Dim_Time] ([ID])
GO
ALTER TABLE [dbo].[Fact_Orders] CHECK CONSTRAINT [FK_Fact_Orders_Dim_Time]
GO
ALTER TABLE [dbo].[Fact_Orders]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Orders_Dim_Time1] FOREIGN KEY([InvoiceDate_ID])
REFERENCES [dbo].[Dim_Time] ([ID])
GO
ALTER TABLE [dbo].[Fact_Orders] CHECK CONSTRAINT [FK_Fact_Orders_Dim_Time1]
GO
ALTER TABLE [dbo].[Fact_Orders]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Orders_Dim_Time2] FOREIGN KEY([PayDate_ID])
REFERENCES [dbo].[Dim_Time] ([ID])
GO
ALTER TABLE [dbo].[Fact_Orders] CHECK CONSTRAINT [FK_Fact_Orders_Dim_Time2]
GO
ALTER TABLE [dbo].[Fact_Sales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Sales_Dim_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Dim_Products] ([ProductID])
GO
ALTER TABLE [dbo].[Fact_Sales] CHECK CONSTRAINT [FK_Fact_Sales_Dim_Products]
GO
ALTER TABLE [dbo].[Fact_Sales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Sales_Dim_Time] FOREIGN KEY([SalesDate_ID])
REFERENCES [dbo].[Dim_Time] ([ID])
GO
ALTER TABLE [dbo].[Fact_Sales] CHECK CONSTRAINT [FK_Fact_Sales_Dim_Time]
GO
ALTER TABLE [dbo].[Fact_Sales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Sales_Fact_Inverntory] FOREIGN KEY([InventoryID])
REFERENCES [dbo].[Fact_Inverntory] ([InventoryID])
GO
ALTER TABLE [dbo].[Fact_Sales] CHECK CONSTRAINT [FK_Fact_Sales_Fact_Inverntory]
GO
