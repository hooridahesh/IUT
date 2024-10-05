--1
set transaction isolation level read committed
begin transaction
update Production.Location
  set Name = 'tehran2'
waitfor delay '00:00:10'
select * from Production.Product
rollback




--2 
--dirty read
set transaction isolation level read uncommitted
begin transaction
update production.product
set Color='no color'
where Color='Black'
waitfor delay '00:00:10'
rollback transaction
select Color
from production.product 
where Color='Black'

------
--update
begin transaction
update production.product
  set color='Black'
  where Color='no color'
commit

------------------

--Non Repeatable Read
set transaction isolation level read uncommitted;
begin transaction
select Name
from production.product
where ProductID=3
waitfor delay '00:00:08'
select Name
from production.product
where ProductID=3
rollback 



