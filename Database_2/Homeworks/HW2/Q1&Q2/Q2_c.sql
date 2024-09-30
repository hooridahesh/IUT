USE [HW_2]
Go

create procedure ins_DimCustomer
as
begin
	
	SET IDENTITY_INSERT Dim_Customer OFF
	SET IDENTITY_INSERT tmp_dim_customer OFF

	SET IDENTITY_INSERT tmp_dim_Customer ON

	--if tmp_dim_customer is not empty and Dim_Customer is empty we realize that a problem occurred in the previous execution of this procedure.
	if (not (exists(select CustomerID from tmp_dim_customer) and not exists(select CustomerID from Dim_Customer)))
	begin
		--truncate tmp customeer tables:
		truncate table tmp_dim_customer
		truncate table tmp_changedJob_customer


		-- copy Dim_Customer to tmp_dim_customer
		insert into tmp_dim_customer(SK_Customer ,CustomerID, CustomerName, BranchID, 
				CustomerType, CustomerTypeDescription, NationalID, PhoneNumber,
				Job, Start_Date, End_Date, Current_Flag)			
		select 
			SK_Customer,
			CustomerID, 
			CustomerName, 
			BranchID, 
			CustomerType, 
			CustomerTypeDescription, 
			NationalID, 
			PhoneNumber,
			Job, 
			Start_Date, 
			End_Date, 
			Current_Flag
		from Dim_Customer


		--truncate  Dimension Customer
		truncate table Dim_Customer

		--insert all customers whoes changed thier last job to tmp_changedJob_customer table
		insert into tmp_changedJob_customer
		select t1.CustomerID, 
			t1.CustomerName, 
			t1.BranchID, 
			t1.CustomerType, 
			t1.CustomerTypeDescription, 
			t1.NationalID, 
			t1.PhoneNumber,
			t2.Job, 
			Start_Date,
			End_Date,
			Current_Flag
		from tmp_dim_customer t1 join Customer t2
		on(t1.CustomerID = t2.CustomerID)
		where t1.Job <> t2.Job and t1.Current_Flag = 1


		--Updating the tmp_dim_customer table to handle customers whose jobs have changed with SCD2
		update tmp_dim_customer
		set Current_Flag = 0,  End_Date = GETDATE()
		where NationalID in (select NationalID 
							from tmp_changedJob_customer)
			and Current_Flag = 1


		SET IDENTITY_INSERT tmp_dim_Customer OFF


		--insert a record for each customer whoes changed thier last job with Current_Flag = 1
		insert into tmp_dim_customer
		select 
			CustomerID, 
			CustomerName, 
			BranchID, 
			CustomerType, 
			CustomerTypeDescription, 
			NationalID, 
			PhoneNumber,
			Job, 
			GETDATE(), 
			null, 
			1
		from tmp_changedJob_customer


		--insert new customer
		insert into tmp_dim_customer
		select t1.CustomerID, 
			t1.CustomerName, 
			t1.Branch, 
			t1.CustomerType, 
			t2.CustomerTypeDescription, 
			t1.NationalID, 
			t1.PhoneNumber,
			t1.Job, 
			GETDATE(), 
			null, 
			1
		from Customer t1 join CustomerType t2  --The customer and CustomerType tables are for the source
		on(t1.CustomerType = t2.CustomerType)
		where t1.CustomerID not in (select CustomerID
									from tmp_dim_customer)
			
			
		SET IDENTITY_INSERT Dim_Customer ON


		--Last insert for copy all records from tmp_dim_customer to Dim_Customer
		insert into Dim_Customer(SK_Customer, CustomerID, CustomerName, BranchID, 
				CustomerType, CustomerTypeDescription, NationalID, PhoneNumber,
				Job, Start_Date, End_Date, Current_Flag)			
		select 
			SK_Customer,
			CustomerID, 
			CustomerName, 
			BranchID, 
			CustomerType, 
			CustomerTypeDescription, 
			NationalID, 
			PhoneNumber,
			Job, 
			Start_Date, 
			End_Date, 
			Current_Flag
		from tmp_dim_customer


		SET IDENTITY_INSERT Dim_Customer OFF

	end
end






exec ins_DimCustomer


select * from Dim_Customer


update Customer
set job = 'Programmar'
where CustomerID = 1