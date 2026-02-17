select * from retail_sales;
CREATE TABLE retail_sales{
transactions_id INT,
sales_date date,
sale_time time without time zone,
customer_id int,
gender varchar(10),
age int,
category varchar(15),
quantity varchar(1)
}

SELECT COUNT(*) as total_sales FROM retail_sales;

SELECT * FROM retail_sales WHERE 
transactions_id is null 
or
sales_date is null
or 
sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null

delete from retail_sales 
WHERE 
transactions_id is null 
or
sales_date is null
or 
sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null

--data exploration

select distinct customer_id from retail_sales

--data analysis or business key problems ans answers

--all columns forsales made on '2022-11-05'
select * from retail_sales
where sales_date='2022-11-05'

--all transactions where the category is 'clothing' and the quantity is more than 10 in the month of 'nov-2022'
select * from retail_sales 
where category='Clothing'
and quantity > 2
and to_char(sales_date,'YYYY-MM') ='2022-11'

--total sales for each category
select category,
	sum(total_sale) as net_sale,
	count(*) as total_sale
from retail_sales
group by 1

--average age of the person who purchased form 'Beauty' category

select round(avg(age),2) 
from retail_sales
where category='Beauty'

--transactions where the total_sales is more than 1000

select * 
from retail_sales
where total_sale > 1000

--total number of transactions done by each gender

select gender, 
	category,
	sum(transactions_id) 
from retail_sales
group by category,
	gender
order by 1

--find the average total_sales for each month and find out the best selling month

select 
	year,
	month,
	avg_sale
from(
select 
	extract(year from sales_date) as year,
	extract(month from sales_date) as month,
	avg(total_sale) as avg_sale,
	rank() over(partition by extract(year from sales_date) order by avg(total_sale) desc)
from retail_sales
group by 1,2
) as t1
	where rank=1

--find the top 5 customers based on the highest sales

select customer_id,
	sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by 2 desc
limit 5

--number of unique customers who purchased from each category

select category,
	count(distinct customer_id)
from retail_sales
group by category

--sql query to create shifts and number of orders (morning <12 afternoon between 12 and 17 evening >17)

with hourly_sale 
as(
select *,
	case
		when extract(hour from sale_time)<12 then 'Morning' 
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shifts
	from retail_sales
	)
select shifts,
count(*) as total_orders
from hourly_sale
group by shifts

--end of project
