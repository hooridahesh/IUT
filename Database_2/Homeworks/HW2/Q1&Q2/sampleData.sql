USE [HW_2]
GO
INSERT [dbo].[State] ([StateID], [StateDescription]) VALUES (1, N'California')
GO
INSERT [dbo].[State] ([StateID], [StateDescription]) VALUES (2, N'Texas')
GO
INSERT [dbo].[State] ([StateID], [StateDescription]) VALUES (3, N'New York')
GO
INSERT [dbo].[State] ([StateID], [StateDescription]) VALUES (4, N'Florida')
GO
INSERT [dbo].[State] ([StateID], [StateDescription]) VALUES (5, N'Illinois')
GO
INSERT [dbo].[Supervision] ([SupervisionID], [SupervisionDescription], [StateID]) VALUES (1, N'Supervision 1', 1)
GO
INSERT [dbo].[Supervision] ([SupervisionID], [SupervisionDescription], [StateID]) VALUES (2, N'Supervision 2', 2)
GO
INSERT [dbo].[Supervision] ([SupervisionID], [SupervisionDescription], [StateID]) VALUES (3, N'Supervision 3', 3)
GO
INSERT [dbo].[Supervision] ([SupervisionID], [SupervisionDescription], [StateID]) VALUES (4, N'Supervision 4', 4)
GO
INSERT [dbo].[Supervision] ([SupervisionID], [SupervisionDescription], [StateID]) VALUES (5, N'Supervision 5', 5)
GO
INSERT [dbo].[Branch] ([BranchID], [BranchName], [SupervisionID]) VALUES (1, N'Main Headquarters', 1)
GO
INSERT [dbo].[Branch] ([BranchID], [BranchName], [SupervisionID]) VALUES (2, N'Florida Branch', 4)
GO
INSERT [dbo].[Branch] ([BranchID], [BranchName], [SupervisionID]) VALUES (3, N'California Branch', 1)
GO
INSERT [dbo].[Branch] ([BranchID], [BranchName], [SupervisionID]) VALUES (4, N'Texas Office', 2)
GO
INSERT [dbo].[Branch] ([BranchID], [BranchName], [SupervisionID]) VALUES (5, N'New York Branch', 3)
GO
INSERT [dbo].[CustomerType] ([CustomerType], [CustomerTypeDescription]) VALUES (1, N'CType 1')
GO
INSERT [dbo].[CustomerType] ([CustomerType], [CustomerTypeDescription]) VALUES (2, N'CType 2')
GO
INSERT [dbo].[CustomerType] ([CustomerType], [CustomerTypeDescription]) VALUES (3, N'CType 3')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (1, N'John Smith', 1, 1, N'1234567890', N'Teacher', N'+1234567890')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (2, N'Alice Jones', 2, 2, N'0987654321', N'Marketing Manager', N'+1987654321')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (3, N'David Lee', 3, 1, N'9876543210', N'Accountant', N'+1876543210')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (4, N'Emily Brown', 4, 3, N'8765432109', N'Teacher', N'+1765432109')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (5, N'Michael Garcia', 5, 2, N'7654321098', N'Doctor', N'+1654321098')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (6, N'Sarah Miller', 1, 2, N'6543210987', N'Web Developer', N'+1543210987')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (7, N'William Davis', 2, 1, N'5432109876', N'Sales Representative', N'+1432109876')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (8, N'Jennifer Hernandez', 3, 3, N'4321098765', N'Lawyer', N'+1321098765')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (9, N'Charles Anderson', 4, 3, N'3210987654', N'Police Officer', N'+1210987654')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (10, N'Elizabeth Moore', 5, 2, N'2109876543', N'Nurse', N'+1109876543')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (11, N'Mary Wilson', 1, 1, N'1098765432', N'Graphic Designer', N'+1098765432')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (12, N'Steven Parker', 2, 2, N'0987654321', N'Project Manager', N'+1987654320')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (13, N'Patricia Garcia', 3, 1, N'9876543210', N'HR Specialist', N'+1876543209')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (14, N'Mark Robinson', 4, 3, N'8765432109', N'Software Developer', N'+1765432087')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (15, N'Linda Taylor', 5, 2, N'7654321098', N'Financial Analyst', N'+1654320865')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (16, N'James Johnson', 1, 2, N'6543210987', N'Marketing Specialist', N'+1543210864')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (17, N'Dorothy Walker', 2, 1, N'5432109876', N'Data Analyst', N'+1432108643')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (18, N'Paul Thompson', 3, 3, N'4321098765', N'Network Engineer', N'+1321086432')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (19, N'Barbara Moore', 4, 1, N'3210987654', N'System Administrator', N'+1210864321')
GO
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [Branch], [CustomerType], [NationalID], [Job], [PhoneNumber]) VALUES (20, N'David Lee', 5, 2, N'2109876543', N'Business Analyst', N'+1108643210')
GO
INSERT [dbo].[FacilityType] ([FacilitySubtype], [FacilitySubtypeDescription], [FacilityType], [FacilityTypeDescription]) VALUES (1, N'sub type 1', 1, N'type 1')
GO
INSERT [dbo].[FacilityType] ([FacilitySubtype], [FacilitySubtypeDescription], [FacilityType], [FacilityTypeDescription]) VALUES (2, N'sub type 2', 2, N'type 2')
GO
INSERT [dbo].[FacilityType] ([FacilitySubtype], [FacilitySubtypeDescription], [FacilityType], [FacilityTypeDescription]) VALUES (3, N'sub type 3', 1, N'type 1')
GO
INSERT [dbo].[FacilityType] ([FacilitySubtype], [FacilitySubtypeDescription], [FacilityType], [FacilityTypeDescription]) VALUES (4, N'sub type 4', 2, N'type 2')
GO
INSERT [dbo].[Currency] ([CurrencyID], [CurrencyDescription]) VALUES (1, N'USD')
GO
INSERT [dbo].[Currency] ([CurrencyID], [CurrencyDescription]) VALUES (2, N'EUR')
GO
INSERT [dbo].[Currency] ([CurrencyID], [CurrencyDescription]) VALUES (3, N'Rial')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (1, 1, 1, 1, 1, CAST(N'2023-10-04' AS Date), CAST(20000.00 AS Decimal(10, 2)), 20, N'Approved')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (2, 2, 2, 2, 2, CAST(N'2024-02-15' AS Date), CAST(25000.00 AS Decimal(10, 2)), 18, N'Active')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (3, 3, 3, 1, 1, CAST(N'2023-05-22' AS Date), CAST(5000.00 AS Decimal(10, 2)), 6, N'Past Due')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (4, 4, 4, 3, 1, CAST(N'2024-01-10' AS Date), CAST(12000.00 AS Decimal(10, 2)), 24, N'Delinquent')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (5, 5, 3, 4, 2, CAST(N'2022-12-28' AS Date), CAST(7500.00 AS Decimal(10, 2)), 36, N'Suspicious')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (6, 6, 2, 2, 1, CAST(N'2024-03-07' AS Date), CAST(30000.00 AS Decimal(10, 2)), 12, N'Settled')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (7, 7, 1, 1, 1, CAST(N'2023-11-14' AS Date), CAST(8000.00 AS Decimal(10, 2)), 12, N'Approved')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (8, 8, 2, 2, 2, CAST(N'2024-04-19' AS Date), CAST(15000.00 AS Decimal(10, 2)), 18, N'Active')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (9, 9, 3, 3, 1, CAST(N'2023-06-29' AS Date), CAST(3000.00 AS Decimal(10, 2)), 6, N'Past Due')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (10, 10, 4, 4, 2, CAST(N'2024-02-24' AS Date), CAST(9000.00 AS Decimal(10, 2)), 24, N'Delinquent')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (11, 11, 2, 1, 2, CAST(N'2024-05-10' AS Date), CAST(4500.00 AS Decimal(10, 2)), 36, N'Active')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (12, 12, 1, 3, 1, CAST(N'2023-09-07' AS Date), CAST(15000.00 AS Decimal(10, 2)), 12, N'Approved')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (13, 13, 2, 2, 1, CAST(N'2024-03-21' AS Date), CAST(32000.00 AS Decimal(10, 2)), 18, N'Active')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (14, 14, 4, 4, 2, CAST(N'2023-12-12' AS Date), CAST(20000.00 AS Decimal(10, 2)), 24, N'Closed')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (15, 1, 3, 5, 1, CAST(N'2024-04-26' AS Date), CAST(6500.00 AS Decimal(10, 2)), 6, N'Approved')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (16, 9, 4, 3, 2, CAST(N'2024-05-17' AS Date), CAST(18000.00 AS Decimal(10, 2)), 24, N'Restructured')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (17, 5, 2, 1, 1, CAST(N'2024-02-08' AS Date), CAST(40000.00 AS Decimal(10, 2)), 18, N'Active')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (18, 15, 3, 5, 2, CAST(N'2024-01-31' AS Date), CAST(8500.00 AS Decimal(10, 2)), 12, N'Approved')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (19, 3, 1, 4, 1, CAST(N'2023-07-19' AS Date), CAST(9500.00 AS Decimal(10, 2)), 12, N'Approved')
GO
INSERT [dbo].[Facility] ([FacilityNumber], [CustomerNumber], [FacilitySubtype], [Branch], [Currency], [ApprovalDate], [Amount], [FacilityDuration], [Status]) VALUES (20, 6, 1, 2, 2, CAST(N'2024-05-22' AS Date), CAST(11000.00 AS Decimal(10, 2)), 36, N'Active')
GO
INSERT [dbo].[RelationType] ([RelationType], [RelationTypeDescription]) VALUES (1, N'R1')
GO
INSERT [dbo].[RelationType] ([RelationType], [RelationTypeDescription]) VALUES (2, N'R2')
GO