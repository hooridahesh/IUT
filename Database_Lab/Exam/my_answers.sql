sp_configure 'show advanced options', 1;
RECONFIGURE;
Go
sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO
exec sp_configure 'Advanced', 1 RECONFIGURE
exec sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',
N'AllowInProcess', 1
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',
N'DynamicParameters', 1
GO

-------
drop table registration;
drop table tmp_reg;
drop table registration_max;
-----------

--1
create table registration
(
	NationalCode float,
	ChairNumber int PRIMARY KEY,
	FirstName nvarchar(100),
	LastName nvarchar(100),
	Field nvarchar(50)
);

BULK INSERT AdventureWorks2012.dbo.registration
FROM 'C:\Users\hoori\Desktop\newD\exam\Data1.xlsx'
WITH (
	FIELDTERMINATOR = '|'
);


--2
create table tmp_reg
(
	NationalCode float,
	ChairNumber int PRIMARY KEY,
	Allowed nvarchar(50)
);

BULK INSERT registration
FROM 'C:\Users\hoori\Desktop\newD\exam\Data2.xlsx'
WITH
(
FIELDTERMINATOR = '|'
);

--3

CREATE PROCEDURE update_registration
as
begin

alter table registration
	add Allowed nvarchar(50)

--b
update registration
set registration.Allowed=N'غایب'
from registration left join tmp_reg on ( registration.ChairNumber =tmp_reg.ChairNumber)
where tmp_reg.ChairNumber IS NULL

--c
insert into registration(NationalCode,ChairNumber,FirstName,LastName,Field,Allowed)
select tmp_reg.NationalCode,tmp_reg.ChairNumber,N'نامشخص',N'نامشخص',N'نامشخص',tmp_reg.Allowed
from registration right join tmp_reg on ( registration.ChairNumber =tmp_reg.ChairNumber)
where registration.ChairNumber IS NULL

--d

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'registration_max')
BEGIN
    CREATE TABLE registration_max
    (
		NationalCode float,
		ChairNumber int PRIMARY KEY,
		FirstName nvarchar(100),
		LastName nvarchar(100),
		Field nvarchar(50),
		Allowed nvarchar(50)
    );
END

insert into registration_max(NationalCode,ChairNumber,FirstName,LastName,Field,Allowed)
select NationalCode,ChairNumber,FirstName,LastName,Field,Allowed
from( 
select * ,ROW_NUMBER() OVER (PARTITION BY Field ORDER BY NationalCode DESC) AS "ROW_NUMBER" 
from registration
) as f_rank
where f_rank.ROW_NUMBER <= 3

delete from registration
where ChairNumber in (select ChairNumber from registration_max)

end

EXECUTE update_registration