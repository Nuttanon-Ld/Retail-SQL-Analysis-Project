# 🧠 Retail SQL Analysis Project

This project showcases my practice in writing SQL queries using a retail sales dataset. The objective is to perform **data cleaning**, **exploration**, and **business analysis** using SQL.

## 📁 Files Included
- `Retail_SQL_Practise1.sql`: Contains all SQL queries for data cleaning, exploration, and analysis.
- `Retail_db.db`: SQLite database used for executing the queries.

## ✅ Topics Covered
- **Data Cleaning**: Remove NULLs and check missing values.
- **Data Exploration**:
  - Total number of sales
  - Number of unique customers
  - List of product categories
- **Business Analysis**:
  - Top selling customers
  - Category-wise sales summary
  - Sales by time shifts (Morning, Afternoon, Evening)
  - Monthly performance analysis
  - Customer behavior in specific categories

## 🧪 Sample Queries

### 🔹 Top 5 customers based on total sales
```sql
SELECT 
  customer_id,
  SUM(total_sale) AS total_sales
FROM Retail_Sale_data
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```
🔹 Average sale per month and top month each year
```sql
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
```

🔧 Tools Used
SQL (SQLite dialect)

DB Browser for SQLite
