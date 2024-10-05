-- 1 --
USE [master]
GO
CREATE LOGIN [login_hoori] WITH PASSWORD=N'123', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


-- 2 --
USE [master]

GO

CREATE SERVER ROLE [Role1] AUTHORIZATION [login_hoori]

GO

ALTER SERVER ROLE [dbcreator] ADD MEMBER [Role1]

GO

-- 3 --
USE [AdventureWorks2012]
GO
CREATE USER [user_hoori] FOR LOGIN [login_hoori]
GO

-- 4 --
USE [AdventureWorks2012]
GO
ALTER ROLE [db_datareader] ADD MEMBER [user_hoori]
GO
USE [AdventureWorks2012]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [user_hoori]
GO
USE [AdventureWorks2012]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [user_hoori]
GO
USE [AdventureWorks2012]
GO
ALTER ROLE [db_owner] ADD MEMBER [user_hoori]
GO

-- 5 --
CREATE TABLE MyTable(
	name nvarchar(255)
);
INSERT INTO MyTable VALUES('hoori');
INSERT INTO MyTable VALUES('arezoo');
INSERT INTO MyTable VALUES('ehsan')

SELECT * FROM MyTable;

-- 2 --
USE [master]

GO

CREATE SERVER ROLE [Role2] AUTHORIZATION [login_hoori]

GO

ALTER SERVER ROLE [securityadmin] ADD MEMBER [Role2]

GO


