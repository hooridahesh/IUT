use [SA_sakila]
Go

create procedure drop_all_SA_foreign_key as
begin
	ALTER TABLE [dbo].[state]
		drop constraint FK_CountryState;

	ALTER TABLE [dbo].[company]
		drop CONSTRAINT FK_StateCompany;

	ALTER TABLE [dbo].[studio]
		drop CONSTRAINT FK_StateStudio, FK_CompanyStudio;

	ALTER TABLE [dbo].[customer]
		drop CONSTRAINT FK_StateCustomer;

	ALTER TABLE [dbo].[actor]
		drop CONSTRAINT FK_StateActor;

	ALTER TABLE [dbo].[film]
		drop CONSTRAINT FK_StudioFilm, FK_LanguageFilm, FK_OriginalLanguageFilm;

	ALTER TABLE [dbo].[film_actor]
		drop CONSTRAINT FK_Actor_filmActor, FK_Film_filmActor;

	ALTER TABLE [dbo].[film_category]
		drop CONSTRAINT FK_Film_filmCategory, FK_Category_filmCategory;

	ALTER TABLE [dbo].[rental]
		drop CONSTRAINT FK_FilmRental, FK_CustomerRental;

	ALTER TABLE [dbo].[payment]
		drop CONSTRAINT FK_RentalPayment, FK_CustomerPayment, FK_StudioPayment;

end;


create procedure add_all_SA_foreign_key as
begin
	ALTER TABLE [dbo].[state]
		ADD CONSTRAINT FK_CountryState FOREIGN KEY([country_id]) REFERENCES [dbo].[country] ([country_id]);

	ALTER TABLE [dbo].[company]
		ADD CONSTRAINT FK_StateCompany FOREIGN KEY([state_id]) REFERENCES [dbo].[state] ([state_id]);

	ALTER TABLE [dbo].[studio]
		ADD CONSTRAINT FK_StateStudio FOREIGN KEY([state_id]) REFERENCES [dbo].[state] ([state_id]),
		CONSTRAINT FK_CompanyStudio FOREIGN KEY([company_id]) REFERENCES [dbo].[company] ([company_id]);

	ALTER TABLE [dbo].[customer]
		ADD CONSTRAINT FK_StateCustomer FOREIGN KEY([state_id]) REFERENCES [dbo].[state] ([state_id]);

	ALTER TABLE [dbo].[actor]
		ADD CONSTRAINT FK_StateActor FOREIGN KEY([state_id]) REFERENCES [dbo].[state] ([state_id]);

	ALTER TABLE [dbo].[film]
		ADD CONSTRAINT FK_StudioFilm FOREIGN KEY([studio_id]) REFERENCES [dbo].[studio] ([studio_id]),
		CONSTRAINT FK_LanguageFilm FOREIGN KEY([language_id]) REFERENCES [dbo].[language] ([language_id]),
		CONSTRAINT FK_OriginalLanguageFilm FOREIGN KEY([original_language_id]) REFERENCES [dbo].[language] ([language_id]);

	ALTER TABLE [dbo].[film_actor]
		ADD CONSTRAINT FK_Actor_filmActor FOREIGN KEY([actor_id]) REFERENCES [dbo].[actor] ([actor_id]),
		CONSTRAINT FK_Film_filmActor FOREIGN KEY([film_id]) REFERENCES [dbo].[film] ([film_id]);

	ALTER TABLE [dbo].[film_category]
		ADD CONSTRAINT FK_Film_filmCategory FOREIGN KEY([film_id]) REFERENCES [dbo].[film] ([film_id]),
		CONSTRAINT FK_Category_filmCategory FOREIGN KEY([category_id]) REFERENCES [dbo].[category] ([category_id]);

	ALTER TABLE [dbo].[rental]
		ADD CONSTRAINT FK_FilmRental FOREIGN KEY([film_id]) REFERENCES [dbo].[film] ([film_id]),
		CONSTRAINT FK_CustomerRental FOREIGN KEY([customer_id]) REFERENCES [dbo].[customer] ([customer_id]);

	ALTER TABLE [dbo].[payment]
		ADD CONSTRAINT FK_RentalPayment FOREIGN KEY([rental_id]) REFERENCES [dbo].[rental] ([rental_id]),
		CONSTRAINT FK_CustomerPayment FOREIGN KEY([customer_account]) REFERENCES [dbo].[customer] ([customer_id]),
		CONSTRAINT FK_StudioPayment FOREIGN KEY([studio_account]) REFERENCES [dbo].[studio] ([studio_id])
		
end;