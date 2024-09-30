/*
USE master;
GO
DROP DATABASE IF EXISTS sakila;
*/

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'sakila_test2')
BEGIN
    CREATE DATABASE [sakila_test2];
END
GO

USE [sakila_test2];
GO


--###################################### Tables ########################################

--Create table [dbo].[language]
CREATE TABLE [dbo].[language](
	[language_id] [tinyint] NOT NULL PRIMARY KEY,
	[name] [char](20) NOT NULL,
	[last_update] [datetime] NOT NULL
);

--Create table [dbo].[country]
CREATE TABLE [dbo].[country](
	[country_id] [smallint] NOT NULL PRIMARY KEY,
	[country] [varchar](50) NOT NULL,
	[last_update] [datetime] NULL
);


--Create table [dbo].[state]
CREATE TABLE [dbo].[state](
	[state_id] [int] NOT NULL PRIMARY KEY,
	[state] [varchar](50) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[last_update] [datetime] NOT NULL,
    FOREIGN KEY([country_id]) REFERENCES [dbo].[country] ([country_id])
);

--Create table [dbo].[manager]
CREATE TABLE [dbo].[manager](
	[manager_id] [int] NOT NULL PRIMARY KEY,
	[first_name] [varchar](45) NOT NULL,
	[last_name] [varchar](45) NOT NULL,
	[email] [varchar](50) NULL,
	[last_update] [datetime] NOT NULL
);

--Create table [dbo].[company]
CREATE TABLE [dbo].[company](
	[company_id] [int] NOT NULL PRIMARY KEY,
	[manager_id] [int] NOT NULL,
	[last_update] [datetime] NOT NULL,
	[name] [nvarchar](50) NULL,
	[state_id] [int] NULL,
	FOREIGN KEY([manager_id]) REFERENCES [dbo].[manager] ([manager_id]),
	FOREIGN KEY([state_id]) REFERENCES [dbo].[state] ([state_id])
);

--Create table [dbo].[studio]
CREATE TABLE [dbo].[studio](
	[studio_id] [int] NOT NULL PRIMARY KEY,
	[company_id] [int] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[state_id] [int] NULL,
	[commission_percent] [smallint] NULL,
	[last_update] [datetime] NOT NULL,
	FOREIGN KEY([state_id]) REFERENCES [dbo].[state] ([state_id]),
	FOREIGN KEY([company_id]) REFERENCES [dbo].[company] ([company_id])
);

--Create table [dbo].[customer]
CREATE TABLE [dbo].[customer](
	[customer_id] [int] NOT NULL PRIMARY KEY,
	[first_name] [varchar](45) NOT NULL,
	[last_name] [varchar](45) NOT NULL,
	[email] [varchar](50) NULL,
	[active] [char](1) NOT NULL,
	[create_date] [datetime] NOT NULL,
	[last_update] [datetime] NOT NULL,
	[discount_percent] [smallint] NULL,
	[state_id] [int] NULL,
	[date_of_birth] [date] NULL,
	[gender] [bit] NULL,
    FOREIGN KEY([state_id]) REFERENCES [dbo].[state] ([state_id])
);

--Create table [dbo].[actor]
CREATE TABLE [dbo].[actor](
	[actor_id] [int] NOT NULL PRIMARY KEY,
	[first_name] [varchar](45) NOT NULL,
	[last_name] [varchar](45) NOT NULL,
	[last_update] [datetime] NOT NULL,
	[gender] [bit] NULL,
	[date_of_birth] [date] NULL,
	[state_id] [int] NULL,
	[Bio] [text] NULL,
	FOREIGN KEY([state_id]) REFERENCES [dbo].[state] ([state_id])
);

--Create table [dbo].[category]
CREATE TABLE [dbo].[category](
	[category_id] [tinyint] NOT NULL PRIMARY KEY,
	[name] [varchar](25) NOT NULL,
	[last_update] [datetime] NOT NULL
);


--Create table [dbo].[film]
CREATE TABLE [dbo].[film](
	[film_id] [int] NOT NULL PRIMARY KEY,
	[title] [varchar](255) NOT NULL,
	[description] [text] NULL,
	[release_year] [varchar](4) NULL,
	[studio_id] [int] NULL,
	[language_id] [tinyint] NOT NULL,
	[original_language_id] [tinyint] NULL,
	[rental_price] [decimal](4, 2) NOT NULL,
	[length] [smallint] NULL,
	[rating] [varchar](10) NULL,
	[last_update] [datetime] NOT NULL,
	[special_features] [varchar](255) NULL,
	FOREIGN KEY([studio_id]) REFERENCES [dbo].[studio] ([studio_id]),
	FOREIGN KEY([language_id]) REFERENCES [dbo].[language] ([language_id]),
	FOREIGN KEY([original_language_id]) REFERENCES [dbo].[language] ([language_id])
);

--Create table [dbo].[film_actor]
CREATE TABLE [dbo].[film_actor](
	[actor_id] [int] NOT NULL,
	[film_id] [int] NOT NULL,
	[role] [nvarchar](50) NULL,
	[last_update] [datetime] NOT NULL,
	PRIMARY KEY ([actor_id], [film_id]),
	FOREIGN KEY([actor_id]) REFERENCES [dbo].[actor] ([actor_id]),
	FOREIGN KEY([film_id]) REFERENCES [dbo].[film] ([film_id])
);

--Create table [dbo].[film_category]
CREATE TABLE [dbo].[film_category](
	[film_id] [int] NOT NULL,
	[category_id] [tinyint] NOT NULL,
	[last_update] [datetime] NOT NULL,
	PRIMARY KEY ([film_id], [category_id]),
	FOREIGN KEY([film_id]) REFERENCES [dbo].[film] ([film_id]),
	FOREIGN KEY([category_id]) REFERENCES [dbo].[category] ([category_id])
);

--Create table [dbo].[rental]
CREATE TABLE [dbo].[rental](
	[rental_id] [int] NOT NULL PRIMARY KEY,
	[rental_date] [datetime] NOT NULL,
	[customer_id] [int] NOT NULL,
	[type] [nvarchar](50) NULL,
	[duration_time] int NULL,
	[last_update] [datetime] NOT NULL,
	[film_id] [int] NULL,
	FOREIGN KEY([film_id]) REFERENCES [dbo].[film] ([film_id]),
	FOREIGN KEY([customer_id]) REFERENCES [dbo].[customer] ([customer_id])
);

--Create table [dbo].[payment]
CREATE TABLE [dbo].[payment](
	[payment_id] [int] NOT NULL PRIMARY KEY,
	[rental_id] [int] NULL,
	[customer_account] [int] NULL, 
	[studio_account] [int] NULL,
	[amount] [decimal](2, 0) NULL,
	[payment_date] [datetime] NOT NULL,
	[last_update] [datetime] NOT NULL,
	FOREIGN KEY([rental_id]) REFERENCES [dbo].[rental] ([rental_id]),
	FOREIGN KEY([customer_account]) REFERENCES [dbo].[customer] ([customer_id]),
	FOREIGN KEY([studio_account]) REFERENCES [dbo].[studio] ([studio_id])
);


--Create table [dbo].[film_country]
CREATE TABLE [dbo].[film_country](
	[country_id] [smallint] NOT NULL,
	[film_id] [int] NOT NULL,
	[last_update] [datetime] NOT NULL,
	PRIMARY KEY ([country_id], [film_id]),
	FOREIGN KEY([country_id]) REFERENCES [dbo].[country] ([country_id]),
	FOREIGN KEY([film_id]) REFERENCES [dbo].[film] ([film_id]),
);



