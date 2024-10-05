--1
set transaction isolation level read Committed
begin transaction

update production.Product
  set color='black'
  where Color='no color'

select *
from production.Location
rollback




--2 
--dirty read
set transaction isolation level read uncommitted
select Color 
from production.product
where Color='no color'

-------------------------

--non repeatable read
set transaction isolation level read uncommitted;
begin transaction
update production.product
  set Name='arezoo1'
  where ProductID=3
waitfor delay '00:00:12'
rollback

