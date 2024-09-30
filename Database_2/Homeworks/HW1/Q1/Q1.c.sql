
-- Q1.c)

DROP TABLE IF EXISTS sales_details3;
CREATE TABLE [dbo].[sales_details3](
	[BranchId] [float] NULL,
	[Productid] [float] NULL,
	[Jalali-D] [float] NULL,
	[Jalali-M] [float] NULL,
	[Jalali-Y] [float] NULL,
	[total_sales] [float] NULL
) ON [PRIMARY];






-- calculate Quartiles:
WITH Sum_sales as(
	select s.*,
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY unitssold) OVER (PARTITION BY branchid, productid) AS Q1,
		PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY unitssold) OVER (PARTITION BY branchid, productid) AS Q2,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY unitssold) OVER (PARTITION BY branchid, productid) AS Q3,
		avg(s.unitssold) over (PARTITION BY s.branchid, s.productid) as avg_sold,
		sum(s.unitssold) over (PARTITION BY s.branchid, s.productid, [Jalali-D], [Jalali-M], [Jalali-Y]) as total_sales
	from sales_details2 as s
),
Quartiles AS(
	SELECT branchid, productid, [Jalali-D], [Jalali-M], [Jalali-Y], Q1, Q2, Q3, avg_sold, total_sales,
		(Q3 - Q1) AS IQR, -- calculate IQR
		Q1- 1.5*(Q3 - Q1) as Lower_bound,
		Q3+ 1.5*(Q3 - Q1) as Upper_bound
	FROM Sum_sales
)



--insert into a temp table called xtable:
select distinct * into xtable from Quartiles



select *
from xtable
where total_sales < Lower_bound or total_sales > Upper_bound
order by branchid, productid


update xtable
set total_sales = case 
	when total_sales < Lower_bound then avg_sold
	when total_sales > Upper_bound then avg_sold
	else total_sales
end


-- insert into sales_details3 from xtable
insert into sales_details3
select branchid, productid, [Jalali-D], [Jalali-M], [Jalali-Y], total_sales
from xtable


select * from sales_details3
order by branchid, productid


drop table xtable



