-- SQL Retail Sales Analysis
CREATE DATABASE SQL_PROJECT_P2;

-- Create table
CREATE TABLE RETAIL_SALES
(
     transactions_id INT PRIMARY KEY,
     sale_date       DATE,
	 sale_time	     TIME,
	 customer_id	 INT,
	 gender	         VARCHAR(15),
	 age	         INT,
	 category	     VARCHAR(15),
	 quantiy	     INT,
	 price_per_unit	 FLOAT,
	 cogs	         FLOAT,
	 total_sale      FLOAT
)

-- Data Cleaning
SELECT * FROM RETAIL_SALES WHERE 
TRANSACTIONS_ID IS NULL
OR
SALE_DATE IS NULL
OR
SALE_TIME IS NULL
OR
CUSTOMER_ID IS NULL
OR
GENDER IS NULL
OR
AGE IS NULL
OR
CATEGORY IS NULL
OR
QUANTIY IS NULL
OR
PRICE_PER_UNIT IS NULL
OR
COGS IS NULL
OR
TOTAL_SALE IS NULL

DELETE FROM RETAIL_SALES
WHERE CATEGORY IS NULL
OR
QUANTIY IS NULL
OR
PRICE_PER_UNIT IS NULL
OR
COGS IS NULL
OR
TOTAL_SALE IS NULL

-- Data EXploration

-- How many sales we have?

SELECT COUNT(*) AS TOTAL_SALES FROM RETAIL_SALES

-- How many unique customers we have?

SELECT COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_CUSTOMERS FROM RETAIL_SALES

SELECT DISTINCT CATEGORY AS CATEGORY FROM RETAIL_SALES

-- Data Analysis

-- Q.1 Write a SQL query  to retrieve all columns for sales made on 2022-11-05

SELECT * 
FROM RETAIL_SALES
WHERE SALE_DATE = '2022-11-05'

/* Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 
in the month of Nov-2022*/

SELECT * 
FROM RETAIL_SALES
WHERE CATEGORY = 'Clothing'
AND QUANTIY >= 4
AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'

-- Q.3 Write a SQL query to calculate the total sales for each category

SELECT CATEGORY, SUM(TOTAL_SALE) AS TOTAL_SALES
FROM RETAIL_SALES
GROUP BY CATEGORY

--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

SELECT ROUND(AVG(AGE), 2) AS AVG_AGE
FROM RETAIL_SALES
WHERE CATEGORY = 'Beauty'
AND AGE IS NOT NULL

--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT *
FROM RETAIL_SALES
WHERE TOTAL_SALE > 1000

--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

SELECT GENDER, CATEGORY, COUNT(TRANSACTIONS_ID) AS TOTAL_TRANS
FROM RETAIL_SALES
GROUP BY GENDER, CATEGORY
ORDER BY CATEGORY

--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH MONTHLY_SALES AS (
    SELECT 
        EXTRACT(YEAR FROM SALE_DATE) AS YEAR,
        EXTRACT(MONTH FROM SALE_DATE) AS MONTH,
        ROUND(AVG(TOTAL_SALE)::NUMERIC, 2) AS AVG_SALE
    FROM RETAIL_SALES
    GROUP BY 1,2
)
SELECT YEAR, month, AVG_SALE
FROM (
    SELECT 
        YEAR,
        MONTH,
        AVG_SALE,
        RANK() OVER (PARTITION BY year ORDER BY AVG_SALE DESC) AS RNK
    FROM MONTHLY_SALES
) t
WHERE RNK = 1;

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT CUSTOMER_ID, SUM(TOTAL_SALE) AS TOTAL_SALES
FROM RETAIL_SALES
GROUP BY CUSTOMER_ID
ORDER BY 2 DESC
FETCH FIRST 5 ROWS ONLY

--Q.9 Write a SQL query to find the number of unique customers who purchased items for each category

SELECT CATEGORY, COUNT(DISTINCT CUSTOMER_ID) AS UNIQUE_CUST
FROM RETAIL_SALES
GROUP BY CATEGORY

--Q.10 Write a SQL query to create each shift and  number of orders(Example Morning <= 12, Afternoon between 12 & 17, Evening > 17)

WITH HOURLY_SALES AS(
SELECT *,
CASE WHEN EXTRACT(HOUR FROM SALE_TIME) < 12 THEN 'Morning'
     WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'Afternoon'
	 ELSE 'Evening'
	 END AS Shift
FROM RETAIL_SALES
)

SELECT SHIFT, COUNT(*) AS TOTAL_ORDERS
FROM HOURLY_SALES
GROUP BY SHIFT

