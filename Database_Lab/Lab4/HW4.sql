--1
SELECT Sales.SalesOrderHeader.OrderDate, Sales.SalesOrderDetail.LineTotal,
AVG(Sales.SalesOrderDetail.LineTotal)OVER (PARTITION BY Sales.SalesOrderHeader.CustomerID
ORDER BY Sales.SalesOrderHeader.OrderDate,Sales.SalesOrderHeader.SalesOrderID
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as vag
FROM Sales.SalesOrderHeader JOIN Sales.SalesOrderDetail ON
(SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID)

--2
select case 
GROUPING(Sales.SalesTerritory.Name)
when 0 then Sales.SalesTerritory.Name
when 1 then 'All Classes'
end AS TerritoryName,
case GROUPING(Sales.SalesTerritory.[Group])
when 0 then Sales.SalesTerritory.[Group]
when 1 then 'All Classes'
end AS Region,
sum(sales.SalesOrderHeader.SubTotal) as SalesTotal,
count(*) as SalesCount
from Sales.SalesTerritory inner join Sales.SalesOrderHeader on
Sales.SalesTerritory.TerritoryID=Sales.SalesOrderHeader.TerritoryID
group by Rollup(Sales.SalesTerritory.[Group],Sales.SalesTerritory.Name)
order by TerritoryName, Region

--3
select case 
GROUPING(Production.ProductSubcategory.name)
when 0 then Production.ProductSubcategory.name
when 1 then 'All Classes'
end AS SubCategotye,
case GROUPING(Production.ProductCategory.name)
when 0 then Production.ProductCategory.name
when 1 then 'All Classes'
end As Category,
COUNT(*) As count,
SUM(sales.SalesOrderDetail.LineTotal) As sum
from Sales.SalesOrderDetail inner join Production.product 
on (Product.ProductID=Sales.SalesOrderDetail.ProductID)
inner join Production.ProductSubcategory
on(ProductSubcategory.ProductSubcategoryID = Product.ProductSubcategoryID)inner join production.ProductCategory 
on (Production.ProductCategory.ProductCategoryID=Production.ProductSubcategory.ProductCategoryID)
group by Rollup(Production.ProductCategory.name,Production.ProductSubcategory.name)

--4
with temp (firstname,lastname,id,marital,job ,numOfEmployees) as (
select Person.FirstName, Person.LastName, Employee.NationalIDnumber,
case when 
Employee.MaritalStatus='M' then 'Married' 
else 'single'
end as maritalstatus,
Employee.JobTitle,
count(*) over (partition by Employee.JobTitle) as numOfEmployees
from HumanResources.Employee inner join Person.Person on 
HumanResources.Employee.BusinessEntityID=Person.BusinessEntityID
)
select * from temp
where  numOfEmployees>3



