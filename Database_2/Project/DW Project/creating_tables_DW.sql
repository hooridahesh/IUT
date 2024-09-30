/*
USE master;
GO
DROP DATABASE IF EXISTS DW_sakila;
*/

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DW_sakila')
BEGIN
    CREATE DATABASE [DW_sakila];
END
Go

USE [DW_sakila];
GO

--############################# Access to the SA_sakila database ##############################
/*
DROP SYNONYM [dbo].[country];
DROP SYNONYM [dbo].[customer];
DROP SYNONYM [dbo].[actor];
DROP SYNONYM [dbo].[category];
DROP SYNONYM [dbo].[film_actor];
DROP SYNONYM [dbo].[film_category];
DROP SYNONYM [dbo].[film];
DROP SYNONYM [dbo].[payment];
DROP SYNONYM [dbo].[rental];
DROP SYNONYM [dbo].[company];
DROP SYNONYM [dbo].[language];
DROP SYNONYM [dbo].[state];
DROP SYNONYM [dbo].[studio];
*/

CREATE SYNONYM [dbo].[language] FOR [SA_sakila].[dbo].[language]
CREATE SYNONYM [dbo].[country] FOR [SA_sakila].[dbo].[country]
CREATE SYNONYM [dbo].[state] FOR [SA_sakila].[dbo].[state]
CREATE SYNONYM [dbo].[company] FOR [SA_sakila].[dbo].[company]
CREATE SYNONYM [dbo].[studio] FOR [SA_sakila].[dbo].[studio]
CREATE SYNONYM [dbo].[customer] FOR [SA_sakila].[dbo].[customer]
CREATE SYNONYM [dbo].[actor] FOR [SA_sakila].[dbo].[actor]
CREATE SYNONYM [dbo].[category] FOR [SA_sakila].[dbo].[category]
CREATE SYNONYM [dbo].[film] FOR [SA_sakila].[dbo].[film]
CREATE SYNONYM [dbo].[film_actor] FOR [SA_sakila].[dbo].[film_actor]
CREATE SYNONYM [dbo].[film_category] FOR [SA_sakila].[dbo].[film_category]
CREATE SYNONYM [dbo].[payment] FOR [SA_sakila].[dbo].[payment]
CREATE SYNONYM [dbo].[rental] FOR [SA_sakila].[dbo].[rental]



--###################################### Dimention Tables ########################################

--create table Dim_Date
CREATE TABLE [dbo].[Dim_Date](
	[TimeKey] [int] NOT NULL primary key,
	[FullDateAlternateKey] [nvarchar](50) NOT NULL,
	[PersianFullDateAlternateKey] [nvarchar](50) NOT NULL,
	[DayNumberOfWeek] [int] NOT NULL,
	[PersianDayNumberOfWeek] [int] NOT NULL,
	[EnglishDayNameOfWeek] [nvarchar](50) NOT NULL,
	[PersianDayNameOfWeek] [nvarchar](50) NOT NULL,
	[DayNumberOfMonth] [int] NOT NULL,
	[PersianDayNumberOfMonth] [int] NOT NULL,
	[DayNumberOfYear] [int] NOT NULL,
	[PersianDayNumberOfYear] [int] NOT NULL,
	[WeekNumberOfYear] [int] NOT NULL,
	[PersianWeekNumberOfYear] [int] NOT NULL,
	[EnglishMonthName] [nvarchar](50) NOT NULL,
	[PersianMonthName] [nvarchar](50) NOT NULL,
	[MonthNumberOfYear] [int] NOT NULL,
	[PersianMonthNumberOfYear] [int] NOT NULL,
	[CalendarQuarter] [int] NOT NULL,
	[PersianCalendarQuarter] [int] NOT NULL,
	[CalendarYear] [int] NOT NULL,
	[PersianCalendarYear] [int] NOT NULL,
	[CalendarSemester] [int] NOT NULL,
	[PersianCalendarSemester] [int] NOT NULL
);

--create table Dim_CUSTOMER
CREATE TABLE [dbo].[Dim_CUSTOMER](
	[SK_customer] [int] IDENTITY(1,1) NOT NULL primary key,   
	[customer_id] [int] NOT NULL,             
	[first_name] [varchar](100) NOT NULL,
	[last_name] [varchar](100) NOT NULL,
	[email] [varchar](100) NULL,
	[date_of_birth] [date] NULL,
	[gender] [varchar](20) NOT NULL,              
	[state_id] [int] NOT NULL,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[country] [varchar](100) NOT NULL,
	[discount_percent] [smallint] NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NULL,
	[Current_Flag] [bit] NOT NULL
);

--create table Dim_STUDIO
CREATE TABLE [dbo].[Dim_STUDIO](
	[studio_id] [int] NOT NULL primary key,
	[company_id] [int] NOT NULL,
	[company_name] [nvarchar](100) NULL,
	[commission_percent] [smallint] NULL,	
	[state_id] [int] NOT NULL,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[country] [varchar](100) NOT NULL,
	[original_studio_name] [nvarchar](100) NULL,
	[Effective_Date] [date] NOT NULL,
	[current_studio_name] [nvarchar](100) NOT NULL
);

--create table Dim_COMPANY
CREATE TABLE [dbo].[Dim_COMPANY](
	[company_id] [int] NOT NULL primary key,	
	[state_id] [int] NOT NULL,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[country] [varchar](100) NOT NULL,
	[original_company_name] [nvarchar](100) NULL,
	[Effective_Date] [date] NOT NULL,
	[current_company_name] [nvarchar](100) NOT NULL
);

--create table Dim_FILM
CREATE TABLE [dbo].[Dim_FILM](
	[SK_film] [int] IDENTITY(1,1) NOT NULL primary key,   
	[film_id] [int] NOT NULL,           
	[title] [varchar](500) NOT NULL,
	[release_year] [varchar](15) NULL,
	[language_id] [tinyint] NOT NULL,   
	[language_name] [nvarchar](50) NOT NULL,                       
	[original_language_id] [tinyint] NULL,
	[original_language_name] [nvarchar](50) NOT NULL,                               
	[length] [smallint] NULL,
	[rating] [varchar](20) NULL,
	[studio_id] [int] NOT NULL,
	[studio_name] [nvarchar](100) NOT NULL,
	[rental_price] [decimal](4, 2) NOT NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NULL,
	[Current_Flag] [bit] NOT NULL
);

--create table Dim_STATE  
CREATE TABLE [dbo].[Dim_STATE](	
	[state_id] [int] NOT NULL primary key,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[country] [varchar](100) NOT NULL
);

--create table Dim_CATEGORY
CREATE TABLE [dbo].[Dim_CATEGORY](	
	[category_id] [tinyint] NOT NULL primary key,
	[category_name] [varchar](70) NOT NULL
);

--create table Dim_ACTOR
CREATE TABLE [dbo].[Dim_ACTOR](
	[actor_id] [int] NOT NULL primary key,
	[first_name] [varchar](100) NOT NULL,
	[last_name] [varchar](100) NOT NULL,
	[gender] [varchar](20) NOT NULL,              
	[date_of_birth] [date] NULL,
	[state_id] [int] NOT NULL,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[country] [varchar](100) NOT NULL
);


--################################### Rental ==> Fact Tables ######################################
 
--create table Fact_Transaction_Rental
CREATE TABLE [dbo].[Fact_Transaction_Rental](
	[TimeKey] [int] NOT NULL,
	[sk_customer_payment] [int] NOT NULL,
	[customer_id_payment] [int] NOT NULL,
	[state_id_customer_payment] [int] NOT NULL,
	[sk_customer_rental] [int] NOT NULL,
	[customer_id_rental] [int] NOT NULL,
	[start_date] [int] NOT NULL,
	[sk_film] [int] NOT NULL, 
	[film_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,   
	[company_id] [int] NOT NULL,
	[duration_time] [int] NULL,	
	[amount] [decimal](10, 2) NULL
    CONSTRAINT FK_date_Transaction_Rental FOREIGN KEY([TimeKey]) REFERENCES [dbo].[Dim_Date](TimeKey),
    CONSTRAINT FK_startDate_Transaction_Rental FOREIGN KEY([start_date]) REFERENCES [dbo].[Dim_Date](TimeKey),
    CONSTRAINT FK_Customer_payment_Transaction_Rental FOREIGN KEY([sk_customer_payment]) REFERENCES [dbo].[Dim_CUSTOMER]([SK_customer]),
    CONSTRAINT FK_Customer_rental_Transaction_Rental FOREIGN KEY([sk_customer_payment]) REFERENCES [dbo].[Dim_CUSTOMER]([SK_customer]),
    CONSTRAINT FK_state_Transaction_Rental FOREIGN KEY([state_id_customer_payment]) REFERENCES [dbo].[Dim_STATE]([state_id]),
    CONSTRAINT FK_film_Transaction_Rental FOREIGN KEY([sk_film]) REFERENCES [dbo].[Dim_FILM]([SK_film]),
    CONSTRAINT FK_studio_Transaction_Rental FOREIGN KEY([studio_id]) REFERENCES [dbo].[Dim_STUDIO]([studio_id]),
    CONSTRAINT FK_company_Transaction_Rental FOREIGN KEY([company_id]) REFERENCES [dbo].[Dim_COMPANY]([company_id])
);

--create table Fact_Daily_Rental
CREATE TABLE [dbo].[Fact_Daily_Rental](
	[TimeKey] [int] NOT NULL,
	[sk_film] [int] NOT NULL,
	[film_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,       
	[company_id] [int] NOT NULL,	
	[number_of_rentals] [bigint] NULL, 
	[total_duration] [int] NULL,
	[amount] [decimal](10, 2) NULL,
    CONSTRAINT FK_date_Daily_Rental FOREIGN KEY([TimeKey]) REFERENCES [dbo].[Dim_Date](TimeKey),
    CONSTRAINT FK_film_Daily_Rental FOREIGN KEY([sk_film]) REFERENCES [dbo].[Dim_FILM]([SK_film]),
    CONSTRAINT FK_studio_Daily_Rental FOREIGN KEY([studio_id]) REFERENCES [dbo].[Dim_STUDIO]([studio_id]),
    CONSTRAINT FK_company_Daily_Rental FOREIGN KEY([company_id]) REFERENCES [dbo].[Dim_COMPANY]([company_id])
);

--create table Fact_ACC_Rental
CREATE TABLE [dbo].[Fact_ACC_Rental](
	[sk_film] [int] NOT NULL,
	[film_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,       
	[company_id] [int] NOT NULL,	
	[number_of_rentals] [bigint] NULL,
	[total_duration] [int] NULL,
	[amount] [decimal](10, 2) NULL,
    CONSTRAINT FK_film_ACC_Rental FOREIGN KEY([sk_film]) REFERENCES [dbo].[Dim_FILM]([SK_film]),
    CONSTRAINT FK_studio_ACC_Rental FOREIGN KEY([studio_id]) REFERENCES [dbo].[Dim_STUDIO]([studio_id]),
    CONSTRAINT FK_company_ACC_Rental FOREIGN KEY([company_id]) REFERENCES [dbo].[Dim_COMPANY]([company_id])
);

--create table Factless_FilmActorRelation         
CREATE TABLE [dbo].[Factless_FilmActorRelation](
	[sk_film] [int] NOT NULL,
	[film_id] [int] NOT NULL,             
	[actor_id] [int] NOT NULL,
	[role] [nvarchar](100) NOT NULL,
    CONSTRAINT FK_film_Factless_Rental FOREIGN KEY([sk_film]) REFERENCES [dbo].[Dim_FILM]([SK_film]),
    CONSTRAINT FK_actor_Factless_Rental FOREIGN KEY([actor_id]) REFERENCES [dbo].[Dim_ACTOR]([actor_id])
);







--################################# Payment ==> Fact Tables ####################################

CREATE TABLE [dbo].[Fact_Transaction_Payment](
	[SK_customer] [int]  NOT NULL,   
	[customer_id] [int] NOT NULL,             
	[company_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,
	[TimeKey] [int] NOT NULL,

	[original_amount] [decimal](6, 2) NOT NULL,
	[discount_amount] [decimal](6, 2) NOT NULL,
	[paid_amount] [decimal](6, 2) NOT NULL,
	[our_commission_fee] [decimal](6, 2) NOT NULL,

	CONSTRAINT FK_customer_Transaction_Payment FOREIGN KEY([SK_customer]) REFERENCES [dbo].[Dim_CUSTOMER] ([SK_customer]),
	CONSTRAINT FK_studio_Transaction_Payment FOREIGN KEY([studio_id]) REFERENCES [dbo].[Dim_STUDIO] ([studio_id]),
	CONSTRAINT FK_company_Transaction_Payment FOREIGN KEY([company_id]) REFERENCES [dbo].[Dim_COMPANY] ([company_id]),
	CONSTRAINT FK_date_Transaction_Payment FOREIGN KEY([TimeKey]) REFERENCES [dbo].[Dim_Date] ([TimeKey])
);


CREATE TABLE [dbo].[Fact_Daily_Payment](
	[TimeKey] [int] NOT NULL,
	[company_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,

	[number_of_transaction] [int] null,
	[total_original_amount] [decimal](12, 2) NULL,
	[total_discount_amount] [decimal](12, 2) NULL,
	[total_paid_amount] [decimal](12, 2) NULL,
	[average_paid_amount] [decimal](12, 2) NULL,
	[our_total_commission_fee] [decimal](12, 2) NULL,

	CONSTRAINT FK_studio_Daily_Payment  FOREIGN KEY([studio_id]) REFERENCES [dbo].[Dim_STUDIO] ([studio_id]),
	CONSTRAINT FK_company_Daily_Payment FOREIGN KEY([company_id]) REFERENCES [dbo].[Dim_COMPANY] ([company_id]),
	CONSTRAINT FK_date_Daily_Payment FOREIGN KEY([TimeKey]) REFERENCES [dbo].[Dim_Date] ([TimeKey])
);


CREATE TABLE [dbo].[Fact_ACC_Payment](
	[company_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,

	[number_of_transaction] [bigint] null,
	[total_original_amount] [decimal](14, 2) NULL,
	[total_discount_amount] [decimal](14, 2) NULL,
	[total_paid_amount] [decimal](14, 2) NULL,
	[average_paid_amount] [decimal](14, 2) NULL,
	[our_total_commission_fee] [decimal](14, 2) NULL,


	CONSTRAINT FK_studio_ACC_Payment FOREIGN KEY([studio_id]) REFERENCES [dbo].[Dim_STUDIO] ([studio_id]),
	CONSTRAINT FK_company_ACC_Payment FOREIGN KEY([company_id]) REFERENCES [dbo].[Dim_COMPANY] ([company_id])
);



--create table Factless_FilmCategoryRelation
CREATE TABLE [dbo].[Factless_FilmCategoryRelation](
	[sk_film] [int] NOT NULL,
	[film_id] [int] NOT NULL,             
	[category_id] [tinyint] NOT NULL,
    CONSTRAINT FK_film_Factless_Payment FOREIGN KEY([sk_film]) REFERENCES [dbo].[Dim_FILM]([SK_film]), 
    CONSTRAINT FK_category_Factless_Payment FOREIGN KEY([category_id]) REFERENCES [dbo].[Dim_CATEGORY]([category_id])
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



--######################################### Dimension => Temp Tables ###########################################

--create table tmp2_dim_customer
CREATE TABLE [dbo].[tmp2_dim_customer](
	[SK_customer] [int] IDENTITY(1,1) NOT NULL primary key,   
	[customer_id] [int] NOT NULL,             
	[first_name] [varchar](100) NOT NULL,
	[last_name] [varchar](100) NOT NULL,
	[email] [varchar](100) NULL,
	[date_of_birth] [date] NULL,
	[gender] [varchar](20) NOT NULL,              
	[state_id] [int] NOT NULL,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[discount_percent] [smallint] NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NULL,
	[Current_Flag] [bit] NOT NULL
);

--create table tmp_dim_customer
CREATE TABLE [dbo].[tmp_dim_customer](
	[SK_customer] [int] IDENTITY(1,1) NOT NULL primary key,   
	[customer_id] [int] NOT NULL,             
	[first_name] [varchar](100) NOT NULL,
	[last_name] [varchar](100) NOT NULL,
	[email] [varchar](100) NULL,
	[date_of_birth] [date] NULL,
	[gender] [varchar](20) NOT NULL,              
	[state_id] [int] NOT NULL,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[country] [varchar](100) NOT NULL,
	[discount_percent] [smallint] NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NULL,
	[Current_Flag] [bit] NOT NULL
);

--create table tmp_changeDiscountPercent_customer
CREATE TABLE [dbo].[tmp_changeDiscountPercent_customer](
	[customer_id] [int] NOT NULL primary key,             
	[first_name] [varchar](100) NOT NULL,
	[last_name] [varchar](100) NOT NULL,
	[email] [varchar](100) NULL,
	[date_of_birth] [date] NULL,
	[gender] [varchar](20) NOT NULL,              
	[state_id] [int] NOT NULL,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[country] [varchar](100) NOT NULL,
	[discount_percent] [smallint] NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NULL,
	[Current_Flag] [bit] NOT NULL
);

--create table tmp3_dim_studio
CREATE TABLE [dbo].[tmp3_dim_studio](
	[studio_id] [int] NOT NULL primary key,
	[company_id] [int] NOT NULL,
	[company_name] [nvarchar](100) NULL,
	[commission_percent] [smallint] NULL,	
	[state_id] [int] NOT NULL,
	[original_studio_name] [nvarchar](100) NULL,
	[Effective_Date] [date] NOT NULL,
	[current_studio_name] [nvarchar](100) NOT NULL
);

--create table tmp2_dim_studio
CREATE TABLE [dbo].[tmp2_dim_studio](
	[studio_id] [int] NOT NULL primary key,
	[company_id] [int] NOT NULL,
	[company_name] [nvarchar](100) NULL,
	[commission_percent] [smallint] NULL,	
	[state_id] [int] NOT NULL,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[original_studio_name] [nvarchar](100) NULL,
	[Effective_Date] [date] NOT NULL,
	[current_studio_name] [nvarchar](100) NOT NULL
);

--create table tmp_dim_studio
CREATE TABLE [dbo].[tmp_dim_studio](
	[studio_id] [int] NOT NULL primary key,
	[company_id] [int] NOT NULL,
	[company_name] [nvarchar](100) NULL,
	[commission_percent] [smallint] NULL,	
	[state_id] [int] NOT NULL,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[country] [varchar](100) NOT NULL,
	[original_studio_name] [nvarchar](100) NULL,
	[Effective_Date] [date] NOT NULL,
	[current_studio_name] [nvarchar](100) NOT NULL
);

--create table tmp2_dim_company
CREATE TABLE [dbo].[tmp2_dim_company](
	[company_id] [int] NOT NULL primary key,	
	[state_id] [int] NOT NULL,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[original_company_name] [nvarchar](100) NULL,
	[Effective_Date] [date] NOT NULL,
	[current_company_name] [nvarchar](100) NOT NULL
);

--create table tmp_dim_company
CREATE TABLE [dbo].[tmp_dim_company](
	[company_id] [int] NOT NULL primary key,	
	[state_id] [int] NOT NULL,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[country] [varchar](100) NOT NULL,
	[original_company_name] [nvarchar](100) NULL,
	[Effective_Date] [date] NOT NULL,
	[current_company_name] [nvarchar](100) NOT NULL
);

--create table tmp3_dim_film
CREATE TABLE [dbo].[tmp3_dim_film](
	[SK_film] [int] IDENTITY(1,1) NOT NULL primary key,   
	[film_id] [int] NOT NULL,           
	[title] [varchar](500) NOT NULL,
	[release_year] [varchar](15) NULL,
	[language_id] [tinyint] NOT NULL,   
	[language_name] [nvarchar](50) NOT NULL,                       
	[original_language_id] [tinyint] NULL,
	[length] [smallint] NULL,
	[rating] [varchar](20) NULL,
	[studio_id] [int] NOT NULL,
	[rental_price] [decimal](4, 2) NOT NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NULL,
	[Current_Flag] [bit] NOT NULL
);

--create table tmp2_dim_film
CREATE TABLE [dbo].[tmp2_dim_film](
	[SK_film] [int] IDENTITY(1,1) NOT NULL primary key,   
	[film_id] [int] NOT NULL,           
	[title] [varchar](500) NOT NULL,
	[release_year] [varchar](15) NULL,
	[language_id] [tinyint] NOT NULL,   
	[language_name] [nvarchar](50) NOT NULL,                       
	[original_language_id] [tinyint] NULL,
	[original_language_name] [nvarchar](50) NOT NULL,                               
	[length] [smallint] NULL,
	[rating] [varchar](20) NULL,
	[studio_id] [int] NOT NULL,
	[rental_price] [decimal](4, 2) NOT NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NULL,
	[Current_Flag] [bit] NOT NULL
);

--create table tmp_dim_film
CREATE TABLE [dbo].[tmp_dim_film](
	[SK_film] [int] IDENTITY(1,1) NOT NULL primary key,   
	[film_id] [int] NOT NULL,           
	[title] [varchar](500) NOT NULL,
	[release_year] [varchar](15) NULL,
	[language_id] [tinyint] NOT NULL,   
	[language_name] [nvarchar](50) NOT NULL,                       
	[original_language_id] [tinyint] NULL,
	[original_language_name] [nvarchar](50) NOT NULL,                               
	[length] [smallint] NULL,
	[rating] [varchar](20) NULL,
	[studio_id] [int] NOT NULL,
	[studio_name] [nvarchar](100) NOT NULL,
	[rental_price] [decimal](4, 2) NOT NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NULL,
	[Current_Flag] [bit] NOT NULL
);

--create table tmp_changeRentalPrice_film
CREATE TABLE [dbo].[tmp_changeRentalPrice_film](
	[film_id] [int] NOT NULL primary key,           
	[title] [varchar](500) NOT NULL,
	[release_year] [varchar](15) NULL,
	[language_id] [tinyint] NOT NULL,   
	[language_name] [nvarchar](50) NOT NULL,                       
	[original_language_id] [tinyint] NULL,
	[original_language_name] [nvarchar](50) NOT NULL,                               
	[length] [smallint] NULL,
	[rating] [varchar](20) NULL,
	[studio_id] [int] NOT NULL,
	[studio_name] [nvarchar](100) NOT NULL,
	[rental_price] [decimal](4, 2) NOT NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NULL,
	[Current_Flag] [bit] NOT NULL
);

--create table tmp_dim_state
CREATE TABLE [dbo].[tmp_dim_state](	
	[state_id] [int] NOT NULL primary key,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[country] [varchar](100) NOT NULL
);

--create table tmp2_dim_actor
CREATE TABLE [dbo].[tmp2_dim_actor](
	[actor_id] [int] NOT NULL primary key,
	[first_name] [varchar](100) NOT NULL,
	[last_name] [varchar](100) NOT NULL,
	[gender] [varchar](20) NOT NULL,              
	[date_of_birth] [date] NULL,
	[state_id] [int] NOT NULL,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL
);

--create table tmp_dim_actor
CREATE TABLE [dbo].[tmp_dim_actor](
	[actor_id] [int] NOT NULL primary key,
	[first_name] [varchar](100) NOT NULL,
	[last_name] [varchar](100) NOT NULL,
	[gender] [varchar](20) NOT NULL,              
	[date_of_birth] [date] NULL,
	[state_id] [int] NOT NULL,
	[state] [varchar](100) NOT NULL,
	[country_id] [smallint] NOT NULL,
	[country] [varchar](100) NOT NULL
);



--######################################### Rental => Temp Tables ###########################################

--create table tmp6_Fact_Transaction_Rental
CREATE TABLE [dbo].[tmp6_Fact_Transaction_Rental](
	[TimeKey] [int] NOT NULL,
	[payment_id] [int] NOT NULL,
	[rental_id] [int] NOT NULL,
	[customer_id_payment] [int] NOT NULL, 
	[studio_id] [int] NOT NULL,
	[amount] [decimal](10, 2) NULL
);

--create table tmp5_Fact_Transaction_Rental
CREATE TABLE [dbo].[tmp5_Fact_Transaction_Rental](
	[TimeKey] [int] NOT NULL,
	[sk_customer_payment] [int] NOT NULL,
	[customer_id_payment] [int] NOT NULL, 
	[state_id_customer_payment] [int] NOT NULL,
	[rental_id] [int] NOT NULL,     
	[studio_id] [int] NOT NULL,
	[amount] [decimal](10, 2) NULL
);

--create table tmp4_Fact_Transaction_Rental
CREATE TABLE [dbo].[tmp4_Fact_Transaction_Rental](
	[TimeKey] [int] NOT NULL,
	[sk_customer_payment] [int] NOT NULL,
	[customer_id_payment] [int] NOT NULL,
	[state_id_customer_payment] [int] NOT NULL,	 
	[customer_id_rental] [int] NOT NULL,
	[start_date] [int] NOT NULL,
	[duration_time] [int] NULL,
	[film_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,
	[amount] [decimal](10, 2) NULL
);

--create table tmp3_Fact_Transaction_Rental
CREATE TABLE [dbo].[tmp3_Fact_Transaction_Rental](
	[TimeKey] [int] NOT NULL,
	[sk_customer_payment] [int] NOT NULL,
	[customer_id_payment] [int] NOT NULL,
	[state_id_customer_payment] [int] NOT NULL,
	[sk_customer_rental] [int] NOT NULL,
	[customer_id_rental] [int] NOT NULL,
	[start_date] [int] NOT NULL,
	[duration_time] [int] NULL,
	[film_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,
	[amount] [decimal](10, 2) NULL
);

--create table tmp2_Fact_Transaction_Rental
CREATE TABLE [dbo].[tmp2_Fact_Transaction_Rental](
	[TimeKey] [int] NOT NULL,
	[sk_customer_payment] [int] NOT NULL,
	[customer_id_payment] [int] NOT NULL,
	[state_id_customer_payment] [int] NOT NULL,
	[sk_customer_rental] [int] NOT NULL,
	[customer_id_rental] [int] NOT NULL,
	[start_date] [int] NOT NULL,
	[duration_time] [int] NULL,
	[sk_film] [int] NOT NULL, 
	[film_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,
	[amount] [decimal](10, 2) NULL
);

--create table tmp_Fact_Transaction_Rental
CREATE TABLE [dbo].[tmp_Fact_Transaction_Rental](
	[TimeKey] [int] NOT NULL,
	[sk_customer_payment] [int] NOT NULL,
	[customer_id_payment] [int] NOT NULL,
	[state_id_customer_payment] [int] NOT NULL,
	[sk_customer_rental] [int] NOT NULL,
	[customer_id_rental] [int] NOT NULL,
	[start_date] [int] NOT NULL,
	[duration_time] [int] NULL,
	[sk_film] [int] NOT NULL, 
	[film_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,   
	[company_id] [int] NOT NULL,	
	[amount] [decimal](10, 2) NULL
);

--create table tmp1_Fact_Daily_Rental
CREATE TABLE [dbo].[tmp1_Fact_Daily_Rental](
	[TimeKey] [int] NOT NULL,
	[sk_film] [int] NOT NULL,
	[film_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL
);

--create table tmp2_Fact_Daily_Rental
CREATE TABLE [dbo].[tmp2_Fact_Daily_Rental](
	[TimeKey] [int] NOT NULL,
	[sk_film] [int] NOT NULL,
	[film_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,
	[company_id] [int] NOT NULL,	
);

--create table copy_Fact_Transaction_Rental
CREATE TABLE [dbo].[copy_Fact_Transaction_Rental](
	[TimeKey] [int] NOT NULL,
	[film_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,       
	[company_id] [int] NOT NULL,	
	[number_of_rentals] [bigint] NULL,
	[total_duration] [int] NULL,
	[amount] [decimal](10, 2) NULL
);

--create table tmp_Fact_Daily_Rental
CREATE TABLE [dbo].[tmp_Fact_Daily_Rental](
	[TimeKey] [int] NOT NULL,
	[sk_film] [int] NOT NULL,
	[film_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,       
	[company_id] [int] NOT NULL,	
	[number_of_rentals] [bigint] NULL,
	[total_duration] [int] NULL,
	[amount] [decimal](10, 2) NULL
);

--create table tmp_Factless_FilmActorRelation        
CREATE TABLE [dbo].[tmp_Factless_FilmActorRelation](
	[sk_film] [int] NOT NULL,
	[film_id] [int] NOT NULL,             
	[actor_id] [int] NOT NULL,
	[role] [nvarchar](100) NOT NULL  
);


--create table tmp_Fact_ACC_Rental
CREATE TABLE [dbo].[tmp_Fact_ACC_Rental](
  [sk_film] [int] NOT NULL,
  [film_id] [int] NOT NULL,
  [studio_id] [int] NOT NULL,       
  [company_id] [int] NOT NULL,  
  [number_of_rentals] [bigint] NULL,
  [total_duration] [int] NULL,
  [amount] [decimal](10, 2) NULL
);



--################################## Payment => temp tables ##################################

-- temp tables for Fact Transaction Payment

CREATE TABLE [dbo].[Tmp_Fact_Transaction_Payment](
	[SK_customer] [int]  NOT NULL,   
	[customer_id] [int] NOT NULL,             
	[company_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,
	[TimeKey] [int] NOT NULL,

	[original_amount] [decimal](6, 2) NOT NULL,
	[discount_amount] [decimal](6, 2) NOT NULL,
	[paid_amount] [decimal](6, 2) NOT NULL,
	[our_commission_fee] [decimal](6, 2) NOT NULL,

);

CREATE TABLE [dbo].[Tmp2_Fact_Transaction_Payment](   
	[customer_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,
	[TimeKey] [int] NOT NULL,
	[paid_amount] [decimal](6, 2) NOT NULL
);

CREATE TABLE [dbo].[Tmp3_Fact_Transaction_Payment](
	[SK_customer] [int]  NOT NULL,
	[customer_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,
	[TimeKey] [int] NOT NULL,
	[original_amount] [decimal](6, 2) NOT NULL,
	[discount_amount] [decimal](6, 2) NOT NULL,
	[paid_amount] [decimal](6, 2) NOT NULL
);



-- temp tables for Fact Daily Payment

CREATE TABLE [dbo].[Tmp_Fact_Daily_Payment](
	[TimeKey] [int] NOT NULL,
	[company_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL
);

CREATE TABLE [dbo].[Tmp2_Fact_Daily_Payment](
	[TimeKey] [int] NOT NULL,
	[company_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,

	[number_of_transaction] [int] not null,
	[total_original_amount] [decimal](12, 2) NOT NULL,
	[total_discount_amount] [decimal](12, 2) NOT NULL,
	[total_paid_amount] [decimal](12, 2) NOT NULL,
	[average_paid_amount] [decimal](12, 2) NOT NULL,
	[our_total_commission_fee] [decimal](12, 2) NOT NULL
);


CREATE TABLE [dbo].[Tmp3_Fact_Daily_Payment](
	[TimeKey] [int] NOT NULL,
	[company_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,

	[number_of_transaction] [int] null,
	[total_original_amount] [decimal](12, 2) NULL,
	[total_discount_amount] [decimal](12, 2) NULL,
	[total_paid_amount] [decimal](12, 2) NULL,
	[average_paid_amount] [decimal](12, 2) NULL,
	[our_total_commission_fee] [decimal](12, 2) NULL
);



-- temp tables for Fact Daily Payment

CREATE TABLE [dbo].[tmp_Fact_ACC_Payment](
	[company_id] [int] NOT NULL,
	[studio_id] [int] NOT NULL,

	[number_of_transaction] [bigint] null,
	[total_original_amount] [decimal](14, 2) NULL,
	[total_discount_amount] [decimal](14, 2) NULL,
	[total_paid_amount] [decimal](14, 2) NULL,
	[average_paid_amount] [decimal](14, 2) NULL,
	[our_total_commission_fee] [decimal](14, 2) NULL
);


-- temp tables for Factless FilmCategoryRelation
CREATE TABLE [dbo].[tmp_Factless_FilmCategoryRelation](
	[sk_film] [int] NOT NULL,
	[film_id] [int] NOT NULL,             
	[category_id] [tinyint] NOT NULL
);