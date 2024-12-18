CREATE TABLE retail_sales(
transactions_id INT,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantiy INT,
price_per_unit INT,
cogs FLOAT,
total_sale INT
);

SELECT * FROM retail_sales;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

--data cleaning
SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	----
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

SELECT 
     COUNT(*)
FROM retail_sales;

---Data exploration
--- How many sales do we have?

SELECT COUNT(*)as total_sale FROM retail_sales
-- total no.of records for sales	

-- Check how many unique customers?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales

SELECT DISTINCT category FROM retail_sales

--Data analysis or business key problems and answers
--q1.Write an SQL query to retrieve all columns for sales made on 2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--q2.write a SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 4 in the month of nov-2022?	

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
   AND
   TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
   AND
   quantiy >= 4


--q3.Write a SQL query to caluclate the total sales (total sale)for each cateogry.

SELECT category,
SUM(total_sale) as net_sale,
COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1

--q4.write a SQL query to find the average age of customers who purchased items from the beauty "cateogry"

SELECT ROUND(AVG(age), 2) AS avg_age
from retail_sales
where category = 'Beauty';

--q5.Write a sql query to find all the transcations where the total_sale is greater than 1000

SELECT *
FROM retail_sales
WHERE total_sale>1000;

--q6.Write a sql query to find the total no.of transactions made by each gender in each category

SELECT category, gender,
COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category,gender
ORDER BY 1

--Q7.write a SQL query to calculate the average sale for each month.find out best selling month in each year

SELECT * FROM
(
SELECT 
EXTRACT (YEAR FROM sale_date) AS year,
EXTRACT (MONTH FROM sale_date) AS month,
AVG(total_sale) AS avg_sale,
RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale) DESC) AS RANK
FROM retail_sales
GROUP BY 1,2
) AS t1
WHERE rank = 1

--q8.write SQL query to find top 5 customers based on the highest total sales

SELECT customer_id,
SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q9.write a SQL query to find the no of unique customers who purchased items from each category
SELECT category,
COUNT (DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category

--q10.write a sql query to create each shift and no of orders(eg-morning <=12 , afternoon between 12&17 ,evening 17 clock))
WITH hourly_sales
AS
(
SELECT *,
     CASE 
	 WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
	 WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	 ELSE 'Evening'
	 END AS shift
FROM retail_sales
)
SELECT 
shift,
COUNT (*) AS total_sales
FROM hourly_sales
GROUP BY shift

-- end of project 1 