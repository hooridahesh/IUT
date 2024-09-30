-- Q1.a)
--create database Sales

-- Load data by wizard in the sales_details table


-- Q1.b)

DROP TABLE IF EXISTS sales_details2;
CREATE TABLE [dbo].[sales_details2](
	[BranchId] [float] NULL,
	[Productid] [float] NULL,
	[Invoicenum] [float] Null,
	[Unitssold] [float] NULL,
	[Jalali-D] [float] NULL,
	[Jalali-M] [float] NULL,
	[Jalali-Y] [float] NULL
) ON [PRIMARY];


-- Creating a temporary table to detect incorrect records:
with temp_sales as(
	select s.*,
		count(*) over(partition by s.branchid, s.invoicenum) as cnt_all_product_per_invoice,
		count(*) over(partition by s.branchid, s.invoicenum, s.[Jalali-D], s.[Jalali-M], s.[Jalali-Y]) as cnt_today_product_per_invoice,

		-- The following count value shows whether a productid has appeared several times with an invoicenum in a branch or not (if it is greater than one, it is a problem):
		count(*) over(partition by s.branchid, s.Productid, s.invoicenum) as cnt_same_product
	from Sales_details as s
)


insert into sales_details2
select BranchId, Productid, Invoicenum, Unitssold, [Jalali-D], [Jalali-M], [Jalali-Y]
from temp_sales

except

select BranchId, Productid, Invoicenum, Unitssold, [Jalali-D], [Jalali-M], [Jalali-Y]
from temp_sales
where cnt_all_product_per_invoice <> cnt_today_product_per_invoice  or cnt_same_product > 1



select * from sales_details2
order by BranchId, Invoicenum

