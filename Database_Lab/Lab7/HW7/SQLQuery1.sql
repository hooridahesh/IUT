sp_configure 'show advanced options', 1;
RECONFIGURE;
Go
sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO
exec sp_configure 'Advanced', 1 RECONFIGURE
exec sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',N'AllowInProcess', 1
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',N'DynamicParameters', 1
GO

-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO

--1
EXEC xp_cmdshell 'bcp AdventureWorks2012.Sales.SalesTerritory out C:\Users\hoori\Desktop\7\SalesTerritoryOutput.txt -T -c -t"|"'

CREATE TABLE [Sales].[SalesTerritoryNew](
	[TerritoryID] [int] NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[CountryRegionCode] [nvarchar](3) NOT NULL,
	[Group] [nvarchar](50) NOT NULL,
	[SalesYTD] [money] NOT NULL,
	[SalesLastYear] [money] NOT NULL,
	[CostYTD] [money] NOT NULL,
	[CostLastYear] [money] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	);
	
bulk insert AdventureWorks2012.sales.salesTerritoryNew
from 'C:\Users\hoori\Desktop\7\SalesTerritoryOutput.txt'
with(
fieldterminator='|'
)


--2
EXEC xp_cmdshell 'bcp "select TerritoryID, Name from AdventureWorks2012.Sales.SalesTerritory" queryout "C:\Users\hoori\Desktop\7\Output2.txt" -T -c -t "|"'


--3
EXEC xp_cmdshell 'bcp AdventureWorks2012.Production.Location out C:\Users\hoori\Desktop\7\location.dat -T -c -t "|"'


--4
select name,Demographics.query(
'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
 for $p in /StoreSurvey
 return <AnnualSales>
 {$p/AnnualSales}
 </AnnualSales>'
)as AnnualSales,Demographics.query(
'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
 for $p in /StoreSurvey
 return <NumberEmployees>
 {$p/NumberEmployees}
 </NumberEmployees>'
)as NumberEmployees,Demographics.query(
'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
 for $p in /StoreSurvey
 return <YearOpened>
 {$p/YearOpened}
 </YearOpened>'
)as YearOpened
 from Sales.Store

 exec xp_cmdshell ' bcp "select name,Demographics.query(''declare default element namespace\"http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey\";for $p in /StoreSurvey return <AnnualSales> {$p/AnnualSales}</AnnualSales>'')as AnnualSales,Demographics.query(''declare default element namespace \"http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey\";for $p in /StoreSurvey return <NumberEmployees>{$p/NumberEmployees}</NumberEmployees>'')as NumberEmployees,Demographics.query(''declare default element namespace \"http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey\";for $p in /StoreSurvey return <YearOpened>{$p/YearOpened}</YearOpened>'')as YearOpened from AdventureWorks2012.Sales.Store" queryout C:\Users\hoori\Desktop\7\Output4.txt  -T -c -q -t"|";'

