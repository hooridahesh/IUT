
create database HW_2
Go

USE [HW_2]
Go

--###################################### Data Warehouse Tables ########################################

--create table Dim_Branch
CREATE TABLE [dbo].[Dim_Branch](
	[BranchID] [int] NOT NULL PRIMARY KEY,
	[BranchName] [varchar](255) NOT NULL,
	[SupervisionID] [int] NOT NULL,
	[SupervisionDescription] [varchar](255) NOT NULL,
	[StateID] [int] NOT NULL,
	[StateDescription] [varchar](255) NOT NULL,
)

--create table Dim_Customer
CREATE TABLE [dbo].[Dim_Customer](
	[SK_Customer] [int] IDENTITY(1,1) NOT NULL primary key,
	[CustomerID] [int] NOT NULL,
	[CustomerName] [varchar](255) NOT NULL,
	[BranchID] [int] NOT NULL,
	[CustomerType] [int] NOT NULL,
	[CustomerTypeDescription] [varchar](255) NOT NULL,
	[NationalID] [varchar](10) NOT NULL,
	[PhoneNumber] [varchar](20) NOT NULL,
	[Job] [varchar](255) NOT NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NULL,
	[Current_Flag] [bit] NOT NULL
);

--create table Dim_Date
CREATE TABLE [dbo].[Dim_Date](
	[DateKey] [date] NOT NULL PRIMARY KEY,
	[Shamsi_DateKey] [date] NOT NULL,
	[Year] [varchar](50) NOT NULL,
	[Shamsi_Year] [varchar](50) NOT NULL,
	[Quarter] [varchar](50) NOT NULL,
	[Shamsi_Quarter] [varchar](50) NOT NULL,
	[Month] [varchar](50) NOT NULL,
	[Shamsi_Month] [varchar](50) NOT NULL,
	[WeekDay] [varchar](50) NOT NULL,
	[Shamsi_WeekDay] [varchar](50) NOT NULL,
)

--create table Dim_Facility
CREATE TABLE [dbo].[Dim_Facility](
	[FacilityNumber] [int] NOT NULL primary key,
	[FacilitySubtype] [int] NOT NULL,
	[FacilitySubtypeDescription] [varchar](255) NOT NULL,
	[FacilityType] [int] NOT NULL,
	[FacilityTypeDescription] [varchar](255) NOT NULL,
	[CustomerNumber] [int] NOT NULL,
	[CustomerName] [varchar](255) NOT NULL,
	[BranchID] [int] NOT NULL,
	[Currency] [int] NOT NULL,
	[CurrencyDescription] [varchar](255) NULL,
	[ApprovalDate] [date] NOT NULL,
	[Amount] [decimal](10, 2) NOT NULL,
	[FacilityDuration] [int] NOT NULL,
	[Status] [varchar](255) NOT NULL
)

--create table Dim_FacilityType
CREATE TABLE [dbo].[Dim_FacilityType](
	[FacilitySubtype] [int] NOT NULL PRIMARY KEY,
	[FacilitySubtypeDescription] [varchar](255) NOT NULL,
	[FacilityType] [int] NOT NULL,
	[FacilityTypeDescription] [varchar](255) NOT NULL,
)

--create table Dim_Installment
CREATE TABLE [dbo].[Dim_Installment](
	[FacilityNumber] [int] NOT NULL,
	[InstallmentNumber] [int] NOT NULL,
	[DueDate] [date] NOT NULL,
	[PrincipalAmount] [decimal](10, 2) NOT NULL,
	[InterestAmount] [decimal](10, 2) NOT NULL,
	[CustomerNumber] [int] NOT NULL,
	[Facility_Subtype] [int] NOT NULL,
	[Facility_Branch] [int] NOT NULL,
	[Facility_Currency] [int] NOT NULL,
	[Facility_ApprovalDate] [date] NOT NULL,
	[Facility_Amount] [decimal](10, 2) NOT NULL,
	[Facility_Duration] [int] NOT NULL,
	[Facility_Status] [varchar](255) NOT NULL,
	primary key([FacilityNumber], [InstallmentNumber])
)

--create table Dim_RelationType
CREATE TABLE [dbo].[Dim_RelationType](
	[RelationType] [int] NOT NULL PRIMARY KEY,
	[RelationTypeDescription] [varchar](255) NOT NULL,
)


--ACC Facts:

--create table ACC fact BankPayment
CREATE TABLE [dbo].[Fact_Acc_BankPayment](
	[FacilitySubtype] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[Total_Amount] [decimal](10, 2) NOT NULL,
	[Avg_Amount] [decimal](10, 2) NOT NULL,
	[Max_Amount] [decimal](10, 2) NOT NULL,
	[Min_Amount] [decimal](10, 2) NOT NULL,
	[DaysWithoutPayment] [int] NOT NULL
)

--create table ACC fact CustomerPayment
CREATE TABLE [dbo].[Fact_Acc_CustomerPayment](
	[FacilitySubtype] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[Total_PrincipalPayment] [decimal](10, 2) NOT NULL,
	[Total_InterestPayment] [decimal](10, 2) NOT NULL,
	[Total_FinesPayment] [decimal](10, 2) NOT NULL,
	[Remaining_Principal] [decimal](10, 2) NOT NULL,
	[Remaining_Interest] [decimal](10, 2) NOT NULL,
	[Remaining_Fines] [decimal](10, 2) NOT NULL,
	[Avg_PrincipalPayment] [decimal](10, 2) NOT NULL,
	[Avg_InterestPayment] [decimal](10, 2) NOT NULL,
	[Avg_FinesPayment] [decimal](10, 2) NOT NULL,
	[Max_PrincipalPayment] [decimal](10, 2) NOT NULL,
	[Max_InterestPayment] [decimal](10, 2) NOT NULL,
	[Max_FinesPayment] [decimal](10, 2) NOT NULL,
	[Min_PrincipalPayment] [decimal](10, 2) NOT NULL,
	[Min_InterestPayment] [decimal](10, 2) NOT NULL,
	[Min_FinesPayment] [decimal](10, 2) NOT NULL,
	[DaysWithoutPayment] [int] NOT NULL
)



--Daily Facts:


--create table daily fact BankPayment
CREATE TABLE [dbo].[Fact_daily_BankPayment](
	[FacilitySubtype] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[PaymentDate] [date] NOT NULL,
	[Total_Amount] [decimal](10, 2) NOT NULL,
	[Avg_Amount] [decimal](10, 2) NOT NULL,
	[Max_Amount] [decimal](10, 2) NOT NULL,
	[Min_Amount] [decimal](10, 2) NOT NULL,
	[DaysWithoutPayment] [int] NOT NULL
)

--create table daily fact CustomerPayment
CREATE TABLE [dbo].[Fact_Daily_CustomerPayment](
	[FacilitySubtype] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[PaymentDate] [date] NOT NULL,
	[Total_PrincipalPayment] [decimal](10, 2) NOT NULL,
	[Total_InterestPayment] [decimal](10, 2) NOT NULL,
	[Total_FinesPayment] [decimal](10, 2) NOT NULL,
	[Remaining_Principal] [decimal](10, 2) NOT NULL,
	[Remaining_Interest] [decimal](10, 2) NOT NULL,
	[Remaining_Fines] [decimal](10, 2) NOT NULL,
	[DaysWithoutPayment] [int] NOT NULL
)



-- Transaction Fact:

--create table daily fact BankPayment
CREATE TABLE [dbo].[Fact_Trn_BankPayment](
	[FacilityNumber] [int] NOT NULL,
	[FacilitySubtype] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[PaymentDate] [date] NOT NULL,
	[Amount] [decimal](10, 2) NOT NULL
)


--create table daily fact CustomerPayment
CREATE TABLE [dbo].[Fact_Trn_CustomerPayment](
	[FacilityNumber] [int] NOT NULL,
	[FacilitySubtype] [int] NOT NULL,
	[InstallmentNumber] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[PaymentDate] [date] NOT NULL,
	[PrincipalPayment] [decimal](10, 2) NOT NULL,
	[InterestPayment] [decimal](10, 2) NOT NULL,
	[FinesPayment] [decimal](10, 2) NOT NULL
)


--Factless Fact:

--create table factless CustomerFacilityRelation
CREATE TABLE [dbo].[Factless_CustomerFacilityRelation](
	[FacilityNumber] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[RelationType] [int] NOT NULL
)







--###################################### Temp Tables for DW ########################################

CREATE TABLE [dbo].[tmp_dim_customer](
	[SK_Customer] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[CustomerName] [varchar](255) NOT NULL,
	[BranchID] [int] NOT NULL,
	[CustomerType] [int] NOT NULL,
	[CustomerTypeDescription] [varchar](255) NOT NULL,
	[NationalID] [varchar](10) NOT NULL,
	[PhoneNumber] [varchar](20) NOT NULL,
	[Job] [varchar](255) NOT NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NULL,
	[Current_Flag] [bit] NOT NULL
)

CREATE TABLE [dbo].[tmp_changedJob_customer](
	[CustomerID] [int] NOT NULL primary key,
	[CustomerName] [varchar](255) NOT NULL,
	[BranchID] [int] NOT NULL,
	[CustomerType] [int] NOT NULL,
	[CustomerTypeDescription] [varchar](255) NOT NULL,
	[NationalID] [varchar](10) NOT NULL,
	[PhoneNumber] [varchar](20) NOT NULL,
	[Job] [varchar](255) NOT NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NULL,
	[Current_Flag] [bit] NOT NULL
)

CREATE TABLE [dbo].[tmp_dim_facility](
	[FacilityNumber] [int] NOT NULL primary key,
	[FacilitySubtype] [int] NULL,
	[FacilitySubtypeDescription] [varchar](255) NULL,
	[FacilityType] [int] NULL,
	[FacilityTypeDescription] [varchar](255) NULL,
	[CustomerNumber] [int] NULL,
	[CustomerName] [varchar](255) NULL,
	[BranchID] [int] NULL,
	[Currency] [int] NULL,
	[CurrencyDescription] [varchar](255) NULL,
	[ApprovalDate] [date] NULL,
	[Amount] [decimal](10, 2) NULL,
	[FacilityDuration] [int] NOT NULL,
	[Status] [varchar](255) NULL
)

CREATE TABLE [dbo].[tmp2_dim_facility](
	[FacilityNumber] [int] NOT NULL,
	[FacilitySubtype] [int] NULL,
	[FacilitySubtypeDescription] [varchar](255) NULL,
	[FacilityType] [int] NULL,
	[FacilityTypeDescription] [varchar](255) NULL,
	[CustomerNumber] [int] NULL,
	[BranchID] [int] NULL,
	[Currency] [int] NULL,
	[ApprovalDate] [date] NULL,
	[Amount] [decimal](10, 2) NULL,
	[FacilityDuration] [int] NOT NULL,
	[Status] [varchar](255) NULL
)

CREATE TABLE [dbo].[tmp3_dim_facility](
	[FacilityNumber] [int] NOT NULL,
	[FacilitySubtype] [int] NULL,
	[FacilitySubtypeDescription] [varchar](255) NULL,
	[FacilityType] [int] NULL,
	[FacilityTypeDescription] [varchar](255) NULL,
	[CustomerNumber] [int] NULL,
	[BranchID] [int] NULL,
	[Currency] [int] NULL,
	[CurrencyDescription] [varchar](255) NULL,
	[ApprovalDate] [date] NULL,
	[Amount] [decimal](10, 2) NULL,
	[FacilityDuration] [int] NOT NULL,
	[Status] [varchar](255) NULL
)







--###################################### Source Tables ########################################


-- Create State table
CREATE TABLE State (
  StateID INT PRIMARY KEY,
  StateDescription VARCHAR(255)
);

-- Create Supervision table
CREATE TABLE Supervision (
  SupervisionID INT PRIMARY KEY,
  SupervisionDescription VARCHAR(255),
  StateID INT,
  FOREIGN KEY (StateID) REFERENCES State(StateID)
);

-- Create Branch table
CREATE TABLE Branch (
  BranchID INT PRIMARY KEY,
  BranchName VARCHAR(255),
  SupervisionID INT,
  FOREIGN KEY (SupervisionID) REFERENCES Supervision(SupervisionID)
);

-- Create CustomerType table
CREATE TABLE CustomerType (
  CustomerType INT PRIMARY KEY,
  CustomerTypeDescription VARCHAR(255)
);

-- Create Customer table
CREATE TABLE Customer (
  CustomerID INT PRIMARY KEY,
  CustomerName VARCHAR(255),
  Branch INT,
  CustomerType INT,
  NationalID VARCHAR(10),
  Job VARCHAR(255),
  PhoneNumber VARCHAR(20),
  FOREIGN KEY (Branch) REFERENCES Branch(BranchID),
  FOREIGN KEY (CustomerType) REFERENCES CustomerType(CustomerType)
);

-- Create RelationType table
CREATE TABLE RelationType (
  RelationType INT PRIMARY KEY,
  RelationTypeDescription VARCHAR(255)
);

-- Create Currency table
CREATE TABLE Currency (
  CurrencyID INT PRIMARY KEY,
  CurrencyDescription VARCHAR(255)
);

-- Create FacilityType table
CREATE TABLE FacilityType (
  FacilitySubtype INT PRIMARY KEY,
  FacilitySubtypeDescription VARCHAR(255),
  FacilityType INT,
  FacilityTypeDescription VARCHAR(255)
);

-- Create Facility table
CREATE TABLE Facility (
  FacilityNumber INT PRIMARY KEY,
  CustomerNumber INT,
  FacilitySubtype INT,
  Branch INT,
  Currency INT,
  ApprovalDate DATE,
  Amount DECIMAL(10,2),
  FacilityDuration INT,
  [Status] VARCHAR(255),
  FOREIGN KEY (CustomerNumber) REFERENCES Customer(CustomerID),
  FOREIGN KEY (FacilitySubtype) REFERENCES FacilityType(FacilitySubtype),
  FOREIGN KEY (Branch) REFERENCES Branch(BranchID),
  FOREIGN KEY (Currency) REFERENCES Currency(CurrencyID)
);

-- Create Installment table
CREATE TABLE Installment (
  FacilityNumber INT,
  InstallmentNumber INT,
  DueDate DATE,
  PrincipalAmount DECIMAL(10,2),
  InterestAmount DECIMAL(10,2),
  PRIMARY KEY (FacilityNumber, InstallmentNumber),
  FOREIGN KEY (FacilityNumber) REFERENCES Facility(FacilityNumber)
);

-- Create CustomerFacilityRelationship table
CREATE TABLE CustomerFacilityRelationship (
  Customer INT,
  FacilityNumber INT,
  RelationshipType INT,
  PRIMARY KEY (Customer, FacilityNumber),
  FOREIGN KEY (Customer) REFERENCES Customer(CustomerID),
  FOREIGN KEY (FacilityNumber) REFERENCES Facility(FacilityNumber),
  FOREIGN KEY (RelationshipType) REFERENCES RelationType(RelationType)
);

-- Create BankPayment table
CREATE TABLE BankPayment (
  FacilityNumber INT,
  PaymentDate DATE,
  PaymentAmount DECIMAL(10,2),
  FOREIGN KEY (FacilityNumber) REFERENCES Facility(FacilityNumber)
);

-- Create CustomerPayment table
CREATE TABLE CustomerPayment (
  FacilityNumber INT,
  InstallmentNumber INT,
  PaymentDate DATE,
  Payment_of_Principal DECIMAL(10,2),
  Payment_of_Interest DECIMAL(10,2),
  Payment_of_Fines DECIMAL(10,2),
  FOREIGN KEY (FacilityNumber, InstallmentNumber) REFERENCES Installment(FacilityNumber, InstallmentNumber)
);


