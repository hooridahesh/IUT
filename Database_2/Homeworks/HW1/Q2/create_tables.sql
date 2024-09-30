--DROP DATABASE IF EXISTS BankTransactionsh;

CREATE DATABASE BankTransactions;

USE BankTransactions;
GO


--Drop the Trn_Src_Des Table--
IF OBJECT_ID('Trn_Src_Des', 'U') IS NOT NULL
    DROP TABLE Trn_Src_Des;


--Trn_Src_Des Table--
CREATE TABLE [dbo].[Trn_Src_Des](
	[VoucherId] [varchar](21) NULL,
	[TrnDate] [date] NULL,
	[TrnTime] [varchar](6) NULL,
	[Amount] [bigint] NULL,
	[SourceDep] [int] NULL,
	[DesDep] [int] NULL
);


