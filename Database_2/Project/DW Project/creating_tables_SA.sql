/*
USE master;
GO
DROP DATABASE IF EXISTS SA_sakila;
*/

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SA_sakila')
BEGIN
    CREATE DATABASE [SA_sakila];
END
GO

USE [SA_sakila];
GO

--######################## Access to the source_sakila database #########################

CREATE SYNONYM [dbo].[source_country] FOR [source_sakila].[dbo].[country]
CREATE SYNONYM [dbo].[source_customer] FOR [source_sakila].[dbo].[customer]
CREATE SYNONYM [dbo].[source_actor] FOR [source_sakila].[dbo].[actor]
CREATE SYNONYM [dbo].[source_category] FOR [source_sakila].[dbo].[category]
CREATE SYNONYM [dbo].[source_film_actor] FOR [source_sakila].[dbo].[film_actor]
CREATE SYNONYM [dbo].[source_film_category] FOR [source_sakila].[dbo].[film_category]
CREATE SYNONYM [dbo].[source_film] FOR [source_sakila].[dbo].[film]
CREATE SYNONYM [dbo].[source_payment] FOR [source_sakila].[dbo].[payment]
CREATE SYNONYM [dbo].[source_rental] FOR [source_sakila].[dbo].[rental]
CREATE SYNONYM [dbo].[source_company] FOR [source_sakila].[dbo].[company]
CREATE SYNONYM [dbo].[source_language] FOR [source_sakila].[dbo].[language]
CREATE SYNONYM [dbo].[source_state] FOR [source_sakila].[dbo].[state]
CREATE SYNONYM [dbo].[source_studio] FOR [source_sakila].[dbo].[studio]





--###################################### Tables ########################################

--Create table [dbo].[language]
CREATE TABLE [dbo].[language](
	[language_id] [tinyint] NOT NULL PRIMARY KEY,
	[name] [nvarchar](20) NOT NULL   
);

--Create table [dbo].[country]
CREATE TABLE [dbo].[country](
	[country_id] [smallint] NOT NULL PRIMARY KEY,
	[country] [varchar](50) NOT NULL
);

--Create table [dbo].[state]
CREATE TABLE [dbo].[state](
	[state_id] [int] NOT NULL PRIMARY KEY,
	[state] [varchar](50) NOT NULL,
	[country_id] [smallint] NOT NULL,
    CONSTRAINT FK_CountryState FOREIGN KEY([country_id]) REFERENCES [dbo].[country] ([country_id])
);

--Create table [dbo].[company]
CREATE TABLE [dbo].[company](
	[company_id] [int] NOT NULL PRIMARY KEY,
	[name] [nvarchar](50) NOT NULL,
	[state_id] [int] NOT NULL,
	CONSTRAINT FK_StateCompany FOREIGN KEY([state_id]) REFERENCES [dbo].[state] ([state_id])
);

--Create table [dbo].[studio]
CREATE TABLE [dbo].[studio](
	[studio_id] [int] NOT NULL PRIMARY KEY,
	[company_id] [int] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[state_id] [int] NULL,
	[commission_percent] [smallint] NULL,
	CONSTRAINT FK_StateStudio FOREIGN KEY([state_id]) REFERENCES [dbo].[state] ([state_id]),
	CONSTRAINT FK_CompanyStudio FOREIGN KEY([company_id]) REFERENCES [dbo].[company] ([company_id])
);

--Create table [dbo].[customer]
CREATE TABLE [dbo].[customer](
	[customer_id] [int] NOT NULL PRIMARY KEY,
	[first_name] [varchar](45) NOT NULL,
	[last_name] [varchar](45) NOT NULL,
	[email] [varchar](50) NULL,
	[discount_percent] [smallint] NULL,
	[state_id] [int] NULL,
	[date_of_birth] [date] NULL,
	[gender] [varchar](10) NOT NULL,
    CONSTRAINT FK_StateCustomer FOREIGN KEY([state_id]) REFERENCES [dbo].[state] ([state_id])
);

--Create table [dbo].[actor]
CREATE TABLE [dbo].[actor](
	[actor_id] [int] NOT NULL PRIMARY KEY,
	[first_name] [varchar](45) NOT NULL,
	[last_name] [varchar](45) NOT NULL,
	[gender] [varchar](10) NOT NULL,
	[date_of_birth] [date] NULL,
	[state_id] [int] NULL,
	CONSTRAINT FK_StateActor FOREIGN KEY([state_id]) REFERENCES [dbo].[state] ([state_id])
);

--Create table [dbo].[category]
CREATE TABLE [dbo].[category](
	[category_id] [tinyint] NOT NULL PRIMARY KEY,
	[name] [varchar](25) NOT NULL
);

--Create table [dbo].[film]
CREATE TABLE [dbo].[film](
	[film_id] [int] NOT NULL PRIMARY KEY,
	[title] [varchar](255) NOT NULL,
	[release_year] [varchar](4) NULL,
	[studio_id] [int] NULL,
	[language_id] [tinyint] NOT NULL,
	[original_language_id] [tinyint] NULL,
	[rental_price] [decimal](4, 2) NOT NULL,
	[length] [smallint] NULL,
	[rating] [varchar](10) NULL,
	CONSTRAINT FK_StudioFilm FOREIGN KEY([studio_id]) REFERENCES [dbo].[studio] ([studio_id]),
	CONSTRAINT FK_LanguageFilm FOREIGN KEY([language_id]) REFERENCES [dbo].[language] ([language_id]),
	CONSTRAINT FK_OriginalLanguageFilm FOREIGN KEY([original_language_id]) REFERENCES [dbo].[language] ([language_id])
);

--Create table [dbo].[film_actor]
CREATE TABLE [dbo].[film_actor](
	[actor_id] [int] NOT NULL,
	[film_id] [int] NOT NULL,
	[role] [nvarchar](50) NULL,
	PRIMARY KEY ([actor_id], [film_id]),
	CONSTRAINT FK_Actor_filmActor FOREIGN KEY([actor_id]) REFERENCES [dbo].[actor] ([actor_id]),
	CONSTRAINT FK_Film_filmActor FOREIGN KEY([film_id]) REFERENCES [dbo].[film] ([film_id])
);

--Create table [dbo].[film_category]
CREATE TABLE [dbo].[film_category](
	[film_id] [int] NOT NULL,
	[category_id] [tinyint] NOT NULL,
	PRIMARY KEY ([film_id], [category_id]),
	CONSTRAINT FK_Film_filmCategory FOREIGN KEY([film_id]) REFERENCES [dbo].[film] ([film_id]),
	CONSTRAINT FK_Category_filmCategory FOREIGN KEY([category_id]) REFERENCES [dbo].[category] ([category_id])
);

--Create table [dbo].[rental]
CREATE TABLE [dbo].[rental](
	[rental_id] [int] NOT NULL PRIMARY KEY,
	[rental_date] [date] NOT NULL,
	[customer_id] [int] NOT NULL,
	[type] [nvarchar](50) NULL,
	[duration_time] int NULL,
	[film_id] [int] NULL,
	CONSTRAINT FK_FilmRental FOREIGN KEY([film_id]) REFERENCES [dbo].[film] ([film_id]),
	CONSTRAINT FK_CustomerRental FOREIGN KEY([customer_id]) REFERENCES [dbo].[customer] ([customer_id])
);

--Create table [dbo].[payment]
CREATE TABLE [dbo].[payment](
	[payment_id] [int] NOT NULL PRIMARY KEY,
	[rental_id] [int] NULL,
	[customer_account] [int] NULL, 
	[studio_account] [int] NULL,
	[amount] [decimal](2, 0) NULL,
	[payment_date] [date] NOT NULL,
	CONSTRAINT FK_RentalPayment FOREIGN KEY([rental_id]) REFERENCES [dbo].[rental] ([rental_id]),
	CONSTRAINT FK_CustomerPayment FOREIGN KEY([customer_account]) REFERENCES [dbo].[customer] ([customer_id]),
	CONSTRAINT FK_StudioPayment FOREIGN KEY([studio_account]) REFERENCES [dbo].[studio] ([studio_id])
);






--######################################### log Tables ###########################################
CREATE TABLE [dbo].[ETL_Log](
    [LogID] [INT] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [ProcedureName] [NVARCHAR] (100) NOT NULL,
    [TableName] [NVARCHAR] (100) NOT NULL,
    [StartTime] [DATETIME] NOT NULL,
    [EndTime] [DATETIME],
    [Duration] AS DATEDIFF(SECOND, [StartTime], [EndTime]),
    [Status] [NVARCHAR] (100) NOT NULL,
    [Description] [NVARCHAR] (300) NOT NULL
);
