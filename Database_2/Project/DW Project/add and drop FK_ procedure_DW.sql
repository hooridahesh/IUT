use [DW_sakila]
Go

create procedure drop_all_DW_foreign_key as
begin
	alter table [Fact_Transaction_Rental]
	drop CONSTRAINT FK_date_Transaction_Rental, FK_Customer_payment_Transaction_Rental,
		FK_Customer_rental_Transaction_Rental, FK_state_Transaction_Rental, FK_film_Transaction_Rental, 
		FK_startDate_Transaction_Rental, FK_studio_Transaction_Rental, FK_company_Transaction_Rental

	alter table [Fact_Daily_Rental]
	drop CONSTRAINT FK_date_Daily_Rental, FK_film_Daily_Rental, 
		FK_studio_Daily_Rental, FK_company_Daily_Rental

	alter table [Fact_ACC_Rental]
	drop CONSTRAINT FK_film_ACC_Rental, FK_studio_ACC_Rental, FK_company_ACC_Rental

	alter table [Factless_FilmActorRelation]
	drop CONSTRAINT FK_film_Factless_Rental, FK_actor_Factless_Rental

	alter table [Fact_Transaction_Payment]
	drop CONSTRAINT FK_customer_Transaction_Payment, FK_studio_Transaction_Payment,
		FK_company_Transaction_Payment, FK_date_Transaction_Payment

	alter table [Fact_Daily_Payment]
	drop CONSTRAINT FK_studio_Daily_Payment, FK_company_Daily_Payment, FK_date_Daily_Payment

	alter table [Fact_ACC_Payment]
	drop CONSTRAINT FK_studio_ACC_Payment, FK_company_ACC_Payment

	alter table [Factless_FilmCategoryRelation]
	drop CONSTRAINT FK_film_Factless_Payment, FK_category_Factless_Payment
end



create procedure add_all_DW_foreign_key as
begin
	alter table [Fact_Transaction_Rental]
	ADD CONSTRAINT FK_date_Transaction_Rental FOREIGN KEY([TimeKey]) REFERENCES [dbo].[Dim_Date](TimeKey),
    CONSTRAINT FK_startDate_Transaction_Rental FOREIGN KEY([start_date]) REFERENCES [dbo].[Dim_Date](TimeKey),
    CONSTRAINT FK_Customer_payment_Transaction_Rental FOREIGN KEY([sk_customer_payment]) REFERENCES [dbo].[Dim_CUSTOMER]([SK_customer]),
    CONSTRAINT FK_Customer_rental_Transaction_Rental FOREIGN KEY([sk_customer_payment]) REFERENCES [dbo].[Dim_CUSTOMER]([SK_customer]),
    CONSTRAINT FK_state_Transaction_Rental FOREIGN KEY([state_id_customer_payment]) REFERENCES [dbo].[Dim_STATE]([state_id]),
    CONSTRAINT FK_film_Transaction_Rental FOREIGN KEY([sk_film]) REFERENCES [dbo].[Dim_FILM]([SK_film]),
    CONSTRAINT FK_studio_Transaction_Rental FOREIGN KEY([studio_id]) REFERENCES [dbo].[Dim_STUDIO]([studio_id]),
    CONSTRAINT FK_company_Transaction_Rental FOREIGN KEY([company_id]) REFERENCES [dbo].[Dim_COMPANY]([company_id])


	alter table [Fact_Daily_Rental]
	ADD CONSTRAINT FK_date_Daily_Rental FOREIGN KEY([TimeKey]) REFERENCES [dbo].[Dim_Date](TimeKey),
    CONSTRAINT FK_film_Daily_Rental FOREIGN KEY([sk_film]) REFERENCES [dbo].[Dim_FILM]([SK_film]),
    CONSTRAINT FK_studio_Daily_Rental FOREIGN KEY([studio_id]) REFERENCES [dbo].[Dim_STUDIO]([studio_id]),
    CONSTRAINT FK_company_Daily_Rental FOREIGN KEY([company_id]) REFERENCES [dbo].[Dim_COMPANY]([company_id])


	alter table [Fact_ACC_Rental]
	ADD CONSTRAINT FK_film_ACC_Rental FOREIGN KEY([sk_film]) REFERENCES [dbo].[Dim_FILM]([SK_film]),
    CONSTRAINT FK_studio_ACC_Rental FOREIGN KEY([studio_id]) REFERENCES [dbo].[Dim_STUDIO]([studio_id]),
    CONSTRAINT FK_company_ACC_Rental FOREIGN KEY([company_id]) REFERENCES [dbo].[Dim_COMPANY]([company_id])


	alter table [Factless_FilmActorRelation]
	ADD CONSTRAINT FK_film_Factless_Rental FOREIGN KEY([sk_film]) REFERENCES [dbo].[Dim_FILM]([SK_film]),
    CONSTRAINT FK_actor_Factless_Rental FOREIGN KEY([actor_id]) REFERENCES [dbo].[Dim_ACTOR]([actor_id])


	alter table [Fact_Transaction_Payment]
	ADD CONSTRAINT FK_customer_Transaction_Payment FOREIGN KEY([SK_customer]) REFERENCES [dbo].[Dim_CUSTOMER] ([SK_customer]),
	CONSTRAINT FK_studio_Transaction_Payment FOREIGN KEY([studio_id]) REFERENCES [dbo].[Dim_STUDIO] ([studio_id]),
	CONSTRAINT FK_company_Transaction_Payment FOREIGN KEY([company_id]) REFERENCES [dbo].[Dim_COMPANY] ([company_id]),
	CONSTRAINT FK_date_Transaction_Payment FOREIGN KEY([TimeKey]) REFERENCES [dbo].[Dim_Date] ([TimeKey])


	alter table [Fact_Daily_Payment]
	ADD CONSTRAINT FK_studio_Daily_Payment  FOREIGN KEY([studio_id]) REFERENCES [dbo].[Dim_STUDIO] ([studio_id]),
	CONSTRAINT FK_company_Daily_Payment FOREIGN KEY([company_id]) REFERENCES [dbo].[Dim_COMPANY] ([company_id]),
	CONSTRAINT FK_date_Daily_Payment FOREIGN KEY([TimeKey]) REFERENCES [dbo].[Dim_Date] ([TimeKey])


	alter table [Fact_ACC_Payment]
	ADD CONSTRAINT FK_studio_ACC_Payment FOREIGN KEY([studio_id]) REFERENCES [dbo].[Dim_STUDIO] ([studio_id]),
	CONSTRAINT FK_company_ACC_Payment FOREIGN KEY([company_id]) REFERENCES [dbo].[Dim_COMPANY] ([company_id])


	alter table [Factless_FilmCategoryRelation]
	ADD CONSTRAINT FK_film_Factless_Payment FOREIGN KEY([sk_film]) REFERENCES [dbo].[Dim_FILM]([SK_film]), 
    CONSTRAINT FK_category_Factless_Payment FOREIGN KEY([category_id]) REFERENCES [dbo].[Dim_CATEGORY]([category_id])

end




