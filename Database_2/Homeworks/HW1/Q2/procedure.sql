USE BankTransactions;
GO

--Drop the SecondTypeOfTransactions procedure--
IF OBJECT_ID('SecondTypeOfTransactions', 'P') IS NOT NULL
    DROP PROCEDURE SecondTypeOfTransactions;
GO


--SecondTypeOfTransactions procedure--
CREATE PROCEDURE SecondTypeOfTransactions
AS
BEGIN

    CREATE TABLE Temp(
        VoucherId varchar(21),
        TrnDate date,
        TrnTime varchar(6),
        Amount bigint,
        SourceDep int,
        DesDep int
	);

    INSERT INTO Temp (VoucherId, TrnDate, TrnTime, Amount, SourceDep, DesDep)
    SELECT STRING_AGG(VoucherId, ' | '), TrnDate, TrnTime, Amount, SourceDep, DesDep
    FROM Trn_Src_Des
    GROUP BY TrnDate, TrnTime, Amount, SourceDep, DesDep;

    DELETE FROM Trn_Src_Des;

    INSERT INTO Trn_Src_Des (VoucherId, TrnDate, TrnTime, Amount, SourceDep, DesDep)
    SELECT VoucherId, TrnDate, TrnTime, Amount, SourceDep, DesDep 
	FROM Temp;

    DROP TABLE Temp;

END;



EXEC SecondTypeOfTransactions;

SELECT * FROM Trn_Src_Des


