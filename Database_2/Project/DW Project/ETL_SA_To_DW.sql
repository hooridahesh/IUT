USE [DW_sakila];
GO

--#########################  Dropping all stored procedures #############################
/*
DROP PROCEDURE IF EXISTS ins_Dim_CUSTOMER;
DROP PROCEDURE IF EXISTS ins_Dim_STUDIO;
DROP PROCEDURE IF EXISTS ins_Dim_COMPANY;
DROP PROCEDURE IF EXISTS ins_Dim_FILM;
DROP PROCEDURE IF EXISTS ins_Dim_STATE;
DROP PROCEDURE IF EXISTS ins_Dim_CATEGORY;
DROP PROCEDURE IF EXISTS ins_Dim_ACTOR;

DROP PROCEDURE IF EXISTS ins_Fact_Transaction_Rental; 
DROP PROCEDURE IF EXISTS ins_Fact_Daily_Rental;   
DROP PROCEDURE IF EXISTS ins_Fact_ACC_Rental; 
DROP PROCEDURE IF EXISTS ins_Factless_FilmActorRelation;  
DROP PROCEDURE IF EXISTS ins_Factless_FilmCategoryRelation;  
*/





--######################################################################################
--################################## # # # # # # # #####################################
--################################## Dimension ETL #####################################
--################################## # # # # # # # #####################################
--######################################################################################

----------------------------------------create procedure ins_Dim_CUSTOMER
create procedure ins_Dim_CUSTOMER as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);

	SET IDENTITY_INSERT Dim_CUSTOMER OFF
	SET IDENTITY_INSERT tmp_dim_customer OFF
	
	--if tmp_dim_customer is not empty and Dim_CUSTOMER is empty we realize that a problem occurred in the previous execution of this procedure.
	if(not (exists(select customer_id from tmp_dim_customer) and not exists(select customer_id from Dim_CUSTOMER)))		
	begin
		
		-- Truncate tmp_changeDiscountPercent_customer
		begin try
			set @startTime = GETDATE();

			truncate table tmp_changeDiscountPercent_customer;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_changeDiscountPercent_customer', @startTime, @endTime, 'Success', 'Truncate tmp_changeDiscountPercent_customer');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_changeDiscountPercent_customer', @startTime, @endTime, 'Failure', 'Error in truncating tmp_changeDiscountPercent_customer: ' + @errorMsg);
			return;
		end catch

		-- Truncate tmp2_dim_customer
		begin try
			set @startTime = GETDATE();

			truncate table tmp2_dim_customer;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp2_dim_customer', @startTime, @endTime, 'Success', 'Truncate tmp2_dim_customer');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp2_dim_customer', @startTime, @endTime, 'Failure', 'Error in truncating tmp2_dim_customer: ' + @errorMsg);
			return;
		end catch

		-- Truncate tmp_dim_customer
		begin try
			set @startTime = GETDATE();

			truncate table tmp_dim_customer;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_dim_customer', @startTime, @endTime, 'Success', 'Truncate tmp_dim_customer');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_dim_customer', @startTime, @endTime, 'Failure', 'Error in truncating tmp_dim_customer: ' + @errorMsg);
			return;
		end catch

		-- ########### Copy Dim_CUSTOMER to tmp_dim_customer ###########
		SET IDENTITY_INSERT tmp_dim_customer ON

		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_customer(SK_customer, customer_id, first_name, last_name, email, 
							date_of_birth, gender, state_id, [state], country_id, country, 
							discount_percent, [Start_Date], End_Date, Current_Flag)
			select SK_customer,
			customer_id,
			first_name, 
			last_name,
			email,
			date_of_birth, 
			gender, 
			state_id, 
			[state], 
			country_id,
			country,
			discount_percent, 
			[Start_Date],
			End_Date,
			Current_Flag
			from Dim_CUSTOMER

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_dim_customer', @startTime, @endTime, 'Success', 'Copy Dim_CUSTOMER to tmp_dim_customer');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_dim_customer', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_customer: ' + @errorMsg);
			return;
		end catch

		SET IDENTITY_INSERT tmp_dim_customer OFF

		-- Truncate Dim_CUSTOMER
		begin try
			set @startTime = GETDATE();

			truncate table Dim_CUSTOMER;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'Dim_CUSTOMER', @startTime, @endTime, 'Success', 'Truncate Dim_CUSTOMER');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'Dim_CUSTOMER', @startTime, @endTime, 'Failure', 'Error in truncating Dim_CUSTOMER: ' + @errorMsg);
			return;
		end catch
		
		-- ## Add records whose discount_percent has changed to tmp_changeDiscountPercent_customer table ###
		begin try
			set @startTime = GETDATE();

			insert into tmp_changeDiscountPercent_customer(customer_id, first_name, 
						last_name, email, date_of_birth, gender, state_id, [state], country_id, 
						country, discount_percent, [Start_Date], End_Date, Current_Flag)
			select t.customer_id,
			t.first_name, 
			t.last_name,
			t.email,
			t.date_of_birth, 
			t.gender, 
			t.state_id, 
			t.[state], 
			t.country_id,
			t.country,
			cu1.discount_percent, 
			[Start_Date],
			End_Date,
			Current_Flag
			from tmp_dim_customer t join customer cu1
			on(t.customer_id = cu1.customer_id)
			where t.discount_percent <> cu1.discount_percent and t.Current_Flag = 1

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_changeDiscountPercent_customer', @startTime, @endTime, 'Success', 'Insert into tmp_changeDiscountPercent_customer');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_changeDiscountPercent_customer', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_changeDiscountPercent_customer: ' + @errorMsg);
			return;
		end catch

		-- ############### Updating the tmp_dim_customer table ####################:
		begin try
			set @startTime = GETDATE();

			update tmp_dim_customer
			set Current_Flag = 0,  End_Date = GETDATE()
			where customer_id in (select customer_id from tmp_changeDiscountPercent_customer) and Current_Flag = 1

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_dim_customer', @startTime, @endTime, 'Success', 'Updating the tmp_dim_customer');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_dim_customer', @startTime, @endTime, 'Failure', 'Error in updating the tmp_dim_customer table: ' + @errorMsg);
			return;
		end catch
	   
		-- ########### insert into tmp_dim_customer from tmp_changeDiscountPercent_customer ###########:
		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_customer(customer_id, first_name, last_name, email, 
							date_of_birth, gender, state_id, [state], country_id, country, 
							discount_percent, [Start_Date], End_Date, Current_Flag)
			select customer_id,
			first_name, 
			last_name,
			email,
			date_of_birth, 
			gender, 
			state_id, 
			[state], 
			country_id,
			country,
			discount_percent, 
			GETDATE(),
			null,
			1
			from tmp_changeDiscountPercent_customer

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_dim_customer', @startTime, @endTime, 'Success', 'Insert into tmp_dim_customer from tmp_changeDiscountPercent_customer');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_dim_customer', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_customer: ' + @errorMsg);
			return;
		end catch

	   -- ########### insert new records into tmp2_dim_customer ########## :
	   begin try
			set @startTime = GETDATE();

			insert into tmp2_dim_customer(customer_id, first_name, last_name, email, date_of_birth, 
							gender, state_id, [state], country_id, discount_percent, 
							[Start_Date], End_Date, Current_Flag)
			select cu1.customer_id,
			cu1.first_name, 
			cu1.last_name,
			cu1.email,
			cu1.date_of_birth, 
			cu1.gender, 
			cu1.state_id, 
			s1.[state], 
			s1.country_id,
			cu1.discount_percent, 
			GETDATE(),
			null,
			1
			from customer cu1 join [state] s1 
			on(cu1.state_id = s1.state_id)
			where cu1.customer_id not in (select customer_id from tmp_dim_customer)

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp2_dim_customer', @startTime, @endTime, 'Success', 'Insert into tmp2_dim_customer');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp2_dim_customer', @startTime, @endTime, 'Failure', 'Error in inserting into tmp2_dim_customer: ' + @errorMsg);
			return;
		end catch

		--########### insert into tmp_dim_customer ########## :
		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_customer(customer_id, first_name, last_name, email, date_of_birth, 
							gender, state_id, [state], country_id, country, discount_percent, 
							[Start_Date], End_Date, Current_Flag)
			select t1.customer_id,
			t1.first_name, 
			t1.last_name,
			t1.email,
			t1.date_of_birth, 
			t1.gender, 
			t1.state_id, 
			t1.[state], 
			t1.country_id,
			c1.country,
			t1.discount_percent, 
			t1.[Start_Date],
			t1.End_Date,
			t1.Current_Flag
			from tmp2_dim_customer t1 join country c1
			on(t1.country_id = c1.country_id);

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_dim_customer', @startTime, @endTime, 'Success', 'Insert into tmp_dim_customer');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'tmp_dim_customer', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_customer: ' + @errorMsg);
			return;
		end catch

		-- ########### insert into Dim_CUSTOMER ###########
		SET IDENTITY_INSERT Dim_CUSTOMER ON

		begin try
			set @startTime = GETDATE();

			insert into Dim_CUSTOMER(SK_customer, customer_id, first_name, last_name, email, 
							date_of_birth, gender, state_id, [state], country_id, country, 
							discount_percent, [Start_Date], End_Date, Current_Flag)
			select SK_customer,
			customer_id,
			first_name, 
			last_name,
			email,
			date_of_birth, 
			gender, 
			state_id, 
			[state], 
			country_id,
			country,
			discount_percent, 
			[Start_Date],
			End_Date,
			Current_Flag
			from tmp_dim_customer

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'Dim_CUSTOMER', @startTime, @endTime, 'Success', 'Insert into Dim_CUSTOMER from tmp_dim_customer');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_CUSTOMER', 'Dim_CUSTOMER', @startTime, @endTime, 'Failure', 'Error in inserting into Dim_CUSTOMER: ' + @errorMsg);
			return;
		end catch

		SET IDENTITY_INSERT Dim_CUSTOMER OFF

	end
end

----------------------------------------create procedure ins_Dim_STUDIO  
create procedure ins_Dim_STUDIO as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);

	--if tmp_dim_studio is not empty and Dim_STUDIO is empty we realize that a problem occurred in the previous execution of this procedure.
	if(not (exists(select studio_id from tmp_dim_studio) and not exists(select studio_id from Dim_STUDIO)))			
	begin

		-- Truncate tmp3_dim_studio
		begin try
			set @startTime = GETDATE();

			truncate table tmp3_dim_studio;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp3_dim_studio', @startTime, @endTime, 'Success', 'Truncate tmp3_dim_studio');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp3_dim_studio', @startTime, @endTime, 'Failure', 'Error in truncating tmp3_dim_studio: ' + @errorMsg);
			return;
		end catch

		-- Truncate tmp2_dim_studio
		begin try
			set @startTime = GETDATE();

			truncate table tmp2_dim_studio;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp2_dim_studio', @startTime, @endTime, 'Success', 'Truncate tmp2_dim_studio');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp2_dim_studio', @startTime, @endTime, 'Failure', 'Error in truncating tmp2_dim_studio: ' + @errorMsg);
			return;
		end catch

		-- Truncate tmp_dim_studio
		begin try
			set @startTime = GETDATE();

			truncate table tmp_dim_studio;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp_dim_studio', @startTime, @endTime, 'Success', 'Truncate tmp_dim_studio');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp_dim_studio', @startTime, @endTime, 'Failure', 'Error in truncating tmp_dim_studio: ' + @errorMsg);
			return;
		end catch

		-- ########### Copy Dim_STUDIO to tmp_dim_studio ###########
		--Only if the commission_percent field has changed, it will be updated because this field is filled from the source table

		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_studio(studio_id, company_id, company_name, commission_percent, state_id,
							[state], country_id, country, original_studio_name, Effective_Date, 
							current_studio_name)
			select ds.studio_id,
			ds.company_id,
			ds.company_name,
			stu.commission_percent, 
			ds.state_id, 
			ds.[state],
			ds.country_id,
			ds.country,
			ds.original_studio_name,
			ds.Effective_Date,
			ds.current_studio_name
			from Dim_STUDIO ds join studio stu
			on (ds.studio_id = stu.studio_id)

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp_dim_studio', @startTime, @endTime, 'Success', 'Copy Dim_STUDIO to tmp_dim_studio');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp_dim_studio', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_studio: ' + @errorMsg);
			return;
		end catch
		
		-- Truncate Dim_STUDIO
		begin try
			set @startTime = GETDATE();

			truncate table Dim_STUDIO;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'Dim_STUDIO', @startTime, @endTime, 'Success', 'Truncate Dim_STUDIO');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'Dim_STUDIO', @startTime, @endTime, 'Failure', 'Error in truncating Dim_STUDIO: ' + @errorMsg);
			return;
		end catch

		-- ############### Updating the tmp_dim_studio table ####################:
		begin try
			set @startTime = GETDATE();

			update tmp
			set 
			tmp.original_studio_name = tmp.current_studio_name,
			tmp.Effective_Date = GETDATE(),
			tmp.current_studio_name = st.[name]
			from tmp_dim_studio tmp join studio st
			on(tmp.studio_id = st.studio_id)
			where tmp.current_studio_name <> st.[name]

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp_dim_studio', @startTime, @endTime, 'Success', 'Updating the tmp_dim_studio');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp_dim_studio', @startTime, @endTime, 'Failure', 'Error in updating the tmp_dim_studio table: ' + @errorMsg);
			return;
		end catch

		-- ########### insert new records into tmp3_dim_studio ########## :
		begin try
			set @startTime = GETDATE();

			insert into tmp3_dim_studio(studio_id, company_id, company_name, commission_percent, state_id,
						original_studio_name, Effective_Date, current_studio_name)
			select st1.studio_id,
			st1.company_id,
			co1.[name],
			st1.commission_percent, 
			st1.state_id, 
			null,
			GETDATE(),
			st1.[name]
			from studio st1 join company co1 
			on(st1.company_id = co1.company_id)
			where st1.studio_id not in (select studio_id from tmp_dim_studio)

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp3_dim_studio', @startTime, @endTime, 'Success', 'Insert into tmp3_dim_studio');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp3_dim_studio', @startTime, @endTime, 'Failure', 'Error in inserting into tmp3_dim_studio: ' + @errorMsg);
			return;
		end catch

		--########### insert into tmp2_dim_studio ########## :
		begin try
			set @startTime = GETDATE();

			insert into tmp2_dim_studio(studio_id, company_id, company_name, commission_percent, state_id,
						[state], country_id, original_studio_name, Effective_Date, current_studio_name)
			select t3.studio_id,
			t3.company_id,
			t3.company_name,
			t3.commission_percent, 
			t3.state_id, 
			s1.[state],
			s1.country_id,
			t3.original_studio_name,
			t3.Effective_Date,
			t3.current_studio_name
			from tmp3_dim_studio t3 join [state] s1 
			on(t3.state_id = s1.state_id);

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp2_dim_studio', @startTime, @endTime, 'Success', 'Insert into tmp2_dim_studio');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp2_dim_studio', @startTime, @endTime, 'Failure', 'Error in inserting into tmp2_dim_studio: ' + @errorMsg);
			return;
		end catch

		--########### insert into tmp_dim_studio ########## :  
		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_studio(studio_id, company_id, company_name, commission_percent, state_id,
						[state], country_id, country, original_studio_name, Effective_Date, current_studio_name)
			select t2.studio_id,
			t2.company_id,
			t2.company_name,
			t2.commission_percent, 
			t2.state_id, 
			t2.[state],
			t2.country_id,
			co1.country,
			t2.original_studio_name,
			t2.Effective_Date,
			t2.current_studio_name
			from tmp2_dim_studio t2 join country co1 
			on(t2.country_id = co1.country_id);

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp_dim_studio', @startTime, @endTime, 'Success', 'Insert into tmp_dim_studio');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'tmp_dim_studio', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_studio: ' + @errorMsg);
			return;
		end catch

		-- ########### insert into Dim_STUDIO ###########
		begin try
			set @startTime = GETDATE();

			insert into Dim_STUDIO(studio_id, company_id, company_name, commission_percent, state_id,
						[state], country_id, country, original_studio_name, Effective_Date, current_studio_name)
			select studio_id,
			company_id,
			company_name,
			commission_percent, 
			state_id, 
			[state],
			country_id,
			country,
			original_studio_name,
			Effective_Date,
			current_studio_name
			from tmp_dim_studio

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'Dim_STUDIO', @startTime, @endTime, 'Success', 'Insert into Dim_STUDIO from tmp_dim_studio');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STUDIO', 'Dim_STUDIO', @startTime, @endTime, 'Failure', 'Error in inserting into Dim_STUDIO: ' + @errorMsg);
			return;
		end catch

	end
end

----------------------------------------create procedure ins_Dim_COMPANY
create procedure ins_Dim_COMPANY as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	--if tmp_dim_company is not empty and Dim_COMPANY is empty we realize that a problem occurred in the previous execution of this procedure.
	if(not (exists(select company_id from tmp_dim_company) and not exists(select company_id from Dim_COMPANY)))				
	begin

		-- Truncate tmp2_dim_company
		begin try
			set @startTime = GETDATE();

			truncate table tmp2_dim_company;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'tmp2_dim_company', @startTime, @endTime, 'Success', 'Truncate tmp2_dim_company');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'tmp2_dim_company', @startTime, @endTime, 'Failure', 'Error in truncating tmp2_dim_company: ' + @errorMsg);
			return;
		end catch

		-- Truncate tmp_dim_company
		begin try
			set @startTime = GETDATE();

			truncate table tmp_dim_company;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'tmp_dim_company', @startTime, @endTime, 'Success', 'Truncate tmp_dim_company');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'tmp_dim_company', @startTime, @endTime, 'Failure', 'Error in truncating tmp_dim_company: ' + @errorMsg);
			return;
		end catch

		-- ########### Copy Dim_COMPANY to tmp_dim_company ###########
		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_company(company_id, state_id, [state], country_id, country, 
							original_company_name, Effective_Date, current_company_name)
			select company_id,
			state_id, 
			[state], 
			country_id,
			country,
			original_company_name,
			Effective_Date,
			current_company_name
			from Dim_COMPANY

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'tmp_dim_company', @startTime, @endTime, 'Success', 'Copy Dim_COMPANY to tmp_dim_company');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'tmp_dim_company', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_company: ' + @errorMsg);
			return;
		end catch

		-- Truncate Dim_COMPANY
		begin try
			set @startTime = GETDATE();

			truncate table Dim_COMPANY;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'Dim_COMPANY', @startTime, @endTime, 'Success', 'Truncate Dim_COMPANY');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'Dim_COMPANY', @startTime, @endTime, 'Failure', 'Error in truncating Dim_COMPANY: ' + @errorMsg);
			return;
		end catch

		-- ############### Updating the tmp_dim_company table ####################:
		begin try
			set @startTime = GETDATE();

			update tmp
			set 
			tmp.original_company_name = tmp.current_company_name,
			tmp.Effective_Date = GETDATE(),
			tmp.current_company_name = co.[name]
			from tmp_dim_company tmp join company co
			on(tmp.company_id = co.company_id)
			where tmp.current_company_name <> co.[name]

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'tmp_dim_company', @startTime, @endTime, 'Success', 'Updating the tmp_dim_company');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'tmp_dim_company', @startTime, @endTime, 'Failure', 'Error in updating the tmp_dim_company table: ' + @errorMsg);
			return;
		end catch

		--########### insert new records into tmp2_dim_company ########## :
		begin try
			set @startTime = GETDATE();

			insert into tmp2_dim_company(company_id, state_id, [state], country_id, 
							original_company_name, Effective_Date, current_company_name)
			select co1.company_id,
			co1.state_id, 
			s1.[state], 
			s1.country_id,
			null,
			GETDATE(),
			co1.[name]
			from company co1 join [state] s1 
			on(co1.state_id = s1.state_id)
			where co1.company_id not in (select company_id from tmp_dim_company)


			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'tmp2_dim_company', @startTime, @endTime, 'Success', 'Insert into tmp2_dim_company');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'tmp2_dim_company', @startTime, @endTime, 'Failure', 'Error in inserting into tmp2_dim_company: ' + @errorMsg);
			return;
		end catch

		--########### insert into tmp_dim_company ########## :
		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_company(company_id, state_id, [state], country_id, country, 
							original_company_name, Effective_Date, current_company_name)
			select t2.company_id,
			t2.state_id, 
			t2.[state], 
			t2.country_id,
			c1.country,
			t2.original_company_name,
			t2.Effective_Date,
			t2.current_company_name
			from tmp2_dim_company t2 join country c1
			on(t2.country_id = c1.country_id);

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'tmp_dim_company', @startTime, @endTime, 'Success', 'Insert into tmp_dim_company');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'tmp_dim_company', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_company: ' + @errorMsg);
			return;
		end catch

		-- ########### insert into Dim_COMPANY ###########
		begin try
			set @startTime = GETDATE();

			insert into Dim_COMPANY(company_id, state_id, [state], country_id, country, 
							original_company_name, Effective_Date, current_company_name)
			select company_id,
			state_id, 
			[state], 
			country_id,
			country,
			original_company_name,
			Effective_Date,
			current_company_name
			from tmp_dim_company

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'Dim_COMPANY', @startTime, @endTime, 'Success', 'Insert into Dim_COMPANY from tmp_dim_company');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_COMPANY', 'Dim_COMPANY', @startTime, @endTime, 'Failure', 'Error in inserting into Dim_COMPANY: ' + @errorMsg);
			return;
		end catch

	end
end

----------------------------------------create procedure ins_Dim_FILM
create procedure ins_Dim_FILM as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);

	SET IDENTITY_INSERT Dim_FILM OFF
	SET IDENTITY_INSERT tmp_dim_film OFF

	--if tmp_dim_film is not empty and Dim_FILM is empty we realize that a problem occurred in the previous execution of this procedure.
	if(not (exists(select film_id from tmp_dim_film) and not exists(select film_id from Dim_FILM)))			
	begin

		-- Truncate tmp_changeRentalPrice_film
		begin try
			set @startTime = GETDATE();

			truncate table tmp_changeRentalPrice_film;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_changeRentalPrice_film', @startTime, @endTime, 'Success', 'Truncate tmp_changeRentalPrice_film');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_changeRentalPrice_film', @startTime, @endTime, 'Failure', 'Error in truncating tmp_changeRentalPrice_film: ' + @errorMsg);
			return;
		end catch

		-- Truncate tmp3_dim_film
		begin try
			set @startTime = GETDATE();

			truncate table tmp3_dim_film;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp3_dim_film', @startTime, @endTime, 'Success', 'Truncate tmp3_dim_film');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp3_dim_film', @startTime, @endTime, 'Failure', 'Error in truncating tmp3_dim_film: ' + @errorMsg);
			return;
		end catch

		-- Truncate tmp2_dim_film
		begin try
			set @startTime = GETDATE();

			truncate table tmp2_dim_film;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp2_dim_film', @startTime, @endTime, 'Success', 'Truncate tmp2_dim_film');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp2_dim_film', @startTime, @endTime, 'Failure', 'Error in truncating tmp2_dim_film: ' + @errorMsg);
			return;
		end catch

		-- Truncate tmp_dim_film
		begin try
			set @startTime = GETDATE();

			truncate table tmp_dim_film;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_dim_film', @startTime, @endTime, 'Success', 'Truncate tmp_dim_film');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_dim_film', @startTime, @endTime, 'Failure', 'Error in truncating tmp_dim_film: ' + @errorMsg);
			return;
		end catch

		-- ########### Copy Dim_FILM to tmp_dim_film ###########
		--Only if the rating field has changed, it will be updated because this field is filled from the source table

		SET IDENTITY_INSERT tmp_dim_film ON

		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_film(SK_film, film_id, title, release_year, language_id, language_name, 
						original_language_id, original_language_name, [length], rating, studio_id, 
						studio_name, rental_price, [Start_Date], End_Date, Current_Flag)
			select df.SK_film, 
			df.film_id,
			df.title,
			df.release_year, 
			df.language_id,
			df.language_name, 
			df.original_language_id,
			df.original_language_name,
			df.[length],
			fi.rating,
			df.studio_id,
			df.studio_name,
			df.rental_price,
			df.[Start_Date],
			df.End_Date,
			df.Current_Flag
			from Dim_FILM df join film fi
			on (df.film_id = fi.film_id)

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_dim_film', @startTime, @endTime, 'Success', 'Copy Dim_FILM to tmp_dim_film');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_dim_film', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_film: ' + @errorMsg);
			return;
		end catch

		SET IDENTITY_INSERT tmp_dim_film OFF

		-- Truncate Dim_FILM
		begin try
			set @startTime = GETDATE();

			truncate table Dim_FILM;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'Dim_FILM', @startTime, @endTime, 'Success', 'Truncate Dim_FILM');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'Dim_FILM', @startTime, @endTime, 'Failure', 'Error in truncating Dim_FILM: ' + @errorMsg);
			return;
		end catch

		-- ## Add records whose rental_price has changed to tmp_changeRentalPrice_film table ###
		begin try
			set @startTime = GETDATE();

			insert into tmp_changeRentalPrice_film(film_id, title, release_year, language_id, 
						language_name, original_language_id, original_language_name, [length], rating, 
						studio_id, studio_name, rental_price, [Start_Date], End_Date, Current_Flag)
			select t.film_id,
			t.title,
			t.release_year, 
			t.language_id,
			t.language_name, 
			t.original_language_id,
			t.original_language_name,
			t.[length],
			t.rating,
			t.studio_id,
			t.studio_name,
			f.rental_price,
			[Start_Date],
			End_Date,
			Current_Flag
			from tmp_dim_film t join film f
			on (t.film_id = f.film_id)
			where t.rental_price <> f.rental_price and t.Current_Flag = 1

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_changeRentalPrice_film', @startTime, @endTime, 'Success', 'Insert into tmp_changeRentalPrice_film');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_changeRentalPrice_film', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_changeRentalPrice_film: ' + @errorMsg);
			return;
		end catch

		-- ############### Updating the tmp_dim_film table ####################:
		begin try
			set @startTime = GETDATE();

			update tmp_dim_film
			set Current_Flag = 0,  End_Date = GETDATE()
			where film_id in (select film_id from tmp_changeRentalPrice_film) and Current_Flag = 1

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_dim_film', @startTime, @endTime, 'Success', 'Updating the tmp_dim_film');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_dim_film', @startTime, @endTime, 'Failure', 'Error in updating the tmp_dim_film table: ' + @errorMsg);
			return;
		end catch
	   
		-- ########### insert into tmp_dim_film from tmp_changeRentalPrice_film ###########:
		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_film(film_id, title, release_year, language_id, language_name, 
						original_language_id, original_language_name, [length], rating, studio_id, 
						studio_name, rental_price, [Start_Date], End_Date, Current_Flag)
			select film_id,
			title,
			release_year, 
			language_id,
			language_name, 
			original_language_id,
			original_language_name,
			[length],
			rating,
			studio_id,
			studio_name,
			rental_price,
			GETDATE(),
			null,
			1
			from tmp_changeRentalPrice_film

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_dim_film', @startTime, @endTime, 'Success', 'Insert into tmp_dim_film from tmp_changeRentalPrice_film');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_dim_film', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_film: ' + @errorMsg);
			return;
		end catch

		--########### insert new records into tmp3_dim_film ########## :
		begin try
			set @startTime = GETDATE();

			insert into tmp3_dim_film(film_id, title, release_year, language_id, language_name, 
						original_language_id, [length], rating, studio_id, rental_price, [Start_Date], 
						End_Date, Current_Flag)
			select f1.film_id,
			f1.title,
			f1.release_year, 
			f1.language_id,
			la1.[name], 
			f1.original_language_id,
			f1.[length],
			f1.rating,
			f1.studio_id,
			f1.rental_price,
			GETDATE(),
			null,
			1
			from film f1 join [language] la1
			on(f1.language_id = la1.language_id)
			where f1.film_id not in (select film_id from tmp_dim_film)

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp3_dim_film', @startTime, @endTime, 'Success', 'Insert into tmp3_dim_film');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp3_dim_film', @startTime, @endTime, 'Failure', 'Error in inserting into tmp3_dim_film: ' + @errorMsg);
			return;
		end catch

		--########### insert into tmp2_dim_film ########## :
		begin try
			set @startTime = GETDATE();

			insert into tmp2_dim_film(film_id, title, release_year, language_id, language_name, 
						original_language_id, original_language_name, [length], rating, studio_id, 
						rental_price, [Start_Date], End_Date, Current_Flag)
			select t3.film_id,
			t3.title,
			t3.release_year, 
			t3.language_id,
			t3.language_name, 
			t3.original_language_id,
			isnull(la2.[name], ''),
			t3.[length],
			t3.rating,
			t3.studio_id,
			t3.rental_price,
			t3.[Start_Date],
			t3.End_Date,
			t3.Current_Flag
			from tmp3_dim_film t3 left join [language] la2
			on(t3.original_language_id = la2.language_id);

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp2_dim_film', @startTime, @endTime, 'Success', 'Insert into tmp2_dim_film');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp2_dim_film', @startTime, @endTime, 'Failure', 'Error in inserting into tmp2_dim_film: ' + @errorMsg);
			return;
		end catch

		--########### insert into tmp_dim_film ########## :
		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_film(film_id, title, release_year, language_id, language_name, 
						original_language_id, original_language_name, [length], rating, studio_id, 
						studio_name, rental_price, [Start_Date], End_Date, Current_Flag)
			select t2.film_id,
			t2.title,
			t2.release_year, 
			t2.language_id,
			t2.language_name, 
			t2.original_language_id,
			t2.original_language_name,
			t2.[length],
			t2.rating,
			t2.studio_id,
			st1.[name],
			t2.rental_price,
			t2.[Start_Date],
			t2.End_Date,
			t2.Current_Flag
			from tmp2_dim_film t2 join studio st1
			on(t2.studio_id = st1.studio_id);

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_dim_film', @startTime, @endTime, 'Success', 'Insert into tmp_dim_film');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'tmp_dim_film', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_film: ' + @errorMsg);
			return;
		end catch

		-- ########### insert into Dim_FILM ###########
		SET IDENTITY_INSERT Dim_FILM ON

		begin try
			set @startTime = GETDATE();

			insert into Dim_FILM(SK_film, film_id, title, release_year, language_id, language_name, 
						original_language_id, original_language_name, [length], rating, studio_id, 
						studio_name, rental_price, [Start_Date], End_Date, Current_Flag)
			select SK_film, 
			film_id,
			title,
			release_year, 
			language_id,
			language_name, 
			original_language_id,
			original_language_name,
			[length],
			rating,
			studio_id,
			studio_name,
			rental_price,
			[Start_Date],
			End_Date,
			Current_Flag
			from tmp_dim_film

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'Dim_FILM', @startTime, @endTime, 'Success', 'Insert into Dim_FILM from tmp_dim_film');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_FILM', 'Dim_FILM', @startTime, @endTime, 'Failure', 'Error in inserting into Dim_FILM: ' + @errorMsg);
			return;
		end catch

		SET IDENTITY_INSERT Dim_FILM OFF

	end
end

----------------------------------------create procedure ins_Dim_STATE
create procedure ins_Dim_STATE as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);

	--if tmp_dim_state is not empty and Dim_STATE is empty we realize that a problem occurred in the previous execution of this procedure.
	if(not (exists(select state_id from tmp_dim_state) and not exists(select state_id from Dim_STATE)))	
	begin

		-- Truncate tmp_dim_state
		begin try
			set @startTime = GETDATE();

			truncate table tmp_dim_state;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STATE', 'tmp_dim_state', @startTime, @endTime, 'Success', 'Truncate tmp_dim_state');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STATE', 'tmp_dim_state', @startTime, @endTime, 'Failure', 'Error in truncating tmp_dim_state: ' + @errorMsg);
			return;
		end catch

		-- ########### Copy Dim_STATE to tmp_dim_state ###########
		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_state(state_id, [state], country_id, country)
			select state_id, 
			[state], 
			country_id, 
			country
			from Dim_STATE;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STATE', 'tmp_dim_state', @startTime, @endTime, 'Success', 'Copy Dim_STATE to tmp_dim_state');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STATE', 'tmp_dim_state', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_state: ' + @errorMsg);
			return;
		end catch

		-- Truncate Dim_STATE
		begin try
			set @startTime = GETDATE();

			truncate table Dim_STATE;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STATE', 'Dim_STATE', @startTime, @endTime, 'Success', 'Truncate Dim_STATE');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STATE', 'Dim_STATE', @startTime, @endTime, 'Failure', 'Error in truncating Dim_STATE: ' + @errorMsg);
			return;
		end catch

		--########### insert into tmp_dim_state ########## :
		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_state(state_id, [state], country_id, country)
			select s1.state_id, 
			s1.[state], 
			s1.country_id, 
			c1.country
			from [state] s1 join country c1 
			on(s1.country_id = c1.country_id)
			where s1.state_id not in (select state_id from tmp_dim_state)


			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STATE', 'tmp_dim_state', @startTime, @endTime, 'Success', 'Adding new records to tmp_dim_state');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STATE', 'tmp_dim_state', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_state: ' + @errorMsg);
			return;
		end catch

		-- ########### insert into Dim_STATE ###########
		begin try
			set @startTime = GETDATE();

			insert into Dim_STATE(state_id, [state], country_id, country)
			select state_id, 
			[state], 
			country_id, 
			country
			from tmp_dim_state;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STATE', 'Dim_STATE', @startTime, @endTime, 'Success', 'Insert into Dim_STATE from tmp_dim_state');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_STATE', 'Dim_STATE', @startTime, @endTime, 'Failure', 'Error in inserting into Dim_STATE: ' + @errorMsg);
			return;
		end catch

	end
end

----------------------------------------create procedure ins_Dim_CATEGORY
create procedure ins_Dim_CATEGORY as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);

	-- ########### insert into Dim_CATEGORY ###########
	begin try
		set @startTime = GETDATE();

		insert into Dim_CATEGORY(category_id, category_name)
		select category_id, [name]
		from category
		where category_id not in (select category_id from Dim_CATEGORY)

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Dim_CATEGORY', 'Dim_CATEGORY', @startTime, @endTime, 'Success', 'Insert into Dim_CATEGORY from category');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Dim_CATEGORY', 'Dim_CATEGORY', @startTime, @endTime, 'Failure', 'Error in inserting into Dim_CATEGORY: ' + @errorMsg);
		return;
	end catch

end

----------------------------------------create procedure ins_Dim_ACTOR
create procedure ins_Dim_ACTOR as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);

	--if tmp_dim_actor is not empty and Dim_ACTOR is empty we realize that a problem occurred in the previous execution of this procedure.
	if(not (exists(select actor_id from tmp_dim_actor) and not exists(select actor_id from Dim_ACTOR)))	
	begin

		-- Truncate tmp2_dim_actor
		begin try
			set @startTime = GETDATE();

			truncate table tmp2_dim_actor;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'tmp2_dim_actor', @startTime, @endTime, 'Success', 'Truncate tmp2_dim_actor');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'tmp2_dim_actor', @startTime, @endTime, 'Failure', 'Error in truncating tmp2_dim_actor: ' + @errorMsg);
			return;
		end catch

		-- Truncate tmp_dim_actor
		begin try
			set @startTime = GETDATE();

			truncate table tmp_dim_actor;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'tmp_dim_actor', @startTime, @endTime, 'Success', 'Truncate tmp_dim_actor');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'tmp_dim_actor', @startTime, @endTime, 'Failure', 'Error in truncating tmp_dim_actor: ' + @errorMsg);
			return;
		end catch

		-- ########### Copy Dim_ACTOR to tmp_dim_actor ###########
		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_actor(actor_id, first_name, last_name, gender, date_of_birth, 
									state_id, [state], country_id, country)
			select actor_id,
			first_name, 
			last_name, 
			gender, 
			date_of_birth, 
			state_id, 
			[state], 
			country_id,
			country
			from Dim_ACTOR

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'tmp_dim_actor', @startTime, @endTime, 'Success', 'Copy Dim_ACTOR to tmp_dim_actor');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'tmp_dim_actor', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_actor: ' + @errorMsg);
			return;
		end catch

		-- Truncate Dim_ACTOR
		begin try
			set @startTime = GETDATE();

			truncate table Dim_ACTOR;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'Dim_ACTOR', @startTime, @endTime, 'Success', 'Truncate Dim_ACTOR');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'Dim_ACTOR', @startTime, @endTime, 'Failure', 'Error in truncating Dim_ACTOR: ' + @errorMsg);
			return;
		end catch

		--########### insert into tmp2_dim_actor ########## :
		begin try
			set @startTime = GETDATE();

			insert into tmp2_dim_actor(actor_id, first_name, last_name, gender, date_of_birth, 
										state_id, [state], country_id)
			select a1.actor_id,
			a1.first_name, 
			a1.last_name, 
			a1.gender, 
			a1.date_of_birth, 
			a1.state_id, 
			s1.[state], 
			s1.country_id
			from actor a1 join [state] s1 
			on(a1.state_id = s1.state_id)
			where a1.actor_id not in (select actor_id from tmp_dim_actor)

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'tmp2_dim_actor', @startTime, @endTime, 'Success', 'Adding new records to tmp2_dim_actor');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'tmp2_dim_actor', @startTime, @endTime, 'Failure', 'Error in inserting into tmp2_dim_actor: ' + @errorMsg);
			return;
		end catch

		--########### insert into tmp_dim_actor ########## :
		begin try
			set @startTime = GETDATE();

			insert into tmp_dim_actor(actor_id, first_name, last_name, gender, date_of_birth, 
										state_id, [state], country_id, country)
			select t1.actor_id,
			t1.first_name, 
			t1.last_name, 
			t1.gender, 
			t1.date_of_birth, 
			t1.state_id, 
			t1.[state], 
			t1.country_id,
			c1.country
			from tmp2_dim_actor t1 join country c1
			on(t1.country_id = c1.country_id);

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'tmp_dim_actor', @startTime, @endTime, 'Success', 'Adding new records to tmp_dim_actor');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'tmp_dim_actor', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_dim_actor: ' + @errorMsg);
			return;
		end catch

		-- ########### insert into Dim_ACTOR ###########
		begin try
			set @startTime = GETDATE();

			insert into Dim_ACTOR(actor_id, first_name, last_name, gender, date_of_birth, 
									state_id, [state], country_id, country)
			select actor_id,
			first_name, 
			last_name, 
			gender, 
			date_of_birth, 
			state_id, 
			[state], 
			country_id,
			country
			from tmp_dim_actor

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'Dim_ACTOR', @startTime, @endTime, 'Success', 'Insert into Dim_ACTOR from tmp_dim_actor');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Dim_ACTOR', 'Dim_ACTOR', @startTime, @endTime, 'Failure', 'Error in inserting into Dim_ACTOR: ' + @errorMsg);
			return;
		end catch

	end
end





--######################################################################################
--################################# # # # # # # # # ####################################
--################################  Rental Facts ETL ###################################
--################################# # # # # # # # # ####################################
--######################################################################################


----------------------------------------create procedure ins_Fact_Transaction_Rental
create procedure ins_Fact_Transaction_Rental
@fromDate date,
@toDate date
as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	declare @CurrentDate date;

    set @CurrentDate = @fromDate;

	while @CurrentDate <= @toDate
	begin 

		if exists (select 1 from payment where payment_date = @CurrentDate)
		begin

			-- Truncate tmp6_Fact_Transaction_Rental
			begin try
				set @startTime = GETDATE();

				truncate table tmp6_Fact_Transaction_Rental;

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp6_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Truncate tmp6_Fact_Transaction_Rental');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp6_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in truncating tmp6_Fact_Transaction_Rental: ' + @errorMsg);
				return;
			end catch

			-- Truncate tmp5_Fact_Transaction_Rental
			begin try
				set @startTime = GETDATE();

				truncate table tmp5_Fact_Transaction_Rental;

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp5_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Truncate tmp5_Fact_Transaction_Rental');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp5_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in truncating tmp5_Fact_Transaction_Rental: ' + @errorMsg);
				return;
			end catch

			-- Truncate tmp4_Fact_Transaction_Rental
			begin try
				set @startTime = GETDATE();

				truncate table tmp4_Fact_Transaction_Rental;

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp4_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Truncate tmp4_Fact_Transaction_Rental');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp4_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in truncating tmp4_Fact_Transaction_Rental: ' + @errorMsg);
				return;
			end catch

			-- Truncate tmp3_Fact_Transaction_Rental
			begin try
				set @startTime = GETDATE();

				truncate table tmp3_Fact_Transaction_Rental;

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp3_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Truncate tmp3_Fact_Transaction_Rental');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp3_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in truncating tmp3_Fact_Transaction_Rental: ' + @errorMsg);
				return;
			end catch

			-- Truncate tmp2_Fact_Transaction_Rental
			begin try
				set @startTime = GETDATE();

				truncate table tmp2_Fact_Transaction_Rental;

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp2_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Truncate tmp2_Fact_Transaction_Rental');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp2_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in truncating tmp2_Fact_Transaction_Rental: ' + @errorMsg);
				return;
			end catch

			-- Truncate tmp_Fact_Transaction_Rental
			begin try
				set @startTime = GETDATE();

				truncate table tmp_Fact_Transaction_Rental;

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Truncate tmp_Fact_Transaction_Rental');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in truncating tmp_Fact_Transaction_Rental: ' + @errorMsg);
				return;
			end catch

			-- ########### insert into tmp6_Fact_Transaction_Rental ###########
			begin try
				set @startTime = GETDATE();

				insert into tmp6_Fact_Transaction_Rental(TimeKey, payment_id, rental_id, customer_id_payment, 
								studio_id, amount)
				select 
				dd.TimeKey,
				p.payment_id,
				p.rental_id,
				p.customer_account,
				p.studio_account,
				p.amount
				from payment p join Dim_Date dd
				on(p.payment_date = format(convert(date, cast(dd.TimeKey as varchar(8)), 112), 'yyyy-MM-dd'))
				where p.payment_date = @CurrentDate

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp6_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Insert into tmp6_Fact_Transaction_Rental');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp6_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into tmp6_Fact_Transaction_Rental: ' + @errorMsg);
				return;
			end catch

			-- ########### insert into tmp5_Fact_Transaction_Rental ###########
			begin try
				set @startTime = GETDATE();

				insert into tmp5_Fact_Transaction_Rental(TimeKey, sk_customer_payment, customer_id_payment,
								state_id_customer_payment, rental_id, studio_id, amount)
				select 
				t6.TimeKey,
				dc.SK_customer,
				t6.customer_id_payment,
				dc.state_id,              
				t6.rental_id,
				t6.studio_id,
				t6.amount
				from tmp6_Fact_Transaction_Rental t6 join Dim_CUSTOMER dc
				on(t6.customer_id_payment = dc.customer_id)    
				where dc.Current_Flag = 1 

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp5_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Insert into tmp5_Fact_Transaction_Rental');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp5_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into tmp5_Fact_Transaction_Rental: ' + @errorMsg);
				return;
			end catch

			-- ########### insert into tmp4_Fact_Transaction_Rental ###########
			begin try
				set @startTime = GETDATE();

				insert into tmp4_Fact_Transaction_Rental(TimeKey, sk_customer_payment, customer_id_payment,
								state_id_customer_payment, customer_id_rental, [start_date], duration_time,
								film_id, studio_id, amount)
				select 
				t5.TimeKey,
				t5.sk_customer_payment,
				t5.customer_id_payment,
				t5.state_id_customer_payment,
				re.customer_id,
				cast(convert(varchar(8), re.rental_date, 112) as int),
				re.duration_time,
				re.film_id,
				t5.studio_id,
				t5.amount
				from tmp5_Fact_Transaction_Rental t5 join rental re
				on(t5.rental_id = re.rental_id)

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp4_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Insert into tmp4_Fact_Transaction_Rental');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp4_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into tmp4_Fact_Transaction_Rental: ' + @errorMsg);
				return;
			end catch

			-- ########### insert into tmp3_Fact_Transaction_Rental ###########
			begin try
				set @startTime = GETDATE();

				insert into tmp3_Fact_Transaction_Rental(TimeKey, sk_customer_payment, customer_id_payment,
								state_id_customer_payment, sk_customer_rental, customer_id_rental,
								[start_date], duration_time, film_id, studio_id, amount)
				select 
				t4.TimeKey,
				t4.sk_customer_payment,
				t4.customer_id_payment,
				t4.state_id_customer_payment,
				dc.SK_customer,
				t4.customer_id_rental,
				t4.[start_date],
				t4.duration_time,
				t4.film_id,
				t4.studio_id,
				t4.amount
				from tmp4_Fact_Transaction_Rental t4 join Dim_CUSTOMER dc
				on(t4.customer_id_rental = dc.customer_id)
				where dc.Current_Flag = 1
			
				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp3_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Insert into tmp3_Fact_Transaction_Rental');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp3_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into tmp3_Fact_Transaction_Rental: ' + @errorMsg);
				return;
			end catch

			-- ########### insert into tmp2_Fact_Transaction_Rental ###########
			begin try
				set @startTime = GETDATE();

				insert into tmp2_Fact_Transaction_Rental(TimeKey, sk_customer_payment, customer_id_payment,
								state_id_customer_payment, sk_customer_rental, customer_id_rental,
								[start_date], duration_time, sk_film, film_id, studio_id, amount)
				select 
				t3.TimeKey,
				t3.sk_customer_payment,
				t3.customer_id_payment,
				t3.state_id_customer_payment,
				t3.sk_customer_rental,
				t3.customer_id_rental,
				t3.[start_date],
				t3.duration_time,
				df.SK_film,
				t3.film_id,    
				t3.studio_id,  
				t3.amount
				from tmp3_Fact_Transaction_Rental t3 join Dim_FILM df
				on(t3.film_id = df.film_id)
				where df.Current_Flag = 1  

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp2_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Insert into tmp2_Fact_Transaction_Rental');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp2_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into tmp2_Fact_Transaction_Rental: ' + @errorMsg);
				return;
			end catch

			-- ########### insert into tmp_Fact_Transaction_Rental ###########
			begin try
				set @startTime = GETDATE();

				insert into tmp_Fact_Transaction_Rental(TimeKey, sk_customer_payment, customer_id_payment,
								state_id_customer_payment, sk_customer_rental, customer_id_rental,
								[start_date], duration_time, sk_film, film_id, studio_id, company_id, amount)
				select 
				t2.TimeKey,
				t2.sk_customer_payment,
				t2.customer_id_payment,
				t2.state_id_customer_payment,
				t2.sk_customer_rental,
				t2.customer_id_rental,
				t2.[start_date],
				t2.duration_time,
				t2.sk_film,
				t2.film_id,
				t2.studio_id,
				ds.company_id,
				t2.amount
				from tmp2_Fact_Transaction_Rental t2 join Dim_STUDIO ds
				on(t2.studio_id = ds.studio_id)

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Insert into tmp_Fact_Transaction_Rental');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'tmp_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_Fact_Transaction_Rental: ' + @errorMsg);
				return;
			end catch

			-- ########### insert into Fact_Transaction_Rental ########### 
			begin try
				set @startTime = GETDATE();

				insert into Fact_Transaction_Rental(TimeKey, sk_customer_payment, customer_id_payment,
								state_id_customer_payment, sk_customer_rental, customer_id_rental,
								[start_date], sk_film, film_id, studio_id, company_id, duration_time,
								amount)
				select 
				TimeKey,
				sk_customer_payment,
				customer_id_payment,
				state_id_customer_payment,
				sk_customer_rental,
				customer_id_rental,
				[start_date],
				sk_film,
				film_id,
				studio_id,
				company_id,
				duration_time,
				amount
				from tmp_Fact_Transaction_Rental

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Insert into Fact_Transaction_Rental');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Rental', 'Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into Fact_Transaction_Rental: ' + @errorMsg);
				return;
			end catch

		end				
		set @CurrentDate = DATEADD(DAY, 1, @CurrentDate);

	end

end

----------------------------------------create procedure ins_Fact_Daily_Rental   
create procedure ins_Fact_Daily_Rental
@fromDate date,
@toDate date
as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	declare @CurrentDate date;

    set @CurrentDate = @fromDate;
	
	while @CurrentDate <= @toDate
	begin 

		-- Truncate tmp1_Fact_Daily_Rental
		begin try
			set @startTime = GETDATE();

			truncate table tmp1_Fact_Daily_Rental;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'tmp1_Fact_Daily_Rental', @startTime, @endTime, 'Success', 'Truncate tmp1_Fact_Daily_Rental');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'tmp1_Fact_Daily_Rental', @startTime, @endTime, 'Failure', 'Error in truncating tmp1_Fact_Daily_Rental: ' + @errorMsg);
			return;
		end catch

		-- Truncate tmp2_Fact_Daily_Rental
		begin try
			set @startTime = GETDATE();

			truncate table tmp2_Fact_Daily_Rental;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'tmp2_Fact_Daily_Rental', @startTime, @endTime, 'Success', 'Truncate tmp2_Fact_Daily_Rental');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'tmp2_Fact_Daily_Rental', @startTime, @endTime, 'Failure', 'Error in truncating tmp2_Fact_Daily_Rental: ' + @errorMsg);
			return;
		end catch

		-- Truncate copy_Fact_Transaction_Rental
		begin try
			set @startTime = GETDATE();

			truncate table copy_Fact_Transaction_Rental;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'copy_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Truncate copy_Fact_Transaction_Rental');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'copy_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in truncating copy_Fact_Transaction_Rental: ' + @errorMsg);
			return;
		end catch

		-- Truncate tmp_Fact_Daily_Rental
		begin try
			set @startTime = GETDATE();

			truncate table tmp_Fact_Daily_Rental;

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'tmp_Fact_Daily_Rental', @startTime, @endTime, 'Success', 'Truncate tmp_Fact_Daily_Rental');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'tmp_Fact_Daily_Rental', @startTime, @endTime, 'Failure', 'Error in truncating tmp_Fact_Daily_Rental: ' + @errorMsg);
			return;
		end catch

		-- ########### insert into tmp1_Fact_Daily_Rental ###########
		begin try
			set @startTime = GETDATE();

			insert into tmp1_Fact_Daily_Rental(TimeKey, sk_film, film_id, studio_id)
			select 
			dd.TimeKey,
			df.SK_film,
			df.film_id,
			df.studio_id
			from Dim_Date dd cross join Dim_FILM df
			where format(convert(date, cast(dd.TimeKey as varchar(8)), 112), 'yyyy-MM-dd') = @CurrentDate
			and df.Current_Flag = 1

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'tmp1_Fact_Daily_Rental', @startTime, @endTime, 'Success', 'Insert into tmp1_Fact_Daily_Rental');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'tmp1_Fact_Daily_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into tmp1_Fact_Daily_Rental: ' + @errorMsg);
			return;
		end catch

		-- ########### insert into tmp2_Fact_Daily_Rental ###########
		begin try
			set @startTime = GETDATE();

			insert into tmp2_Fact_Daily_Rental(TimeKey, sk_film, film_id, studio_id, company_id)
			select 
			t1.TimeKey,
			t1.sk_film,
			t1.film_id,
			t1.studio_id,
			dco.company_id
			from tmp1_Fact_Daily_Rental t1 cross join Dim_COMPANY dco

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'tmp2_Fact_Daily_Rental', @startTime, @endTime, 'Success', 'Insert into tmp2_Fact_Daily_Rental');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'tmp2_Fact_Daily_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into tmp2_Fact_Daily_Rental: ' + @errorMsg);
			return;
		end catch

		-- ########### insert into copy_Fact_Transaction_Rental ###########
		begin try
			set @startTime = GETDATE();

			insert into copy_Fact_Transaction_Rental(TimeKey, film_id, studio_id, company_id, 
							number_of_rentals, total_duration, amount)
			select 
			TimeKey,
			film_id,
			studio_id,
			company_id,
			count (*),
			sum(duration_time),
			sum(amount)
			from Fact_Transaction_Rental
			where format(convert(date, cast(TimeKey as varchar(8)), 112), 'yyyy-MM-dd') = @CurrentDate
			group by TimeKey, film_id, studio_id, company_id

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'copy_Fact_Transaction_Rental', @startTime, @endTime, 'Success', 'Insert into copy_Fact_Transaction_Rental');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'copy_Fact_Transaction_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into copy_Fact_Transaction_Rental: ' + @errorMsg);
			return;
		end catch

		-- ########### insert into tmp_Fact_Daily_Rental ###########
		begin try
			set @startTime = GETDATE();

			insert into tmp_Fact_Daily_Rental(TimeKey, sk_film, film_id, studio_id, company_id, 
							number_of_rentals, total_duration, amount)
			select 
			t2.TimeKey,
			t2.sk_film,
			t2.film_id,
			t2.studio_id,
			t2.company_id,
			cftr.number_of_rentals,
			cftr.total_duration,
			cftr.amount
			from tmp2_Fact_Daily_Rental t2 left join copy_Fact_Transaction_Rental cftr
			on (t2.TimeKey = cftr.TimeKey and
				t2.film_id = cftr.film_id and
				t2.studio_id = cftr.studio_id and
				t2.company_id = cftr.company_id)

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'tmp_Fact_Daily_Rental', @startTime, @endTime, 'Success', 'Insert into tmp_Fact_Daily_Rental');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'tmp_Fact_Daily_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_Fact_Daily_Rental: ' + @errorMsg);
			return;
		end catch

		-- ########### insert into Fact_Daily_Rental ###########
		begin try
			set @startTime = GETDATE();

			insert into Fact_Daily_Rental(TimeKey, sk_film, film_id, studio_id, company_id, 
							number_of_rentals, total_duration, amount)
			select 
			TimeKey,
			sk_film,
			film_id,
			studio_id,
			company_id,
			number_of_rentals,
			total_duration,
			amount
			from tmp_Fact_Daily_Rental

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'Fact_Daily_Rental', @startTime, @endTime, 'Success', 'Insert into Fact_Daily_Rental');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_Daily_Rental', 'Fact_Daily_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into Fact_Daily_Rental: ' + @errorMsg);
			return;
		end catch
				
		set @CurrentDate = DATEADD(DAY, 1, @CurrentDate);

	end
	
end

----------------------------------------create procedure ins_Fact_ACC_Rental
create procedure ins_Fact_ACC_Rental 
@fromDate date,
@toDate date
as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);

	-- Truncate tmp_Fact_ACC_Rental
	begin try
		set @startTime = GETDATE();

		truncate table tmp_Fact_ACC_Rental;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Fact_ACC_Rental', 'tmp_Fact_ACC_Rental', @startTime, @endTime, 'Success', 'Truncate tmp_Fact_ACC_Rental');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Fact_ACC_Rental', 'tmp_Fact_ACC_Rental', @startTime, @endTime, 'Failure', 'Error in truncating tmp_Fact_ACC_Rental: ' + @errorMsg);
		return;
	end catch
	
	-- ########### Copy Fact_ACC_Rental to tmp_Fact_ACC_Rental ###########
	begin try
		set @startTime = GETDATE();

		insert into tmp_Fact_ACC_Rental(sk_film, film_id, studio_id, company_id, number_of_rentals, 
						total_duration, amount)
		select 
		sk_film,
		film_id,
		studio_id,
		company_id,
		number_of_rentals,
		total_duration,
		amount
		from Fact_ACC_Rental

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Fact_ACC_Rental', 'tmp_Fact_ACC_Rental', @startTime, @endTime, 'Success', 'Copy Fact_ACC_Rental to tmp_Fact_ACC_Rental');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Fact_ACC_Rental', 'tmp_Fact_ACC_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_Fact_ACC_Rental: ' + @errorMsg);
		return;
	end catch
		
	-- ########### Copy Fact_Daily_Rental to tmp_Fact_ACC_Rental ###########
	begin try
		set @startTime = GETDATE();

		insert into tmp_Fact_ACC_Rental(sk_film, film_id, studio_id, company_id, number_of_rentals, 
						total_duration, amount)
		select 
		max(sk_film),
		film_id,
		studio_id,
		company_id,
		sum(number_of_rentals),
		sum(total_duration),
		sum(amount)
		from Fact_Daily_Rental
		where format(convert(date, cast(TimeKey as varchar(8)), 112), 'yyyy-MM-dd') >= @fromDate 
		and format(convert(date, cast(TimeKey as varchar(8)), 112), 'yyyy-MM-dd') <= @toDate
		group by film_id, studio_id, company_id

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Fact_ACC_Rental', 'tmp_Fact_ACC_Rental', @startTime, @endTime, 'Success', 'Copy Fact_Daily_Rental to tmp_Fact_ACC_Rental');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Fact_ACC_Rental', 'tmp_Fact_ACC_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_Fact_ACC_Rental: ' + @errorMsg);
		return;
	end catch

	-- Truncate Fact_ACC_Rental
	begin try
		set @startTime = GETDATE();

		truncate table Fact_ACC_Rental;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Fact_ACC_Rental', 'Fact_ACC_Rental', @startTime, @endTime, 'Success', 'Truncate Fact_ACC_Rental');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Fact_ACC_Rental', 'Fact_ACC_Rental', @startTime, @endTime, 'Failure', 'Error in truncating Fact_ACC_Rental: ' + @errorMsg);
		return;
	end catch

	-- ########### insert into Fact_ACC_Rental ###########
	begin try
		set @startTime = GETDATE();

		insert into Fact_ACC_Rental(sk_film, film_id, studio_id, company_id, number_of_rentals, 
						total_duration, amount)
		select 
		max(sk_film),
		film_id,
		studio_id,
		company_id,
		sum(number_of_rentals),
		sum(total_duration),
		sum(amount)
		from tmp_Fact_ACC_Rental
		group by film_id, studio_id, company_id


		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Fact_ACC_Rental', 'Fact_ACC_Rental', @startTime, @endTime, 'Success', 'Insert into Fact_ACC_Rental');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Fact_ACC_Rental', 'Fact_ACC_Rental', @startTime, @endTime, 'Failure', 'Error in inserting into Fact_ACC_Rental: ' + @errorMsg);
		return;
	end catch

end

----------------------------------------create procedure ins_Factless_FilmActorRelation
create procedure ins_Factless_FilmActorRelation as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);

	-- Truncate tmp_Factless_FilmActorRelation
	begin try
		set @startTime = GETDATE();

		truncate table tmp_Factless_FilmActorRelation;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmActorRelation', 'tmp_Factless_FilmActorRelation', @startTime, @endTime, 'Success', 'Truncate tmp_Factless_FilmActorRelation');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmActorRelation', 'tmp_Factless_FilmActorRelation', @startTime, @endTime, 'Failure', 'Error in truncating tmp_Factless_FilmActorRelation: ' + @errorMsg);
		return;
	end catch

	-- Truncate Factless_FilmActorRelation
	begin try
		set @startTime = GETDATE();

		truncate table Factless_FilmActorRelation;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmActorRelation', 'Factless_FilmActorRelation', @startTime, @endTime, 'Success', 'Truncate Factless_FilmActorRelation');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmActorRelation', 'Factless_FilmActorRelation', @startTime, @endTime, 'Failure', 'Error in truncating Factless_FilmActorRelation: ' + @errorMsg);
		return;
	end catch

	-- ########### insert into tmp_Factless_FilmActorRelation ###########
	begin try
		set @startTime = GETDATE();

		insert into tmp_Factless_FilmActorRelation(sk_film, film_id, actor_id, [role])
		select 
		df.SK_film,
		fa.film_id,
		fa.actor_id,
		fa.[role]
		from Dim_FILM df join film_actor fa
		on (df.film_id = fa.film_id)
		where df.Current_Flag = 1 

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmActorRelation', 'tmp_Factless_FilmActorRelation', @startTime, @endTime, 'Success', 'Insert into tmp_Factless_FilmActorRelation');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmActorRelation', 'tmp_Factless_FilmActorRelation', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_Factless_FilmActorRelation: ' + @errorMsg);
		return;
	end catch

	-- ########### insert into Factless_FilmActorRelation ###########
	begin try
		set @startTime = GETDATE();

		insert into Factless_FilmActorRelation(sk_film, film_id, actor_id, [role])
		select 
		sk_film,
		film_id,
		actor_id,
		[role]
		from tmp_Factless_FilmActorRelation

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmActorRelation', 'Factless_FilmActorRelation', @startTime, @endTime, 'Success', 'Insert into Factless_FilmActorRelation');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmActorRelation', 'Factless_FilmActorRelation', @startTime, @endTime, 'Failure', 'Error in inserting into Factless_FilmActorRelation: ' + @errorMsg);
		return;
	end catch
		
end







--######################################################################################
--################################# # # # # # # # # # ##################################
--################################# Payment Facts ETL ##################################
--################################# # # # # # # # # # ##################################
--######################################################################################


-- ################### ins_Fact_Transaction_Payment ###################
create procedure ins_Fact_Transaction_Payment 
@fromDate date,
@toDate date
as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	declare @CurrentDate date;

	-- if this is not first time insert
	if (exists(select 1 from Fact_Transaction_Payment))
	begin
		
		set @CurrentDate = @fromDate

		-- start loop 
		while @CurrentDate <= @toDate
		begin

			-- ################### Truncate Tmp_Fact_Transaction_Payment ###################
			begin try
				set @startTime = GETDATE();

				truncate table [Tmp_Fact_Transaction_Payment]

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Tmp_Fact_Transaction_Payment', @startTime, @endTime, 'Success', 'Truncate Tmp_Fact_Transaction_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Tmp_Fact_Transaction_Payment', @startTime, @endTime, 'Failure', 'Error in truncating Tmp_Fact_Transaction_Payment: ' + @errorMsg);
				return;
			end catch
		

		
			-- ################### Truncate Tmp2_Fact_Transaction_Payment ###################
			begin try
				set @startTime = GETDATE();

				truncate table [Tmp2_Fact_Transaction_Payment]

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Tmp2_Fact_Transaction_Payment', @startTime, @endTime, 'Success', 'Truncate Tmp2_Fact_Transaction_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Tmp2_Fact_Transaction_Payment', @startTime, @endTime, 'Failure', 'Error in truncating Tmp2_Fact_Transaction_Payment: ' + @errorMsg);
				return;
			end catch
		

		
			-- ################### Truncate Tmp3_Fact_Transaction_Payment ###################
			begin try
				set @startTime = GETDATE();

				truncate table [Tmp3_Fact_Transaction_Payment]

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Tmp3_Fact_Transaction_Payment', @startTime, @endTime, 'Success', 'Truncate Tmp3_Fact_Transaction_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Tmp3_Fact_Transaction_Payment', @startTime, @endTime, 'Failure', 'Error in truncating Tmp3_Fact_Transaction_Payment: ' + @errorMsg);
				return;
			end catch
		

			-- ########### insert into Tmp2_Fact_Transaction_Payment ###########
			begin try
				set @startTime = GETDATE();


				insert into [Tmp2_Fact_Transaction_Payment] ([customer_id], [studio_id], [TimeKey], [paid_amount])
				select p.customer_account, 
					p.studio_account, 
					d.TimeKey, 
					p.amount
				from payment p join Dim_Date d on(p.payment_date = format(convert(date, cast(d.TimeKey as varchar(8)), 112), 'yyyy-MM-dd'))
				where p.payment_date = @CurrentDate


				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Tmp2_Fact_Transaction_Payment', @startTime, @endTime, 'Success', 'Insert into Tmp2_Fact_Transaction_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Tmp2_Fact_Transaction_Payment', @startTime, @endTime, 'Failure', 'Error in inserting into Tmp2_Fact_Transaction_Payment: ' + @errorMsg);
				return;
			end catch											


			
			-- ########### insert into Tmp3_Fact_Transaction_Payment from join Tmp2_Fact_Transaction_Payment with Dim_CUSTOMER ###########
			begin try
				set @startTime = GETDATE();


				insert into [Tmp3_Fact_Transaction_Payment] ([SK_customer], [customer_id], [studio_id], [TimeKey], [original_amount], [discount_amount], [paid_amount])
				select c.SK_customer, 
					t.[customer_id], 
					t.[studio_id],
					t.[TimeKey],
					t.[paid_amount] * (100.0 / (100.0 - c.discount_percent)) as [original_amount],
					t.[paid_amount] * (100.0 / (100.0 - c.discount_percent)) - t.[paid_amount] as [discount_amount],
					t.[paid_amount]
				from [Tmp2_Fact_Transaction_Payment] t join Dim_CUSTOMER c on(t.[customer_id] = c.customer_id) 
				where(c.Current_Flag = 1)


				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Tmp3_Fact_Transaction_Payment', @startTime, @endTime, 'Success', 'Insert into Tmp3_Fact_Transaction_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Tmp3_Fact_Transaction_Payment', @startTime, @endTime, 'Failure', 'Error in inserting into Tmp3_Fact_Transaction_Payment: ' + @errorMsg);
				return;
			end catch											



			-- ########### insert into Tmp_Fact_Transaction_Payment from join Tmp3_Fact_Transaction_Payment with Dim_STUDIO ###########
			begin try
				set @startTime = GETDATE();


				insert into [Tmp_Fact_Transaction_Payment] ([SK_customer], [customer_id], [company_id], [studio_id], [TimeKey], [original_amount], [discount_amount], [paid_amount], [our_commission_fee])
				select t.SK_customer, 
					t.[customer_id], 
					s.company_id,
					t.[studio_id],
					t.[TimeKey],
					t.[original_amount],
					t.[discount_amount],
					t.[paid_amount],
					t.[paid_amount] * (s.commission_percent / 100.0) as [our_commission_fee]
				from [Tmp3_Fact_Transaction_Payment] t join Dim_STUDIO s on(t.[studio_id] = s.studio_id) 


				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Tmp_Fact_Transaction_Payment', @startTime, @endTime, 'Success', 'Insert into Tmp_Fact_Transaction_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Tmp_Fact_Transaction_Payment', @startTime, @endTime, 'Failure', 'Error in inserting into Tmp_Fact_Transaction_Payment: ' + @errorMsg);
				return;
			end catch	

			

			-- ########### insert into Fact_Transaction_Payment from Tmp_Fact_Transaction_Payment ###########
			begin try
				set @startTime = GETDATE();


				insert into Fact_Transaction_Payment ([SK_customer], [customer_id], [company_id], [studio_id], [TimeKey], [original_amount], [discount_amount], [paid_amount], [our_commission_fee])
				select t.SK_customer, 
					t.[customer_id], 
					t.company_id,
					t.[studio_id],
					t.[TimeKey],
					t.[original_amount],
					t.[discount_amount],
					t.[paid_amount],
					t.[our_commission_fee]
				from [Tmp_Fact_Transaction_Payment] t


				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Fact_Transaction_Payment', @startTime, @endTime, 'Success', 'Insert into Fact_Transaction_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Transaction_Payment', 'Fact_Transaction_Payment', @startTime, @endTime, 'Failure', 'Error in inserting into Fact_Transaction_Payment: ' + @errorMsg);
				return;
			end catch	
			

			set @CurrentDate = DATEADD(DAY, 1, @CurrentDate);

		end
	end
end






-- ################### ins_Fact_Daily_Payment ###################

create procedure ins_Fact_Daily_Payment 
@fromDate date,
@toDate date
as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	declare @CurrentDate date;


	-- if this is not first time insert
	if (exists(select 1 from [Fact_Daily_Payment]))
	begin			
		
		-- max date Fact_Transaction_Payment
		set @CurrentDate = @fromDate

		-- start loop
		while @CurrentDate <= @toDate
		begin 

			-- ################### Truncate Tmp_Fact_Daily_Payment ###################
			begin try
				set @startTime = GETDATE();

				truncate table [Tmp_Fact_Daily_Payment]

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Tmp_Fact_Daily_Payment', @startTime, @endTime, 'Success', 'Truncate Tmp_Fact_Daily_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Tmp_Fact_Daily_Payment', @startTime, @endTime, 'Failure', 'Error in truncating Tmp_Fact_Daily_Payment: ' + @errorMsg);
				return;
			end catch



			-- ################### Truncate Tmp2_Fact_Daily_Payment ###################
			begin try
				set @startTime = GETDATE();

				truncate table [Tmp2_Fact_Daily_Payment]

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Tmp2_Fact_Daily_Payment', @startTime, @endTime, 'Success', 'Truncate Tmp2_Fact_Daily_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Tmp2_Fact_Daily_Payment', @startTime, @endTime, 'Failure', 'Error in truncating Tmp2_Fact_Daily_Payment: ' + @errorMsg);
				return;
			end catch
 

			-- ################### Truncate Tmp3_Fact_Daily_Payment ###################
			begin try
				set @startTime = GETDATE();

				truncate table [Tmp3_Fact_Daily_Payment]

				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Tmp3_Fact_Daily_Payment', @startTime, @endTime, 'Success', 'Truncate Tmp3_Fact_Daily_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Tmp3_Fact_Daily_Payment', @startTime, @endTime, 'Failure', 'Error in truncating Tmp3_Fact_Daily_Payment: ' + @errorMsg);
				return;
			end catch


			-- ########### insert into Tmp_Fact_Daily_Payment from cross join Dim_Date with Dim_STUDIO ###########
			begin try
				set @startTime = GETDATE();


				insert into [Tmp_Fact_Daily_Payment] ([TimeKey], [company_id], [studio_id])
				select d.TimeKey,
					s.company_id,
					s.studio_id
				from Dim_Date d cross join Dim_STUDIO s
				where format(convert(date, cast(d.TimeKey as varchar(8)), 112), 'yyyy-MM-dd') = @CurrentDate


				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Tmp_Fact_Daily_Payment', @startTime, @endTime, 'Success', 'Insert into Tmp_Fact_Daily_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Tmp_Fact_Daily_Payment', @startTime, @endTime, 'Failure', 'Error in inserting into Tmp_Fact_Daily_Payment: ' + @errorMsg);
				return;
			end catch	


			-- ########### copy current date data to Tmp2_Fact_Daily_Payment from Fact_Transaction_Payment ###########
			begin try
				set @startTime = GETDATE();


				insert into [Tmp2_Fact_Daily_Payment] ([TimeKey], [company_id], [studio_id], [number_of_transaction], [total_original_amount], 
							[total_discount_amount], [total_paid_amount], [average_paid_amount], [our_total_commission_fee])
				select p.TimeKey,
					p.company_id,
					p.studio_id,
					count(*),
					sum(p.original_amount),
					sum(p.discount_amount),
					sum(p.paid_amount),
					avg(p.paid_amount),
					sum(p.our_commission_fee)
				from Fact_Transaction_Payment p
				where format(convert(date, cast(p.TimeKey as varchar(8)), 112), 'yyyy-MM-dd') = @CurrentDate
				group by p.TimeKey, p.company_id, p.studio_id


				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Tmp2_Fact_Daily_Payment', @startTime, @endTime, 'Success', 'Insert into Tmp2_Fact_Daily_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Tmp2_Fact_Daily_Payment', @startTime, @endTime, 'Failure', 'Error in inserting into Tmp2_Fact_Daily_Payment: ' + @errorMsg);
				return;
			end catch
		


			-- ########### insert into Tmp3_Fact_Daily_Payment from left join Tmp_Fact_Daily_Payment with Tmp2_Fact_Daily_Payment ###########
			-- if doesnt exists data transaction for current date, measures will be null
			begin try
				set @startTime = GETDATE();


				insert into [Tmp3_Fact_Daily_Payment]([TimeKey], [company_id], [studio_id], [number_of_transaction], [total_original_amount], 
							[total_discount_amount], [total_paid_amount], [average_paid_amount], [our_total_commission_fee])
				select t.[TimeKey],
					t.[company_id],
					t.[studio_id],
					t2.[number_of_transaction],
					t2.[total_original_amount], 
					t2.[total_discount_amount], 
					t2.[total_paid_amount], 
					t2.[average_paid_amount], 
					t2.[our_total_commission_fee]
				from [Tmp_Fact_Daily_Payment] t left join [Tmp2_Fact_Daily_Payment] t2
				on (t.[TimeKey] = t2.[TimeKey]
					and t.[company_id] = t2.[company_id]
					and t.[studio_id] = t2.[studio_id])


				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Tmp3_Fact_Daily_Payment', @startTime, @endTime, 'Success', 'Insert into Tmp3_Fact_Daily_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Tmp3_Fact_Daily_Payment', @startTime, @endTime, 'Failure', 'Error in inserting into Tmp3_Fact_Daily_Payment: ' + @errorMsg);
				return;
			end catch



			-- ########### copy data to Fact_Daily_Payment from Tmp3_Fact_Daily_Payment ###########
			begin try
				set @startTime = GETDATE();


				insert into [Fact_Daily_Payment]([TimeKey], [company_id], [studio_id], [number_of_transaction], [total_original_amount], 
							[total_discount_amount], [total_paid_amount], [average_paid_amount], [our_total_commission_fee])
				select t.[TimeKey],
					t.[company_id],
					t.[studio_id],
					t.[number_of_transaction],
					t.[total_original_amount], 
					t.[total_discount_amount], 
					t.[total_paid_amount], 
					t.[average_paid_amount], 
					t.[our_total_commission_fee]
				from [Tmp3_Fact_Daily_Payment] t


				set @endTime = GETDATE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Fact_Daily_Payment', @startTime, @endTime, 'Success', 'Insert into Fact_Daily_Payment');
			end try

			begin catch
				set @endTime = GETDATE();
				set @errorMsg = ERROR_MESSAGE();
				insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
				values ('ins_Fact_Daily_Payment', 'Fact_Daily_Payment', @startTime, @endTime, 'Failure', 'Error in inserting into Fact_Daily_Payment: ' + @errorMsg);
				return;
			end catch


			set @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
		end
	end
end






-- ################### ins_Fact_ACC_Payment ###################

create procedure ins_Fact_ACC_Payment
@fromDate date,
@toDate date
as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);


	-- if this is not first time insert
	if (exists(select 1 from Fact_ACC_Rental))
	begin

		

		-- ################### Truncate tmp_Fact_ACC_Payment ###################
		begin try
			set @startTime = GETDATE();

			truncate table tmp_Fact_ACC_Payment

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_ACC_Payment', 'tmp_Fact_ACC_Payment', @startTime, @endTime, 'Success', 'Truncate tmp_Fact_ACC_Payment');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('ins_Fact_ACC_Payment', 'tmp_Fact_ACC_Payment', @startTime, @endTime, 'Failure', 'Error in truncating tmp_Fact_ACC_Payment: ' + @errorMsg);
			return;
		end catch


		-- ########### copy Fact_ACC_Payment to tmp_Fact_ACC_Payment ###########
		begin try
			set @startTime = GETDATE();


			insert into tmp_Fact_ACC_Payment (company_id, studio_id, number_of_transaction, total_original_amount, total_discount_amount, 
						total_paid_amount, average_paid_amount, our_total_commission_fee)
			select t.company_id,
				t.studio_id,
				t.number_of_transaction,
				t.total_original_amount,
				t.total_discount_amount,
				t.total_paid_amount,
				t.average_paid_amount,
				t.our_total_commission_fee
			from Fact_ACC_Payment t


			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('first_ins_Fact_ACC_Payment', 'tmp_Fact_ACC_Payment', @startTime, @endTime, 'Success', 'Insert into tmp_Fact_ACC_Payment');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('first_ins_Fact_ACC_Payment', 'tmp_Fact_ACC_Payment', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_Fact_ACC_Payment: ' + @errorMsg);
			return;
		end catch


		
		-- ################### Truncate Fact_ACC_Payment ###################
		begin try
			set @startTime = GETDATE();

			truncate table [Fact_ACC_Payment]

			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('first_ins_Fact_ACC_Payment', 'Fact_ACC_Payment', @startTime, @endTime, 'Success', 'Truncate Fact_ACC_Payment');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('first_ins_Fact_ACC_Payment', 'Fact_ACC_Payment', @startTime, @endTime, 'Failure', 'Error in truncating Fact_ACC_Payment: ' + @errorMsg);
			return;
		end catch



		-- ########### insert to tmp_Fact_ACC_Payment from Fact_Daily_Payment ###########
		begin try
			set @startTime = GETDATE();


			insert into tmp_Fact_ACC_Payment (company_id, studio_id, number_of_transaction, total_original_amount, total_discount_amount, 
						total_paid_amount, average_paid_amount, our_total_commission_fee)
			select t.[company_id],
				t.[studio_id],
				sum(t.number_of_transaction),
				sum(t.[total_original_amount]), 
				sum(t.[total_discount_amount]), 
				sum(t.[total_paid_amount]), 
				avg(t.[total_paid_amount]), 
				sum(t.[our_total_commission_fee])
			from [Fact_Daily_Payment] t
			where format(convert(date, cast(t.TimeKey as varchar(8)), 112), 'yyyy-MM-dd') >= @fromDate 
				and format(convert(date, cast(t.TimeKey as varchar(8)), 112), 'yyyy-MM-dd') <= @toDate
			group by t.company_id, t.studio_id


			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('first_ins_Fact_ACC_Payment', 'tmp_Fact_ACC_Payment', @startTime, @endTime, 'Success', 'Insert into tmp_Fact_ACC_Payment');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('first_ins_Fact_ACC_Payment', 'tmp_Fact_ACC_Payment', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_Fact_ACC_Payment: ' + @errorMsg);
			return;
		end catch



		-- ########### insert to Fact_ACC_Payment from [tmp_Fact_ACC_Payment] ###########
		begin try
			set @startTime = GETDATE();


			insert into [Fact_ACC_Payment] (company_id, studio_id, number_of_transaction, total_original_amount, total_discount_amount, 
						total_paid_amount, average_paid_amount, our_total_commission_fee)
			select t.[company_id],
				t.[studio_id],
				sum(t.number_of_transaction),
				sum(t.[total_original_amount]), 
				sum(t.[total_discount_amount]), 
				sum(t.[total_paid_amount]), 
				sum(t.[total_paid_amount]) / sum(t.number_of_transaction) * 1.0,
				sum(t.[our_total_commission_fee])
			from tmp_Fact_ACC_Payment t
			group by t.company_id, t.studio_id


			set @endTime = GETDATE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('first_ins_Fact_ACC_Payment', 'Fact_ACC_Payment', @startTime, @endTime, 'Success', 'Insert into Fact_ACC_Payment');
		end try

		begin catch
			set @endTime = GETDATE();
			set @errorMsg = ERROR_MESSAGE();
			insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
			values ('first_ins_Fact_ACC_Payment', 'Fact_ACC_Payment', @startTime, @endTime, 'Failure', 'Error in inserting into Fact_ACC_Payment: ' + @errorMsg);
			return;
		end catch


	end
end



--##################### create procedure ins_Factless_FilmCategoryRelation ########################

create procedure ins_Factless_FilmCategoryRelation as
begin
    declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
		
	-- Truncate tmp_Factless_FilmCategoryRelation
	begin try
		set @startTime = GETDATE();

		truncate table tmp_Factless_FilmCategoryRelation;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmCategoryRelation', 'tmp_Factless_FilmCategoryRelation', @startTime, @endTime, 'Success', 'Truncate tmp_Factless_FilmCategoryRelation');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmCategoryRelation', 'tmp_Factless_FilmCategoryRelation', @startTime, @endTime, 'Failure', 'Error in truncating tmp_Factless_FilmCategoryRelation: ' + @errorMsg);
		return;
	end catch

	-- Truncate Factless_FilmCategoryRelation
	begin try
		set @startTime = GETDATE();

		truncate table Factless_FilmCategoryRelation;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmCategoryRelation', 'Factless_FilmCategoryRelation', @startTime, @endTime, 'Success', 'Truncate Factless_FilmCategoryRelation');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmCategoryRelation', 'Factless_FilmCategoryRelation', @startTime, @endTime, 'Failure', 'Error in truncating Factless_FilmCategoryRelation: ' + @errorMsg);
		return;
	end catch

	-- ########### insert into tmp_Factless_FilmCategoryRelation ###########
	begin try
		set @startTime = GETDATE();

		insert into tmp_Factless_FilmCategoryRelation(sk_film, film_id, category_id)
		select 
		df.SK_film,
		fc.film_id,
		fc.category_id
		from Dim_FILM df join film_category fc
		on (df.film_id = fc.film_id)
		where df.Current_Flag = 1

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmCategoryRelation', 'tmp_Factless_FilmCategoryRelation', @startTime, @endTime, 'Success', 'Insert into tmp_Factless_FilmCategoryRelation');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmCategoryRelation', 'tmp_Factless_FilmCategoryRelation', @startTime, @endTime, 'Failure', 'Error in inserting into tmp_Factless_FilmCategoryRelation: ' + @errorMsg);
		return;
	end catch

	-- ########### insert into Factless_FilmCategoryRelation ###########
	begin try
		set @startTime = GETDATE();

		insert into Factless_FilmCategoryRelation(sk_film, film_id, category_id)
		select 
		sk_film,
		film_id,
		category_id
		from tmp_Factless_FilmCategoryRelation

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmCategoryRelation', 'Factless_FilmCategoryRelation', @startTime, @endTime, 'Success', 'Insert into Factless_FilmCategoryRelation');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_Factless_FilmCategoryRelation', 'Factless_FilmCategoryRelation', @startTime, @endTime, 'Failure', 'Error in inserting into Factless_FilmCategoryRelation: ' + @errorMsg);
		return;
	end catch
		
end





--#############################################################################################################
--################################ # # # # # # # # # # # # # # # # # # # # # # ################################
--################################ Having the main_procedure to use in the job ################################
--################################ # # # # # # # # # # # # # # # # # # # # # # ################################
--#############################################################################################################


-- Find the number of days behind the data warehouse from the staging area
create procedure Last_day_in_SA 
@MaxDate date output
as
begin
    select @MaxDate = max(payment_date) from payment;
end


create procedure Last_day_in_DW 
@MinDate date output
as
begin
    select @MinDate = DATEADD(DAY, 1, max(format(convert(date, cast(TimeKey as varchar(8)), 112), 'yyyy-MM-dd'))) from Fact_Daily_Rental;
end




-- main procedure
create procedure main_procedure_SA_To_DW as
begin
	
	-- drop foreign key constraints to can truncate dimensions
	execute drop_all_DW_foreign_key

	-- Domension procedures:
	exec ins_Dim_CUSTOMER
	exec ins_Dim_STUDIO
	exec ins_Dim_COMPANY
	exec ins_Dim_FILM
	exec ins_Dim_STATE
	exec ins_Dim_CATEGORY
	exec ins_Dim_ACTOR

	-- add foreign key constraints again
	execute add_all_DW_foreign_key

	declare @Start_date date;
	declare @Last_date date;

	exec Last_day_in_DW @MinDate = @Start_date output
	exec Last_day_in_SA @MaxDate = @Last_date output

	-- rental facts procedures:

	exec ins_Fact_Transaction_Rental @fromDate = @Start_date, @toDate = @Last_date

	exec ins_Fact_Daily_Rental @fromDate = @Start_date, @toDate = @Last_date

	exec ins_Fact_ACC_Rental @fromDate = @Start_date, @toDate = @Last_date

	exec ins_Factless_FilmActorRelation


	-- payment facts procedures:

	exec ins_Fact_Transaction_Payment @fromDate = @Start_date, @toDate = @Last_date

	exec ins_Fact_Daily_Payment @fromDate = @Start_date, @toDate = @Last_date

	exec ins_Fact_ACC_Payment @fromDate = @Start_date, @toDate = @Last_date

	exec ins_Factless_FilmCategoryRelation
end


