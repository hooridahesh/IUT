USE BankTransactions;
GO

INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('1', '2024-03-18', '080000', 1000, 101, 102);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('2', '2024-03-18', '080000', 1000, 101, 102);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('3', '2024-03-18', '083000', 750, 103, NULL);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('4', '2024-03-18', '090000', 2000, 104, 105);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('5', '2024-03-18', '091500', 1500, 105, 106);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('6', '2024-03-18', '091500', 1500, 105, 106);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('7', '2024-03-18', '100000', 3000, 107, NULL);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('8', '2024-03-18', '101500', 2500, 108, 109);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('9', '2024-03-18', '103000', 2750, 109, 110);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('10', '2024-03-18', '110000', 4000, 110, 111);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('11', '2024-03-18', '111500', 3500, 111, 112);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('12', '2024-03-18', '111500', 3500, 111, 112);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('13', '2024-03-18', '120000', 5000, 113, 114);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('14', '2024-03-18', '121500', 4500, 114, 115);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('15', '2024-03-18', '123000', 4750, NULL, 116);
INSERT INTO [dbo].[Trn_Src_Des] ([VoucherId], [TrnDate], [TrnTime], [Amount], [SourceDep], [DesDep]) VALUES ('16', '2024-03-18', '130000', 6000, 116, 117);


SELECT * FROM Trn_Src_Des