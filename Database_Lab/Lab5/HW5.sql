--1
select name,[Europe],[North America],[Pacific]
from(
select Production.Product.Name,Sales.SalesTerritory.[Group],Sales.SalesOrderDetail.OrderQty from
Production.Product inner join Sales.SalesOrderDetail 
on(Production.Product.ProductID = sales.SalesOrderDetail.ProductID)
inner join Sales.SalesOrderHeader 
on(sales.SalesOrderHeader.SalesOrderID = sales.SalesOrderDetail.SalesOrderID)
inner join Sales.SalesTerritory 
on(sales.SalesTerritory.TerritoryID=sales.SalesOrderHeader.TerritoryID)
)as newTabel
PIVOT(
count(orderQty)
for [Group] in ([Europe],[North America],[Pacific]))as PVT

  
--2
select PersonType,[M],[F]
from(select Person.BusinessEntityID, PersonType, Gender
from Person.Person join HumanResources.Employee on
(Person.BusinessEntityID = Employee.BusinessEntityID) 
)as newTabel_2
pivot
(
count(BusinessEntityID)
for Gender in (F,M)
)as pvt

--3
select Production.Product.Name from
Production.Product
where len(Name)<15 and
Name like '%e_'

--4
--drop function q4
CREATE FUNCTION q4(@mydate nvarchar(10))
RETURNS nvarchar(200)
begin
if (@mydate not like '____/__/__') return 'فرمت تاریخ ناصحیح است'
declare @month nvarchar(2);
declare @day nvarchar(2);
declare @year nvarchar(4);
declare @persianMonth nvarchar (15);
set @day = SUBSTRING(@mydate,9,10);
set @year = SUBSTRING(@mydate,1,4);
set @month=SUBSTRING(@mydate,6,7);
select @persianMonth =  case @month
	when '01' then N'فروردین'
	when '02' then N'اردیبهشت'
	when '03' then N'خرداد'
	when '04' then N'تیر'
	when '05' then N'مرداد'
	when '06' then N'شهریور'
	when '07' then N'مهر'
	when '08' then N'آبان'
	when '09' then N'آذر'
	when '10' then N'دی'
	when '11' then N'بهمن'
	when '12' then N'اسفند'
end
declare @result nvarchar(40);
set @result = @day+@persianMonth+N'ماه'+@year+ N'شمسی';
return @result
end 
go
select dbo.q4('1379/12/10')

--5
--drop function Sales.T
CREATE FUNCTION Sales.T (@year int,@month int,@pname varchar(200))
RETURNS TABLE
AS
RETURN
(
select distinct(Sales.SalesTerritory.[Group]) from
Production.Product inner join Sales.SalesOrderDetail 
on(Production.Product.ProductID = sales.SalesOrderDetail.ProductID)
inner join Sales.SalesOrderHeader 
on(sales.SalesOrderHeader.SalesOrderID = sales.SalesOrderDetail.SalesOrderID)
inner join Sales.SalesTerritory 
on(sales.SalesTerritory.TerritoryID=sales.SalesOrderHeader.TerritoryID)
where year(Sales.SalesOrderHeader.OrderDate)=@year and MONTH(Sales.SalesOrderHeader.OrderDate)=@month and Production.Product.Name=@pname
);
GO
select * from Sales.T (2005, 8, N'Sport-100 Helmet, Red')

