USE [HW_2]
go

create procedure ins_DimFacility as
begin

	--if tmp_dim_facility is not empty and Dim_Facility is empty we realize that a problem occurred in the previous execution of this procedure.
	if(not (exists(select FacilityNumber from tmp_dim_facility) and not exists(select FacilityNumber from Dim_Facility)))
	begin
		truncate table tmp_dim_facility
		truncate table tmp2_dim_facility
		truncate table tmp3_dim_facility


		--########### Copy  Dim_Facility to tmp_dim_facility ############:
		--Only if the Amount field has changed, it will be updated because this field is filled from the source table
		insert into tmp_dim_facility(FacilityNumber, FacilitySubtype, FacilitySubtypeDescription,
				FacilityType, FacilityTypeDescription, CustomerNumber, CustomerName, BranchID,
				Currency, CurrencyDescription, ApprovalDate, Amount, FacilityDuration, [Status])
		select t1.FacilityNumber,
			t1.FacilitySubtype,
			t1.FacilitySubtypeDescription,
			t1.FacilityType,
			t1.FacilityTypeDescription,
			t1.CustomerNumber,
			t1.CustomerName,
			t1.BranchID,
			t1.Currency,
			t1.CurrencyDescription,
			t1.ApprovalDate,
			t2.Amount,
			t1.FacilityDuration,
			t1.[Status]
		from Dim_Facility t1 join Facility t2
		on(t1.FacilityNumber = t2.FacilityNumber)


		truncate table Dim_Facility




		--########### insert new facilities ########## :

		--join Facility and FacilityType to tmp2_dim_facility
		insert into tmp2_dim_facility(FacilityNumber, FacilitySubtype, FacilitySubtypeDescription,
				FacilityType, FacilityTypeDescription, CustomerNumber, BranchID,
				Currency, ApprovalDate, Amount, FacilityDuration, [Status])
		select t1.FacilityNumber,
			t1.FacilitySubtype,
			t2.FacilitySubtypeDescription,
			t2.FacilityType,
			t2.FacilityTypeDescription,
			t1.CustomerNumber,
			t1.Branch,
			t1.Currency,
			t1.ApprovalDate,
			t1.Amount,
			t1.FacilityDuration,
			t1.[Status]
		from Facility t1 join FacilityType t2 
		on(t1.FacilitySubtype = t2.FacilitySubtype)
		where t1.FacilityNumber not in (select FacilityNumber from tmp_dim_facility)

		--join tmp2_dim_facility and Currency to tmp3_dim_facility
		insert into tmp3_dim_facility(FacilityNumber, FacilitySubtype, FacilitySubtypeDescription,
				FacilityType, FacilityTypeDescription, CustomerNumber, BranchID,
				Currency, CurrencyDescription, ApprovalDate, Amount, FacilityDuration, [Status])
		select t1.FacilityNumber,
			t1.FacilitySubtype,
			t1.FacilitySubtypeDescription,
			t1.FacilityType,
			t1.FacilityTypeDescription,
			t1.CustomerNumber,
			t1.BranchID,
			t1.Currency,
			t2.CurrencyDescription,
			t1.ApprovalDate,
			t1.Amount,
			t1.FacilityDuration,
			t1.[Status]
		from tmp2_dim_facility t1 join Currency t2
		on(t1.Currency = t2.CurrencyID)


		--join tmp3_dim_facility and Customer to tmp_dim_facility
		insert into tmp_dim_facility(FacilityNumber, FacilitySubtype, FacilitySubtypeDescription,
				FacilityType, FacilityTypeDescription, CustomerNumber, CustomerName, BranchID,
				Currency, CurrencyDescription, ApprovalDate, Amount, FacilityDuration, [Status])
		select t1.FacilityNumber,
			t1.FacilitySubtype,
			t1.FacilitySubtypeDescription,
			t1.FacilityType,
			t1.FacilityTypeDescription,
			t1.CustomerNumber,
			t2.CustomerName,
			t1.BranchID,
			t1.Currency,
			t1.CurrencyDescription,
			t1.ApprovalDate,
			t1.Amount,
			t1.FacilityDuration,
			t1.[Status]
		from tmp3_dim_facility t1 join Customer t2
		on(t1.CustomerNumber = t2.CustomerID)


		-- ########### insert x to y at once ###########
		insert into Dim_Facility
		select FacilityNumber,
			FacilitySubtype,
			FacilitySubtypeDescription,
			FacilityType,
			FacilityTypeDescription,
			CustomerNumber,
			CustomerName,
			BranchID,
			Currency,
			CurrencyDescription,
			ApprovalDate,
			Amount,
			FacilityDuration,
			[Status]
		from tmp_dim_facility

	end
end



exec ins_DimFacility

select * from Dim_Facility

update Facility
set Amount=50000.00, FacilityDuration = 12
where FacilityNumber =1



