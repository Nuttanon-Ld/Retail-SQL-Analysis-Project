SELECT *
FROM Retail_Sale_data 
LIMIT 10;

SELECT count(*)
FROM Retail_Sale_data ;
--
SELECT *
FROM Retail_Sale_data
WHERE sale_time is NULL ;

--Data Cleaning
SELECT *
FROM Retail_Sale_data
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
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
	total_sale IS NULL
	;
	
-- DELETE NULL
DELETE FROM Retail_Sale_data
WHERE
transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
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
	total_sale IS NULL
	;
	
SELECT count(*)
FROM Retail_Sale_data ;

-- Data Exploration

--How many sales we have?
SELECT count(*) as total
FROM Retail_Sale_data;

--How many unique customer we have?
SELECT count(DISTINCT customer_id) as customer
FROM Retail_Sale_data;

--what  category we have?
SELECT DISTINCT category as category
FROM Retail_Sale_data;

-- Data Analysis & Business Key Problems & Answers

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

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM Retail_Sale_data
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is >= 4 in the month of Nov-2022
SELECT *
FROM Retail_Sale_data
WHERE
		category = 'Clothing'
		AND
		quantiy >= 4
		AND 
		strftime('%Y-%m', sale_date) = '2022-11';
		
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category , sum(total_sale) as Total,count(*) as Total_Order
FROM Retail_Sale_data 
GROUP by category 
ORDER by Total DESC;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT round(avg(age),2) as Avg_age,count(*) as Number_customer,category
FROM Retail_Sale_data 
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM Retail_Sale_data 
WHERE total_sale >= 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender , category , count(transactions_id) as Transactions_Count
FROM Retail_Sale_data
GROUP by gender,category
ORDER by category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH monthly_avg AS (
  SELECT 
    strftime('%Y', sale_date) AS year,
    strftime('%m', sale_date) AS month,
    ROUND(AVG(total_sale), 2) AS avg_sale
  FROM Retail_Sale_data
  GROUP BY year, month
),
ranked AS (
  SELECT *,
         RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rank_in_year
  FROM monthly_avg
)
SELECT *
FROM ranked
WHERE rank_in_year = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	customer_id,
	sum(total_sale) as total_sales
FROM Retail_Sale_data
GROUP by customer_id
ORDER by total_sales DESC
LIMIT 5;

WITH customer_sales AS (
  SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
  FROM Retail_Sale_data
  GROUP BY customer_id
),
ranked_customers AS (
  SELECT 
    customer_id,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
  FROM customer_sales
)
SELECT *
FROM ranked_customers
WHERE sales_rank <= 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
  category,
  COUNT(DISTINCT customer_id) AS unique_customers
FROM Retail_Sale_data
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT 
  CASE 
    WHEN CAST(strftime('%H', sale_time) AS INTEGER) <= 12 THEN 'Morning'
    WHEN CAST(strftime('%H', sale_time) AS INTEGER) > 12 AND CAST(strftime('%H', sale_time) AS INTEGER) <= 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS shift,
  COUNT(*) AS number_of_orders
FROM Retail_Sale_data
GROUP BY shift;



