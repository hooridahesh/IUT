
--************************************* ins_language *************************************
use SA_sakila
go;

create procedure ins_language as
begin
	declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	-- truncate language table:
	begin try
		--execute procedure to drop all foreign key constraints
		exec drop_all_SA_foreign_key

		set @startTime = GETDATE();

		truncate table [language];

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_language', 'language', @startTime, @endTime, 'Success', 'Truncate language');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_language', 'language', @startTime, @endTime, 'Failure', 'Error in truncating language: ' + @errorMsg);

		--execute procedure to add all foreign key constraints
		exec add_all_SA_foreign_key

		return;
	end catch


	-- insert into language sa table from source:
	begin try
		set @startTime = GETDATE();

		insert into [language](language_id, name)
		select language_id, [name]
		from source_language

		set @endTime = GETDATE();

		--execute procedure to add all foreign key constraints
		exec add_all_SA_foreign_key
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_language', 'language', @startTime, @endTime, 'Success', 'insert into language from source');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_language', 'language', @startTime, @endTime, 'Failure', 'Error in inserting into language from source: ' + @errorMsg);
		return;
	end catch

end




--************************************* ins_country *************************************

create procedure ins_country as
begin
	declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	-- truncate country table:
	begin try
		exec drop_all_SA_foreign_key

		set @startTime = GETDATE();

		truncate table country;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_country', 'country', @startTime, @endTime, 'Success', 'Truncate country');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_country', 'country', @startTime, @endTime, 'Failure', 'Error in truncating country: ' + @errorMsg);
		
		exec add_all_SA_foreign_key

		return;
	end catch


	-- insert into country sa table from source:
	begin try
		set @startTime = GETDATE();

		insert into country(country_id, country)
		select country_id, country
		from source_country

		set @endTime = GETDATE();

		exec add_all_SA_foreign_key

		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_country', 'country', @startTime, @endTime, 'Success', 'insert into country from source');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_country', 'country', @startTime, @endTime, 'Failure', 'Error in inserting into country from source: ' + @errorMsg);
		return;
	end catch
end




		
--************************************* ins_state *************************************

create procedure ins_state as
begin
	declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	-- truncate state table:
	begin try
		exec drop_all_SA_foreign_key

		set @startTime = GETDATE();

		truncate table [state];

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_state', 'state', @startTime, @endTime, 'Success', 'Truncate state');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_state', 'state', @startTime, @endTime, 'Failure', 'Error in truncating state: ' + @errorMsg);
		
		exec add_all_SA_foreign_key

		return;
	end catch


	-- insert into state sa table from source:
	begin try
		set @startTime = GETDATE();

		insert into [state] (state_id, state, country_id)
		select state_id, state, country_id
		from source_state

		set @endTime = GETDATE();

		exec add_all_SA_foreign_key

		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_state', 'state', @startTime, @endTime, 'Success', 'insert into state from source');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_state', 'state', @startTime, @endTime, 'Failure', 'Error in inserting into state from source: ' + @errorMsg);
		return;
	end catch
end





--************************************* ins_company *************************************

create procedure ins_company as
begin
	declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	-- truncate company table:
	begin try
		exec drop_all_SA_foreign_key

		set @startTime = GETDATE();

		truncate table company;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_company', 'company', @startTime, @endTime, 'Success', 'Truncate company');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_company', 'company', @startTime, @endTime, 'Failure', 'Error in truncating company: ' + @errorMsg);
		
		exec add_all_SA_foreign_key

		return;
	end catch


	-- insert into company sa table from source:
	begin try
		set @startTime = GETDATE();

		insert into company (company_id, name, state_id)
		select company_id, name, state_id
		from source_company

		set @endTime = GETDATE();

		exec add_all_SA_foreign_key
		
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_company', 'company', @startTime, @endTime, 'Success', 'insert into company from source');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_company', 'company', @startTime, @endTime, 'Failure', 'Error in inserting into company from source: ' + @errorMsg);
		return;
	end catch
end





--************************************* ins_studio *************************************

create procedure ins_studio as
begin
	declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	-- truncate studio table:
	begin try
		exec drop_all_SA_foreign_key

		set @startTime = GETDATE();

		truncate table studio;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_studio', 'studio', @startTime, @endTime, 'Success', 'Truncate studio');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_studio', 'studio', @startTime, @endTime, 'Failure', 'Error in truncating studio: ' + @errorMsg);
		
		exec add_all_SA_foreign_key
		
		return;
	end catch


	-- insert into studio sa table from source:
	begin try
		set @startTime = GETDATE();

		insert into studio (studio_id, company_id, name, state_id, commission_percent)
		select studio_id, company_id, name, state_id, commission_percent
		from source_studio

		set @endTime = GETDATE();
		
		exec add_all_SA_foreign_key

		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_studio', 'studio', @startTime, @endTime, 'Success', 'insert into studio from source');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_studio', 'studio', @startTime, @endTime, 'Failure', 'Error in inserting into studio from source: ' + @errorMsg);
		return;
	end catch
end





--************************************* ins_customer *************************************

create procedure ins_customer as
begin
	declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	-- truncate customer table:
	begin try
		exec drop_all_SA_foreign_key

		set @startTime = GETDATE();

		truncate table customer;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_customer', 'customer', @startTime, @endTime, 'Success', 'Truncate customer');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_customer', 'customer', @startTime, @endTime, 'Failure', 'Error in truncating customer: ' + @errorMsg);
		
		exec add_all_SA_foreign_key
		
		return;
	end catch


	-- insert into customer sa table from source:
	begin try
		set @startTime = GETDATE();

		insert into customer(customer_id, first_name, last_name, email, discount_percent, state_id, date_of_birth, gender)
		select customer_id, first_name, last_name, email, discount_percent, state_id, date_of_birth,
			case 
				when gender = 0 then 'Male'
				else 'Female'
			end as gender
		from source_customer

		set @endTime = GETDATE();
		
		exec add_all_SA_foreign_key

		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_customer', 'customer', @startTime, @endTime, 'Success', 'insert into customer from source');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_customer', 'customer', @startTime, @endTime, 'Failure', 'Error in inserting into customer from source: ' + @errorMsg);
		return;
	end catch
end





--************************************* ins_actor *************************************

create procedure ins_actor as
begin
	declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	-- truncate actor table:
	begin try
		exec drop_all_SA_foreign_key

		set @startTime = GETDATE();

		truncate table actor;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_actor', 'actor', @startTime, @endTime, 'Success', 'Truncate actor');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_actor', 'actor', @startTime, @endTime, 'Failure', 'Error in truncating actor: ' + @errorMsg);
		
		exec add_all_SA_foreign_key
		
		return;
	end catch


	-- insert into actor sa table from source:
	begin try
		set @startTime = GETDATE();

		insert into actor(actor_id, first_name, last_name, date_of_birth, state_id, gender)
		select actor_id, first_name, last_name, date_of_birth, state_id,
			case 
				when gender = 0 then 'Male'
				else 'Female'
			end as gender
		from source_actor

		set @endTime = GETDATE();
		
		exec add_all_SA_foreign_key

		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_actor', 'actor', @startTime, @endTime, 'Success', 'insert into actor from source');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_actor', 'actor', @startTime, @endTime, 'Failure', 'Error in inserting into actor from source: ' + @errorMsg);
		return;
	end catch
end





--************************************* ins_category *************************************

create procedure ins_category as
begin
	declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	-- truncate category table:
	begin try
		exec drop_all_SA_foreign_key

		set @startTime = GETDATE();

		truncate table category;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_category', 'category', @startTime, @endTime, 'Success', 'Truncate category');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_category', 'category', @startTime, @endTime, 'Failure', 'Error in truncating category: ' + @errorMsg);
		
		exec add_all_SA_foreign_key
		
		return;
	end catch


	-- insert into category sa table from source:
	begin try
		set @startTime = GETDATE();

		insert into category(category_id, name)
		select category_id, name
		from source_category

		set @endTime = GETDATE();
		
		exec add_all_SA_foreign_key

		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_category', 'category', @startTime, @endTime, 'Success', 'insert into category from source');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_category', 'category', @startTime, @endTime, 'Failure', 'Error in inserting into category from source: ' + @errorMsg);
		return;
	end catch
end






--************************************* ins_film *************************************

create procedure ins_film as
begin
	declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	-- truncate film table:
	begin try
		exec drop_all_SA_foreign_key

		set @startTime = GETDATE();

		truncate table film;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_film', 'film', @startTime, @endTime, 'Success', 'Truncate film');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_film', 'film', @startTime, @endTime, 'Failure', 'Error in truncating film: ' + @errorMsg);
		
		exec add_all_SA_foreign_key
		
		return;
	end catch


	-- insert into film sa table from source:
	begin try
		set @startTime = GETDATE();

		insert into film (film_id, title, release_year, studio_id, language_id, original_language_id, rental_price, length, rating)
		select film_id, title, release_year, studio_id, language_id, original_language_id, rental_price, length, rating
		from source_film

		set @endTime = GETDATE();
		
		exec add_all_SA_foreign_key

		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_film', 'film', @startTime, @endTime, 'Success', 'insert into film from source');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_film', 'film', @startTime, @endTime, 'Failure', 'Error in inserting into film from source: ' + @errorMsg);
		return;
	end catch
end




--************************************* ins_film_actor *************************************

create procedure ins_film_actor as
begin
	declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	-- truncate film_actor table:
	begin try
		exec drop_all_SA_foreign_key

		set @startTime = GETDATE();

		truncate table film_actor;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_film_actor', 'film_actor', @startTime, @endTime, 'Success', 'Truncate film_actor');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_film_actor', 'film_actor', @startTime, @endTime, 'Failure', 'Error in truncating film_actor: ' + @errorMsg);
		
		exec add_all_SA_foreign_key
		
		return;
	end catch


	-- insert into film_actor sa table from source:
	begin try
		set @startTime = GETDATE();

		insert into film_actor(actor_id, film_id, role)
		select actor_id, film_id, role
		from source_film_actor

		set @endTime = GETDATE();
		
		exec add_all_SA_foreign_key

		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_film_actor', 'film_actor', @startTime, @endTime, 'Success', 'insert into film_actor from source');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_film_actor', 'film_actor', @startTime, @endTime, 'Failure', 'Error in inserting into film_actor from source: ' + @errorMsg);
		return;
	end catch
end





--************************************* ins_film_category *************************************

create procedure ins_film_category as
begin
	declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	-- truncate film_category table:
	begin try
		exec drop_all_SA_foreign_key

		set @startTime = GETDATE();

		truncate table film_category;

		set @endTime = GETDATE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_film_category', 'film_category', @startTime, @endTime, 'Success', 'Truncate film_category');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_film_category', 'film_category', @startTime, @endTime, 'Failure', 'Error in truncating film_category: ' + @errorMsg);
		
		exec add_all_SA_foreign_key
		
		return;
	end catch


	-- insert into film_category sa table from source:
	begin try
		set @startTime = GETDATE();

		insert into film_category(film_id, category_id)
		select film_id, category_id
		from source_film_category

		set @endTime = GETDATE();
		
		exec add_all_SA_foreign_key

		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_film_category', 'film_category', @startTime, @endTime, 'Success', 'insert into film_category from source');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_film_category', 'film_category', @startTime, @endTime, 'Failure', 'Error in inserting into film_category from source: ' + @errorMsg);
		return;
	end catch
end







--************************************* ins_rental *************************************

create procedure ins_rental as
begin
	declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	declare @currentDate Date;
	declare @maxDate Date;

	-- If the procedure has already been executed and there is records in rental table
	if exists(select rental_id from rental)
	begin 
		-- The current date is equal to the max day in rental table +1 day
		set @currentDate = (select max(rental_date) from rental)
		set @currentDate = DATEADD(day, 1, @currentDate) 
	end

	-- If this is the first time this procedure is executed:
	else
	begin
		set @currentDate = (select min(rental_date) from source_rental)
	end

	set @maxDate = (select max(rental_date) from source_rental)


	-- insert into rental sa table from source:
	begin try
		set @startTime = GETDATE();

		-- start loop
		while ( @currentDate <= @maxDate)
		begin
			insert into rental (rental_id, rental_date, customer_id, type, duration_time, film_id)
			select rental_id, rental_date, customer_id, type, duration_time, film_id
			from source_rental
			where rental_date >= @currentDate and rental_date < DATEADD(day, 1, @currentDate)
		
			set @currentDate = DATEADD(day, 1, @currentDate)
		end

		set @endTime = GETDATE();
		
		exec add_all_SA_foreign_key

		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_rental', 'rental', @startTime, @endTime, 'Success', 'insert into rental from source');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_rental', 'rental', @startTime, @endTime, 'Failure', 'Error in inserting into rental from source: ' + @errorMsg);
		return;
	end catch


end






--************************************* ins_payment *************************************

create procedure ins_payment as
begin
	declare @startTime datetime;
    declare @endTime datetime;
    declare @errorMsg nvarchar(4000);
	
	declare @currentDate Date;
	declare @maxDate Date;

	-- If the procedure has already been executed and there is records in payment table
	if exists(select payment_id from payment)
	begin 
		-- The current date is equal to the max day in payment table +1 day
		set @currentDate = (select max(payment_date) from payment)
		set @currentDate = DATEADD(day, 1, @currentDate) 
	end

	-- If this is the first time this procedure is executed:
	else
	begin
		set @currentDate = (select min(payment_date) from source_payment)
	end

	set @maxDate = (select max(payment_date) from source_payment)


	-- insert into payment sa table from source:
	begin try
		set @startTime = GETDATE();

		-- start loop
		while ( @currentDate <= @maxDate)
		begin
			insert into payment (payment_id, rental_id, customer_account, studio_account, amount, payment_date)
			select payment_id, rental_id, customer_account, studio_account, amount, payment_date
			from source_payment
			where payment_date >= @currentDate and payment_date < DATEADD(day, 1, @currentDate)
		
			set @currentDate = DATEADD(day, 1, @currentDate)
		end

		set @endTime = GETDATE();
		
		exec add_all_SA_foreign_key

		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_payment', 'payment', @startTime, @endTime, 'Success', 'insert into payment from source');
	end try

	begin catch
		set @endTime = GETDATE();
		set @errorMsg = ERROR_MESSAGE();
		insert into ETL_Log (ProcedureName, TableName, StartTime, EndTime, Status, Description)
		values ('ins_payment', 'payment', @startTime, @endTime, 'Failure', 'Error in inserting into payment from source: ' + @errorMsg);
		return;
	end catch
	
end





--################################ main_procedure to execute other procedures ################################

create procedure main_procedure_SourceToSA as
begin

	execute ins_language

	execute ins_country

	execute ins_state

	execute ins_company

	execute ins_studio

	execute ins_customer

	execute ins_actor

	execute ins_category

	execute ins_film

	execute ins_film_actor

	execute ins_film_category

	execute ins_rental

	execute ins_payment

end
