--1

CREATE TABLE [Production].[Productlogs](
	[ProductID] [int] ,
	[Name] [dbo].[Name] ,
	[ProductNumber] [nvarchar](25) ,
	[MakeFlag] [dbo].[Flag],
	[FinishedGoodsFlag] [dbo].[Flag] ,
	[Color] [nvarchar](15) ,
	[SafetyStockLevel] [smallint],
	[ReorderPoint] [smallint] ,
	[StandardCost] [money] ,
	[ListPrice] [money] ,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Weight] [decimal](8, 2) NULL,
	[DaysToManufacture] [int] ,
	[ProductLine] [nchar](2) NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [datetime] ,
	[SellEndDate] [datetime] NULL,
	[DiscontinuedDate] [datetime] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  ,
	[ModifiedDate] [datetime] ,
	[changeType] nvarchar(255),

)
--delete
create trigger my_logdelete on Production.Product
instead of delete
as
begin
insert into Productlogs
select *,'deleted'
from deleted
end


--insert
create trigger my_loginsert on Production.Product
instead of insert
as
begin
insert into Productlogs
select *,'inserted'
from inserted
end

--update
create trigger my_logupdate on Production.Product
instead of update
as
begin
insert into Productlogs
select *,'updated'
from inserted
end
 SET IDENTITY_INSERT Production.Product  ON
insert into Production.Product
(ProductId,Name,ProductNumber,MakeFlag,FinishedGoodsFlag,SafetyStockLevel,ReorderPoint,
StandardCost,ListPrice,DaysToManufacture,SellStartDate,rowguid,ModifiedDate)
Values(1001,N'Citybike3',N'CB-5384',0,0,1000,750,0.0000,0.0000,0,GETDATE(),NEWID(),GETDATE())

update Production.Product
set Name='ehsan'
where productID = 316;
-- delete from Production.Productlogs
select * from Production.Productlogs

--2
CREATE TABLE [Production].[Productlog2](
	[ProductID] [int] ,
	[Name] [dbo].[Name] ,
	[ProductNumber] [nvarchar](25) ,
	[MakeFlag] [dbo].[Flag],
	[FinishedGoodsFlag] [dbo].[Flag] ,
	[Color] [nvarchar](15) ,
	[SafetyStockLevel] [smallint],
	[ReorderPoint] [smallint] ,
	[StandardCost] [money] ,
	[ListPrice] [money] ,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Weight] [decimal](8, 2) NULL,
	[DaysToManufacture] [int] ,
	[ProductLine] [nchar](2) NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [datetime] ,
	[SellEndDate] [datetime] NULL,
	[DiscontinuedDate] [datetime] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  ,
	[ModifiedDate] [datetime] ,
	[changeType] nvarchar(255),

)

insert into Production.Productlog2 select * from Production.Productlogs;
delete from Production.Productlog2
select * from Production.Productlog2

update Production.Productlog2 
set Name ='hoori'

select * from Production.Productlog2;


--3
CREATE TABLE [Production].[Productlog4](
	[ProductID] [int] ,
	[Name] [dbo].[Name] ,
	[ProductNumber] [nvarchar](25) ,
	[MakeFlag] [dbo].[Flag],
	[FinishedGoodsFlag] [dbo].[Flag] ,
	[Color] [nvarchar](15) ,
	[SafetyStockLevel] [smallint],
	[ReorderPoint] [smallint] ,
	[StandardCost] [money] ,
	[ListPrice] [money] ,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Weight] [decimal](8, 2) NULL,
	[DaysToManufacture] [int] ,
	[ProductLine] [nchar](2) NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [datetime] ,
	[SellEndDate] [datetime] NULL,
	[DiscontinuedDate] [datetime] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  ,
	[ModifiedDate] [datetime] ,
	[changeType] nvarchar(255),

)

alter procedure diff1_2
as 
begin
	insert into Production.Productlog4 select * from(
	select * from Production.Productlogs
	except
	select * from Production.Productlog2
	) as t
end
execute diff1_2;
select * from Production.Productlog4

