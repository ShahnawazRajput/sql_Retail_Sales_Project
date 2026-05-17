-- SQL Retail Sales Analysis 

CREATE DATABASE Sales_Project;

-- Create Table
DROP TABLE IF EXISTS Retail_Sales;
CREATE TABLE Retail_Sales
		(
			transactions_id INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id	INT,
			gender VARCHAR(15),
			age	INT,
			category VARCHAR(15),
			quantity INT,
			price_per_unit	FLOAT,
			cogs FLOAT,
			total_sale FLOAT
		)
SELECT * FROM Retail_Sales
LIMIT 10

SELECT 
	COUNT(*) 
from Retail_Sales

-- Data cleaning
SELECT * FROM Retail_Sales
WHERE transactions_id IS NULL

SELECT * FROM Retail_Sales
WHERE sale_date IS NULL

SELECT * FROM Retail_Sales
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
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

--
DELETE FROM Retail_Sales 
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
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- Date Exploration

-- How Many Sale We have?
SELECT COUNT(*) FROM Retail_Sales;

--How Many Customer We Have
SELECT COUNT(DISTINCT customer_id) FROM Retail_Sales;


SELECT DISTINCT category FROM Retail_Sales;

--Data Analysis & Business Key Problems & Answer

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM Retail_Sales
WHERE sale_date='2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM Retail_Sales
WHERE 
	category='Clothing'
	AND
	quantity>=4
	AND
	sale_date>='2022-11-01' AND sale_date<='2022-11-30'

SELECT *
FROM Retail_Sales
WHERE 
	category='Clothing'
	AND
	quantity>=4
	AND
	TO_CHAR(sale_date,'YYYY-MM')='2022-11'

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	Category,
	SUM(total_sale),
	COUNT(*) AS Total_Orders
from Retail_Sales
GROUP BY category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT 
	Category,
	ROUND(AVG(age),2) as Avg_Age
FROM Retail_Sales
GROUP BY 1
HAVING Category='Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM Retail_Sales
WHERE Total_Sale>1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT 
	Category,
	gender,
	COUNT(*) as Number_transactions
FROM Retail_Sales
GROUP
	BY
	category,
	gender

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
	Year,
	Month_Name,
	Avg_Sale
FROM
(
SELECT
	EXTRACT(YEAR FROM Sale_Date) AS Year,
	TO_CHAR(sale_date,'Month') as Month_Name,
	AVG(total_sale) as Avg_sale,
	RANK()OVER(PARTITION BY EXTRACT(YEAR FROM Sale_Date) ORDER BY AVG(total_sale) DESC) AS RANK
FROM Retail_Sales
GROUP BY 1,2 ) AS T1
	WHERE Rank=1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
	customer_id,
	SUM(total_sale) as total_sale
FROM Retail_Sales
GROUP BY 1
ORDER BY total_sale DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category

SELECT 
	category,
	COUNT(DISTINCT customer_id) AS Count_uni_cs
FROM Retail_Sales
GROUP BY 1

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH Hourly_Sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM Sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS Shift
FROM Retail_sales )
SELECT 
	Shift,
	COUNT(*) AS Num_Orders
FROM Hourly_sale
GROUP BY Shift

--End of Project





