
-- this script use in ETL job 

use SA_sakila
Go;

exec main_procedure_SourceToSA



use DW_sakila
Go;

exec main_procedure_SA_To_DW