alter database HW_2 add filegroup [FGArchive]
go 			   
alter database HW_2 add filegroup [FG20200101]
go 			   
alter database HW_2 add filegroup [FG20200102]
go 			   
alter database HW_2 add filegroup [FG20200103]
go 			   
alter database HW_2 add filegroup [FG20200104]
go 			   
alter database HW_2 add filegroup [FG20200105]
go 			   
alter database HW_2 add filegroup [FG20200106]
go 			   
alter database HW_2 add filegroup [FG20200107]
go 			   
alter database HW_2 add filegroup [FG20200108]
go 			   
alter database HW_2 add filegroup [FG20200109]
go 			   
alter database HW_2 add filegroup [FG20200110]
go 



alter database HW_2 add file
(name = N'paymentArchive', 
filename = N'D:\IUT\term 8\DB 2\HW2\HW2\Partiotions\paymentArchive.ndf', size = 2048KB) to filegroup [FGArchive] 
go


alter database HW_2 add file
(name = N'Payment_FG20200101', 
filename = N'D:\IUT\term 8\DB 2\HW2\HW2\Partiotions\Payment_FG20200101.ndf', size = 2048KB) to filegroup [FG20200101] 
go


alter database HW_2 add file
(name = N'Payment_FG20200102', 
filename = N'D:\IUT\term 8\DB 2\HW2\HW2\Partiotions\Payment_FG20200102.ndf', size = 2048KB) to filegroup [FG20200102] 
go


alter database HW_2 add file
(name = N'Payment_FG20200103', 
filename = N'D:\IUT\term 8\DB 2\HW2\HW2\Partiotions\Payment_FG20200103.ndf', size = 2048KB) to filegroup [FG20200103] 
go


alter database HW_2 add file
(name = N'Payment_FG20200104', 
filename = N'D:\IUT\term 8\DB 2\HW2\HW2\Partiotions\Payment_FG20200104.ndf', size = 2048KB) to filegroup [FG20200104] 
go


alter database HW_2 add file
(name = N'Payment_FG20200105', 
filename = N'D:\IUT\term 8\DB 2\HW2\HW2\Partiotions\Payment_FG20200105.ndf', size = 2048KB) to filegroup [FG20200105] 
go


alter database HW_2 add file
(name = N'Payment_FG20200106', 
filename = N'D:\IUT\term 8\DB 2\HW2\HW2\Partiotions\Payment_FG20200106.ndf', size = 2048KB) to filegroup [FG20200106] 
go


alter database HW_2 add file
(name = N'Payment_FG20200107', 
filename = N'D:\IUT\term 8\DB 2\HW2\HW2\Partiotions\Payment_FG20200107.ndf', size = 2048KB) to filegroup [FG20200107] 
go


alter database HW_2 add file
(name = N'Payment_FG20200108', 
filename = N'D:\IUT\term 8\DB 2\HW2\HW2\Partiotions\Payment_FG20200108.ndf', size = 2048KB) to filegroup [FG20200108] 
go


alter database HW_2 add file
(name = N'Payment_FG20200109', 
filename = N'D:\IUT\term 8\DB 2\HW2\HW2\Partiotions\Payment_FG20200109.ndf', size = 2048KB) to filegroup [FG20200109] 
go


alter database HW_2 add file
(name = N'Payment_FG20200110', 
filename = N'D:\IUT\term 8\DB 2\HW2\HW2\Partiotions\Payment_FG20200110.ndf', size = 2048KB) to filegroup [FG20200110] 
go


use HW_2
go

create partition function pf_orderdatekey(int)
as range left 
for values(20191231, 20200101, 20200102, 20200103, 20200104, 20200105, 20200106, 20200107, 20200108, 20200109)
Go



create partition scheme ps_orderdatekey
as partition pf_orderdatekey  
to([FGArchive], [FG20200101], [FG20200102], [FG20200103], [FG20200104], [FG20200105], [FG20200106], [FG20200107], [FG20200108], [FG20200109], [FG20200110])
Go


--We had created table Fact_daily_BankPayment in another file, so we drop it first and then create it again
drop TABLE [dbo].[Fact_daily_BankPayment]


CREATE TABLE [dbo].[Fact_daily_BankPayment](
	[FacilitySubtype] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[PaymentDate] [int] NOT NULL,
	[Total_Amount] [decimal](10, 2) NOT NULL,
	[Avg_Amount] [decimal](10, 2) NOT NULL,
	[Max_Amount] [decimal](10, 2) NOT NULL,
	[Min_Amount] [decimal](10, 2) NOT NULL,
	[DaysWithoutPayment] [int] NOT NULL 
	constraint [pk_ Fact_daily_BankPayment] primary key nonclustered 
	(
		[FacilitySubtype], [BranchID],  [PaymentDate]
	)
) ON ps_orderdatekey(PaymentDate)
go


/*  ######################################### Sample Data for Fact_daily_BankPayment #############################################


INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 2, 20200101, CAST(6905.00 AS Decimal(10, 2)), CAST(1626.00 AS Decimal(10, 2)), CAST(9291.00 AS Decimal(10, 2)), CAST(6575.00 AS Decimal(10, 2)), 10)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (8, 3, 20200101, CAST(5759.00 AS Decimal(10, 2)), CAST(7345.00 AS Decimal(10, 2)), CAST(1810.00 AS Decimal(10, 2)), CAST(1194.00 AS Decimal(10, 2)), 3)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (9, 1, 20200101, CAST(5586.00 AS Decimal(10, 2)), CAST(3338.00 AS Decimal(10, 2)), CAST(7957.00 AS Decimal(10, 2)), CAST(8071.00 AS Decimal(10, 2)), 3)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (5, 5, 20200102, CAST(9588.00 AS Decimal(10, 2)), CAST(5524.00 AS Decimal(10, 2)), CAST(2242.00 AS Decimal(10, 2)), CAST(1717.00 AS Decimal(10, 2)), 7)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (8, 3, 20200102, CAST(5764.00 AS Decimal(10, 2)), CAST(7193.00 AS Decimal(10, 2)), CAST(8839.00 AS Decimal(10, 2)), CAST(6566.00 AS Decimal(10, 2)), 1)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (2, 1, 20200102, CAST(2925.00 AS Decimal(10, 2)), CAST(3653.00 AS Decimal(10, 2)), CAST(8658.00 AS Decimal(10, 2)), CAST(7923.00 AS Decimal(10, 2)), 7)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (7, 5, 20200102, CAST(4084.00 AS Decimal(10, 2)), CAST(9309.00 AS Decimal(10, 2)), CAST(3357.00 AS Decimal(10, 2)), CAST(7467.00 AS Decimal(10, 2)), 3)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (1, 2, 20200102, CAST(2302.00 AS Decimal(10, 2)), CAST(2674.00 AS Decimal(10, 2)), CAST(3750.00 AS Decimal(10, 2)), CAST(8017.00 AS Decimal(10, 2)), 5)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 3, 20200102, CAST(7758.00 AS Decimal(10, 2)), CAST(9454.00 AS Decimal(10, 2)), CAST(1077.00 AS Decimal(10, 2)), CAST(1743.00 AS Decimal(10, 2)), 3)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (4, 2, 20200103, CAST(9486.00 AS Decimal(10, 2)), CAST(2825.00 AS Decimal(10, 2)), CAST(9956.00 AS Decimal(10, 2)), CAST(2955.00 AS Decimal(10, 2)), 8)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (1, 3, 20200103, CAST(8536.00 AS Decimal(10, 2)), CAST(5094.00 AS Decimal(10, 2)), CAST(1214.00 AS Decimal(10, 2)), CAST(7983.00 AS Decimal(10, 2)), 8)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (4, 1, 20200103, CAST(3726.00 AS Decimal(10, 2)), CAST(5479.00 AS Decimal(10, 2)), CAST(6762.00 AS Decimal(10, 2)), CAST(1385.00 AS Decimal(10, 2)), 5)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (5, 2, 20200103, CAST(7432.00 AS Decimal(10, 2)), CAST(4949.00 AS Decimal(10, 2)), CAST(6714.00 AS Decimal(10, 2)), CAST(4568.00 AS Decimal(10, 2)), 9)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (3, 3, 20200103, CAST(2951.00 AS Decimal(10, 2)), CAST(9633.00 AS Decimal(10, 2)), CAST(6020.00 AS Decimal(10, 2)), CAST(9229.00 AS Decimal(10, 2)), 3)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (7, 1, 20200103, CAST(5073.00 AS Decimal(10, 2)), CAST(1337.00 AS Decimal(10, 2)), CAST(3586.00 AS Decimal(10, 2)), CAST(3953.00 AS Decimal(10, 2)), 2)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (5, 1, 20200103, CAST(2318.00 AS Decimal(10, 2)), CAST(7889.00 AS Decimal(10, 2)), CAST(3747.00 AS Decimal(10, 2)), CAST(6698.00 AS Decimal(10, 2)), 6)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 3, 20200103, CAST(6915.00 AS Decimal(10, 2)), CAST(6862.00 AS Decimal(10, 2)), CAST(8037.00 AS Decimal(10, 2)), CAST(5001.00 AS Decimal(10, 2)), 8)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (5, 4, 20200103, CAST(3710.00 AS Decimal(10, 2)), CAST(4472.00 AS Decimal(10, 2)), CAST(7721.00 AS Decimal(10, 2)), CAST(5015.00 AS Decimal(10, 2)), 4)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (7, 3, 20200103, CAST(1565.00 AS Decimal(10, 2)), CAST(3623.00 AS Decimal(10, 2)), CAST(8233.00 AS Decimal(10, 2)), CAST(2858.00 AS Decimal(10, 2)), 5)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (10, 3, 20200103, CAST(2918.00 AS Decimal(10, 2)), CAST(8405.00 AS Decimal(10, 2)), CAST(9333.00 AS Decimal(10, 2)), CAST(3535.00 AS Decimal(10, 2)), 1)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (5, 4, 20200104, CAST(5248.00 AS Decimal(10, 2)), CAST(1771.00 AS Decimal(10, 2)), CAST(3425.00 AS Decimal(10, 2)), CAST(4555.00 AS Decimal(10, 2)), 6)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (10, 2, 20200104, CAST(6909.00 AS Decimal(10, 2)), CAST(8689.00 AS Decimal(10, 2)), CAST(9809.00 AS Decimal(10, 2)), CAST(3490.00 AS Decimal(10, 2)), 2)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (4, 4, 20200104, CAST(2706.00 AS Decimal(10, 2)), CAST(6655.00 AS Decimal(10, 2)), CAST(7439.00 AS Decimal(10, 2)), CAST(5197.00 AS Decimal(10, 2)), 5)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 5, 20200104, CAST(2579.00 AS Decimal(10, 2)), CAST(7921.00 AS Decimal(10, 2)), CAST(1338.00 AS Decimal(10, 2)), CAST(2939.00 AS Decimal(10, 2)), 8)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 2, 20200104, CAST(5716.00 AS Decimal(10, 2)), CAST(1326.00 AS Decimal(10, 2)), CAST(3671.00 AS Decimal(10, 2)), CAST(9320.00 AS Decimal(10, 2)), 6)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (3, 5, 20200104, CAST(7863.00 AS Decimal(10, 2)), CAST(9263.00 AS Decimal(10, 2)), CAST(5099.00 AS Decimal(10, 2)), CAST(9306.00 AS Decimal(10, 2)), 4)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (7, 5, 20200104, CAST(4639.00 AS Decimal(10, 2)), CAST(3828.00 AS Decimal(10, 2)), CAST(8268.00 AS Decimal(10, 2)), CAST(2967.00 AS Decimal(10, 2)), 3)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (3, 2, 20200104, CAST(5119.00 AS Decimal(10, 2)), CAST(4840.00 AS Decimal(10, 2)), CAST(4948.00 AS Decimal(10, 2)), CAST(1305.00 AS Decimal(10, 2)), 10)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (7, 1, 20200105, CAST(7354.00 AS Decimal(10, 2)), CAST(3431.00 AS Decimal(10, 2)), CAST(4415.00 AS Decimal(10, 2)), CAST(9703.00 AS Decimal(10, 2)), 3)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (8, 1, 20200105, CAST(4748.00 AS Decimal(10, 2)), CAST(4592.00 AS Decimal(10, 2)), CAST(8721.00 AS Decimal(10, 2)), CAST(4275.00 AS Decimal(10, 2)), 1)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (7, 3, 20200105, CAST(7893.00 AS Decimal(10, 2)), CAST(5027.00 AS Decimal(10, 2)), CAST(7969.00 AS Decimal(10, 2)), CAST(8718.00 AS Decimal(10, 2)), 2)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (3, 5, 20200105, CAST(3865.00 AS Decimal(10, 2)), CAST(7473.00 AS Decimal(10, 2)), CAST(2498.00 AS Decimal(10, 2)), CAST(1661.00 AS Decimal(10, 2)), 2)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 4, 20200105, CAST(9908.00 AS Decimal(10, 2)), CAST(8168.00 AS Decimal(10, 2)), CAST(6782.00 AS Decimal(10, 2)), CAST(1190.00 AS Decimal(10, 2)), 3)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (4, 4, 20200105, CAST(8653.00 AS Decimal(10, 2)), CAST(6133.00 AS Decimal(10, 2)), CAST(2076.00 AS Decimal(10, 2)), CAST(7299.00 AS Decimal(10, 2)), 10)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 5, 20200105, CAST(2867.00 AS Decimal(10, 2)), CAST(9516.00 AS Decimal(10, 2)), CAST(5215.00 AS Decimal(10, 2)), CAST(5176.00 AS Decimal(10, 2)), 9)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (10, 4, 20200105, CAST(6534.00 AS Decimal(10, 2)), CAST(7689.00 AS Decimal(10, 2)), CAST(6250.00 AS Decimal(10, 2)), CAST(5391.00 AS Decimal(10, 2)), 1)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (3, 4, 20200105, CAST(6721.00 AS Decimal(10, 2)), CAST(4538.00 AS Decimal(10, 2)), CAST(8242.00 AS Decimal(10, 2)), CAST(7900.00 AS Decimal(10, 2)), 2)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (9, 5, 20200105, CAST(3067.00 AS Decimal(10, 2)), CAST(2495.00 AS Decimal(10, 2)), CAST(8053.00 AS Decimal(10, 2)), CAST(5683.00 AS Decimal(10, 2)), 7)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (4, 3, 20200105, CAST(8473.00 AS Decimal(10, 2)), CAST(3880.00 AS Decimal(10, 2)), CAST(4587.00 AS Decimal(10, 2)), CAST(2645.00 AS Decimal(10, 2)), 4)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (4, 2, 20200106, CAST(7959.00 AS Decimal(10, 2)), CAST(7052.00 AS Decimal(10, 2)), CAST(1754.00 AS Decimal(10, 2)), CAST(9245.00 AS Decimal(10, 2)), 9)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (2, 5, 20200106, CAST(2317.00 AS Decimal(10, 2)), CAST(6549.00 AS Decimal(10, 2)), CAST(6748.00 AS Decimal(10, 2)), CAST(3566.00 AS Decimal(10, 2)), 4)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (9, 2, 20200106, CAST(7945.00 AS Decimal(10, 2)), CAST(5171.00 AS Decimal(10, 2)), CAST(6092.00 AS Decimal(10, 2)), CAST(4450.00 AS Decimal(10, 2)), 10)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (8, 3, 20200106, CAST(1316.00 AS Decimal(10, 2)), CAST(7789.00 AS Decimal(10, 2)), CAST(4147.00 AS Decimal(10, 2)), CAST(9299.00 AS Decimal(10, 2)), 1)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (3, 1, 20200106, CAST(6140.00 AS Decimal(10, 2)), CAST(6924.00 AS Decimal(10, 2)), CAST(5399.00 AS Decimal(10, 2)), CAST(8826.00 AS Decimal(10, 2)), 4)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (10, 3, 20200106, CAST(8256.00 AS Decimal(10, 2)), CAST(6643.00 AS Decimal(10, 2)), CAST(1365.00 AS Decimal(10, 2)), CAST(5245.00 AS Decimal(10, 2)), 1)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 4, 20200106, CAST(4638.00 AS Decimal(10, 2)), CAST(4338.00 AS Decimal(10, 2)), CAST(8897.00 AS Decimal(10, 2)), CAST(8100.00 AS Decimal(10, 2)), 10)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 1, 20200106, CAST(5496.00 AS Decimal(10, 2)), CAST(4499.00 AS Decimal(10, 2)), CAST(8976.00 AS Decimal(10, 2)), CAST(5488.00 AS Decimal(10, 2)), 6)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (5, 1, 20200107, CAST(3256.00 AS Decimal(10, 2)), CAST(7383.00 AS Decimal(10, 2)), CAST(6182.00 AS Decimal(10, 2)), CAST(4097.00 AS Decimal(10, 2)), 5)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (1, 4, 20200107, CAST(9349.00 AS Decimal(10, 2)), CAST(1025.00 AS Decimal(10, 2)), CAST(4637.00 AS Decimal(10, 2)), CAST(2655.00 AS Decimal(10, 2)), 1)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (5, 3, 20200107, CAST(1160.00 AS Decimal(10, 2)), CAST(1467.00 AS Decimal(10, 2)), CAST(3366.00 AS Decimal(10, 2)), CAST(5838.00 AS Decimal(10, 2)), 4)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (9, 4, 20200107, CAST(3205.00 AS Decimal(10, 2)), CAST(2445.00 AS Decimal(10, 2)), CAST(8791.00 AS Decimal(10, 2)), CAST(3760.00 AS Decimal(10, 2)), 1)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (7, 3, 20200107, CAST(6059.00 AS Decimal(10, 2)), CAST(6880.00 AS Decimal(10, 2)), CAST(6781.00 AS Decimal(10, 2)), CAST(5143.00 AS Decimal(10, 2)), 10)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (9, 2, 20200107, CAST(7139.00 AS Decimal(10, 2)), CAST(6280.00 AS Decimal(10, 2)), CAST(6278.00 AS Decimal(10, 2)), CAST(3599.00 AS Decimal(10, 2)), 2)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (2, 2, 20200107, CAST(7539.00 AS Decimal(10, 2)), CAST(4045.00 AS Decimal(10, 2)), CAST(9999.00 AS Decimal(10, 2)), CAST(9816.00 AS Decimal(10, 2)), 5)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (8, 3, 20200107, CAST(3938.00 AS Decimal(10, 2)), CAST(9309.00 AS Decimal(10, 2)), CAST(2420.00 AS Decimal(10, 2)), CAST(9305.00 AS Decimal(10, 2)), 9)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (7, 4, 20200107, CAST(5106.00 AS Decimal(10, 2)), CAST(9727.00 AS Decimal(10, 2)), CAST(1344.00 AS Decimal(10, 2)), CAST(8373.00 AS Decimal(10, 2)), 10)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 3, 20200107, CAST(1509.00 AS Decimal(10, 2)), CAST(7609.00 AS Decimal(10, 2)), CAST(1627.00 AS Decimal(10, 2)), CAST(5254.00 AS Decimal(10, 2)), 3)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (7, 2, 20200108, CAST(2320.00 AS Decimal(10, 2)), CAST(9777.00 AS Decimal(10, 2)), CAST(7178.00 AS Decimal(10, 2)), CAST(8504.00 AS Decimal(10, 2)), 10)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (2, 5, 20200108, CAST(3361.00 AS Decimal(10, 2)), CAST(1496.00 AS Decimal(10, 2)), CAST(7702.00 AS Decimal(10, 2)), CAST(5254.00 AS Decimal(10, 2)), 7)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (8, 1, 20200108, CAST(6996.00 AS Decimal(10, 2)), CAST(2639.00 AS Decimal(10, 2)), CAST(6239.00 AS Decimal(10, 2)), CAST(8054.00 AS Decimal(10, 2)), 6)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (10, 5, 20200108, CAST(1967.00 AS Decimal(10, 2)), CAST(1062.00 AS Decimal(10, 2)), CAST(8781.00 AS Decimal(10, 2)), CAST(8893.00 AS Decimal(10, 2)), 1)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 5, 20200108, CAST(8987.00 AS Decimal(10, 2)), CAST(5452.00 AS Decimal(10, 2)), CAST(1475.00 AS Decimal(10, 2)), CAST(1561.00 AS Decimal(10, 2)), 5)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (5, 5, 20200108, CAST(5594.00 AS Decimal(10, 2)), CAST(5695.00 AS Decimal(10, 2)), CAST(2226.00 AS Decimal(10, 2)), CAST(6891.00 AS Decimal(10, 2)), 3)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (2, 4, 20200108, CAST(2994.00 AS Decimal(10, 2)), CAST(6914.00 AS Decimal(10, 2)), CAST(2156.00 AS Decimal(10, 2)), CAST(9501.00 AS Decimal(10, 2)), 6)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (4, 2, 20200108, CAST(4575.00 AS Decimal(10, 2)), CAST(8820.00 AS Decimal(10, 2)), CAST(1769.00 AS Decimal(10, 2)), CAST(8616.00 AS Decimal(10, 2)), 5)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (8, 5, 20200108, CAST(6142.00 AS Decimal(10, 2)), CAST(8171.00 AS Decimal(10, 2)), CAST(2481.00 AS Decimal(10, 2)), CAST(9435.00 AS Decimal(10, 2)), 2)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (4, 5, 20200108, CAST(1235.00 AS Decimal(10, 2)), CAST(4850.00 AS Decimal(10, 2)), CAST(7394.00 AS Decimal(10, 2)), CAST(4785.00 AS Decimal(10, 2)), 8)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (9, 2, 20200108, CAST(8708.00 AS Decimal(10, 2)), CAST(7709.00 AS Decimal(10, 2)), CAST(5310.00 AS Decimal(10, 2)), CAST(4871.00 AS Decimal(10, 2)), 9)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (8, 1, 20200109, CAST(3452.00 AS Decimal(10, 2)), CAST(2479.00 AS Decimal(10, 2)), CAST(6432.00 AS Decimal(10, 2)), CAST(6317.00 AS Decimal(10, 2)), 9)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (5, 3, 20200109, CAST(1492.00 AS Decimal(10, 2)), CAST(2279.00 AS Decimal(10, 2)), CAST(1343.00 AS Decimal(10, 2)), CAST(6310.00 AS Decimal(10, 2)), 1)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (3, 5, 20200109, CAST(9327.00 AS Decimal(10, 2)), CAST(4502.00 AS Decimal(10, 2)), CAST(7935.00 AS Decimal(10, 2)), CAST(9722.00 AS Decimal(10, 2)), 9)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 4, 20200109, CAST(9984.00 AS Decimal(10, 2)), CAST(6813.00 AS Decimal(10, 2)), CAST(4589.00 AS Decimal(10, 2)), CAST(5112.00 AS Decimal(10, 2)), 1)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (3, 2, 20200109, CAST(5358.00 AS Decimal(10, 2)), CAST(8207.00 AS Decimal(10, 2)), CAST(2124.00 AS Decimal(10, 2)), CAST(5685.00 AS Decimal(10, 2)), 6)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (10, 3, 20200109, CAST(2825.00 AS Decimal(10, 2)), CAST(4467.00 AS Decimal(10, 2)), CAST(1964.00 AS Decimal(10, 2)), CAST(6065.00 AS Decimal(10, 2)), 10)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (7, 5, 20200109, CAST(3537.00 AS Decimal(10, 2)), CAST(2476.00 AS Decimal(10, 2)), CAST(1179.00 AS Decimal(10, 2)), CAST(4827.00 AS Decimal(10, 2)), 7)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (1, 2, 20200109, CAST(4259.00 AS Decimal(10, 2)), CAST(6020.00 AS Decimal(10, 2)), CAST(2849.00 AS Decimal(10, 2)), CAST(9998.00 AS Decimal(10, 2)), 5)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (8, 4, 20200109, CAST(5643.00 AS Decimal(10, 2)), CAST(2392.00 AS Decimal(10, 2)), CAST(3824.00 AS Decimal(10, 2)), CAST(4865.00 AS Decimal(10, 2)), 6)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (9, 1, 20200109, CAST(2322.00 AS Decimal(10, 2)), CAST(4423.00 AS Decimal(10, 2)), CAST(6562.00 AS Decimal(10, 2)), CAST(8945.00 AS Decimal(10, 2)), 5)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (9, 2, 20200109, CAST(4456.00 AS Decimal(10, 2)), CAST(8477.00 AS Decimal(10, 2)), CAST(6086.00 AS Decimal(10, 2)), CAST(2558.00 AS Decimal(10, 2)), 1)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (7, 3, 20200110, CAST(1129.00 AS Decimal(10, 2)), CAST(6863.00 AS Decimal(10, 2)), CAST(5345.00 AS Decimal(10, 2)), CAST(4503.00 AS Decimal(10, 2)), 3)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (3, 2, 20200110, CAST(6103.00 AS Decimal(10, 2)), CAST(9344.00 AS Decimal(10, 2)), CAST(2681.00 AS Decimal(10, 2)), CAST(4703.00 AS Decimal(10, 2)), 6)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 2, 20200110, CAST(2249.00 AS Decimal(10, 2)), CAST(8021.00 AS Decimal(10, 2)), CAST(2813.00 AS Decimal(10, 2)), CAST(2894.00 AS Decimal(10, 2)), 2)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (9, 2, 20200110, CAST(4011.00 AS Decimal(10, 2)), CAST(2753.00 AS Decimal(10, 2)), CAST(7339.00 AS Decimal(10, 2)), CAST(6447.00 AS Decimal(10, 2)), 4)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (8, 3, 20200110, CAST(5261.00 AS Decimal(10, 2)), CAST(6232.00 AS Decimal(10, 2)), CAST(6107.00 AS Decimal(10, 2)), CAST(7977.00 AS Decimal(10, 2)), 4)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (1, 3, 20200110, CAST(2100.00 AS Decimal(10, 2)), CAST(1737.00 AS Decimal(10, 2)), CAST(9155.00 AS Decimal(10, 2)), CAST(4988.00 AS Decimal(10, 2)), 1)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (1, 2, 20200110, CAST(9541.00 AS Decimal(10, 2)), CAST(2369.00 AS Decimal(10, 2)), CAST(1868.00 AS Decimal(10, 2)), CAST(5699.00 AS Decimal(10, 2)), 8)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (2, 1, 20200110, CAST(5654.00 AS Decimal(10, 2)), CAST(2572.00 AS Decimal(10, 2)), CAST(1374.00 AS Decimal(10, 2)), CAST(4554.00 AS Decimal(10, 2)), 7)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (9, 4, 20200110, CAST(8448.00 AS Decimal(10, 2)), CAST(3281.00 AS Decimal(10, 2)), CAST(2675.00 AS Decimal(10, 2)), CAST(5942.00 AS Decimal(10, 2)), 10)
GO
INSERT [dbo].[Fact_daily_BankPayment] ([FacilitySubtype], [BranchID], [PaymentDate], [Total_Amount], [Avg_Amount], [Max_Amount], [Min_Amount], [DaysWithoutPayment]) VALUES (6, 1, 20200110, CAST(3314.00 AS Decimal(10, 2)), CAST(7504.00 AS Decimal(10, 2)), CAST(4556.00 AS Decimal(10, 2)), CAST(6634.00 AS Decimal(10, 2)), 1)
GO


*/




--############# Number of records per partition ############:
SELECT DISTINCT 
 p.partition_number as [Partition], 
 s.name, 
 o.name, 
 fg.name AS [Filegroup], 
 p.rows 
FROM sys.partitions p 
 INNER JOIN sys.allocation_units au ON au.container_id = p.hobt_id 
 INNER JOIN sys.filegroups fg ON fg.data_space_id = au.data_space_id 
 INNER JOIN  sys.objects o ON o.object_id = p.object_id 
 INNER JOIN sys.schemas s ON s.schema_id = o.schema_id 
WHERE o.type = 'U' 
AND o.name = 'Fact_daily_BankPayment' 
ORDER BY 
 o.name, 
 fg.name, 
 s.name




--############# Data size per partition ############:
SELECT 
    p.partition_number,
    ps.name AS partition_scheme,
    pf.name AS partition_function,
    prv.value AS partition_range_value,
    SUM(a.total_pages) * 8 AS partition_size_kb
FROM 
    sys.partitions p
JOIN 
    sys.objects o ON p.object_id = o.object_id
JOIN 
    sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
JOIN 
    sys.partition_schemes ps ON i.data_space_id = ps.data_space_id
JOIN 
    sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN 
    sys.partition_range_values prv ON pf.function_id = prv.function_id AND prv.boundary_id = p.partition_number
JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
    o.name = 'Fact_daily_BankPayment'
GROUP BY 
    p.partition_number, ps.name, pf.name, prv.value
ORDER BY 
    p.partition_number;


