-- SQL Retail Sales Analysis - P1
-- Create Table 
Drop Table if exists retail_sales;
Create Table retail_sales
   (
      transactions_id INT primary key,
      sale_date Date,
      sale_time	 Time,
      customer_id Int,
	  gender  varchar(15),
      age	int,
	  category	varchar(15),
      quantiy	int,
      price_per_unit	float,
      cogs	float,
      total_sale float
     );

ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;


Select * from retail_sales;

-- Limit 10 rows
Select * from retail_sales limit 10;
-- count rows
Select count(*) from retail_sales;
--------------------------------------------------------

-- Data Cleaning

-- checking null values 
Select * from retail_sales where transactions_id is NULL;
Select * from retail_sales where sale_date is NULL;

-- now check null values in all columns

Select * from retail_sales
where 
     transactions_id is null 
	 or
	 sale_date is null
	 or 
	 sale_time is null
	 or
	 customer_id is null
	 or
	 gender is null
	 or 
	 age is null
	 or
	 category is null
	 or
	 quantity is null
	 or 
	 price_per_unit is null
	 or 
	 cogs is null
	 or 
	 total_sale is null;
	 

-- deleting rows with null values

Delete from retail_sales
where 
     transactions_id is null 
	 or
	 sale_date is null
	 or 
	 sale_time is null
	 or
	 customer_id is null
	 or
	 gender is null
	 or 
	 age is null
	 or
	 category is null
	 or
	 quantity is null
	 or 
	 price_per_unit is null
	 or 
	 cogs is null
	 or 
	 total_sale is null;

-- count total no of rows 
select count(*) from retail_sales;

---------------------------------------------------------------------

-- Data Exploration

-- How many sales we have?
Select count(*) as total_sale from retail_sales;
-- How many unique customers we have?
Select count(distinct customer_id) as total_sale from retail_sales;
-- How many unique categories we have?
Select distinct category  from retail_sales;

-------------------------------------------------------------------------

-- Data Analysis and Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
Select * from retail_sales where sale_date ='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4

--  Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
Select round(avg(age),2) as avg_age from retail_sales where category='Beauty' 

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
Select * from retail_sales where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
Select category,gender,count(*) 
as total_transactions 
from retail_sales 
group by category,gender
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
Select 
      year,month,avg_sale
	  from (
         Select 
		   EXTRACT(YEAR FROM sale_date) as year,
           EXTRACT(MONTH FROM sale_date) as month,
           AVG(total_sale) as avg_sale,
		   RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
           FROM retail_sales
           GROUP BY 1, 2
	  ) as t1
	  where rank=1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
Select customer_id,sum(total_sale) as total_sales
from retail_sales group by 1
order by 2 desc 
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
Select category,count(distinct customer_id) as Unique_customers from retail_sales group by 1

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift



-- End of project



