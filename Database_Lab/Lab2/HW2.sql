--1
select Sales.SalesOrderHeader.* from Sales.SalesOrderHeader inner join Sales.SalesTerritory on (Sales.SalesOrderHeader.TerritoryID= Sales.SalesTerritory.TerritoryID) 
where Sales.SalesOrderHeader.TotalDue>=100000
and Sales.SalesOrderHeader.TotalDue<=500000 
and (Sales.SalesTerritory.Name='France' or Sales.SalesTerritory.[Group]='North America')

--2
select SalesOrderID, CustomerID,subTotal,OrderDate, Name
from Sales.SalesOrderHeader inner join Sales.SalesTerritory on (Sales.SalesOrderHeader.TerritoryID= Sales.SalesTerritory.TerritoryID)

--3
select S.* into NAmerica_Sales from Sales.SalesOrderHeader as S inner join Sales.SalesTerritory as T on S.TerritoryID =T.TerritoryID  
where S.TotalDue>=100000
and S.TotalDue<=500000 
and T.[Group]='North America'

ALTER table NAmerica_Sales
	ADD cost char(4) check (cost in ('Low' , 'Mid' , 'High'))


update NAmerica_Sales set cost = case 
	when TotalDue> (select AVG(NAmerica_Sales.TotalDue) from NAmerica_Sales) then 'High'
	when TotalDue< (select AVG(NAmerica_Sales.TotalDue) from NAmerica_Sales) then 'Low'
	when TotalDue = (select AVG(NAmerica_Sales.TotalDue) from NAmerica_Sales) then 'Mid'
	end
	
select * from NAmerica_Sales

--4
select BusinessEntityID,
	case 
		when max(Rate) <= ( select max(Rate) from HumanResources.EmployeePayHistory)/4 then max(Rate)*1.20
		when max(Rate) <= ( select max(Rate) from HumanResources.EmployeePayHistory)/2 and max(Rate)> ( select max(Rate) from HumanResources.EmployeePayHistory)/4 then max(Rate)*1.15
		when max(Rate) <= ( select max(Rate) from HumanResources.EmployeePayHistory)*3/4 and max(Rate) > ( select max(Rate) from HumanResources.EmployeePayHistory)/2  then max(Rate)*1.10
		else max(rate) *1.05
	end as NewSalare,
	case 
		when max(Rate) <=29 then 3
		when max(Rate)>29 and max(Rate)<=50 then 2
		else 1
	end as LEVEL
from HumanResources.EmployeePayHistory
GROUP BY BusinessEntityID