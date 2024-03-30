---------------------------
----------GENERIC----------
---------------------------

-- 01. How many unique cities does the data have?
SELECT 	ROW_NUMBER() OVER() AS row_num,
	city
FROM sales
GROUP BY city;

-- 02. In which city is each branch?
SELECT 	DISTINCT city,
	branch
FROM sales;

---------------------------
---------PRODUCTS----------
---------------------------

-- 03. How many unique product lines does the data have?
SELECT 	ROW_NUMBER() OVER() AS productlines_num, 
	product_line
FROM sales
GROUP BY product_line;

-- 04. What is the most selling product line?
SELECT	product_line,
	COUNT(quantity) as qty
FROM sales
GROUP BY product_line
ORDER BY qty DESC LIMIT 1;

-- 05. What is the total revenue by month?
SELECT	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month;

-- 06. What month had the largest COGS?
SELECT 	month_name AS month,
		SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs DESC LIMIT 1;

-- 07. What product line had the largest revenue?
SELECT 	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC LIMIT 1;

-- 08. What is the city with the largest revenue?
SELECT	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue DESC LIMIT 1;

-- 09. What product line had the largest VAT?
SELECT	product_line,
		SUM(tax_pct) as total_vat
FROM sales
GROUP BY product_line
ORDER BY total_vat DESC LIMIT 1;

-- 10. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 	product_line,
	ROUND(AVG(total),2) AS avg_sales,
	(CASE
		WHEN AVG(total) > (SELECT AVG(total) FROM sales) THEN "Good"
		ELSE "Bad"
	END) AS criteria
FROM sales
GROUP BY product_line
ORDER BY avg_sales;

-- 11. Which branch sold more products than average product sold?
SELECT 	branch
FROM sales
GROUP BY branch
HAVING AVG(total) > (SELECT AVG(total) FROM sales)
ORDER BY branch;

-- 12. What is the most common product line by gender?
SELECT *
FROM 	(SELECT	gender,
			product_line,
			COUNT(gender) AS total_cnt
	FROM sales
	WHERE gender = "Female"
        GROUP BY gender, product_line
        ORDER BY total_cnt DESC LIMIT 1) f
UNION ALL
SELECT *
FROM	(SELECT	gender,
		product_line,
		COUNT(gender) AS total_cnt
	FROM sales
	WHERE gender = "Male"
        GROUP BY gender, product_line
        ORDER BY total_cnt DESC LIMIT 1) m
;

-- 13. What is the average rating of each product line?
SELECT	product_line,
	ROUND(AVG(rating), 2) as avg_rating		
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

---------------------------
---------CUSTOMERS---------
---------------------------

-- 14. How many unique customer types does the data have?
SELECT 	ROW_NUMBER() OVER() AS row_num, 
	customer_type
FROM sales
GROUP BY customer_type;

-- 15. How many unique payment methods does the data have?
SELECT 	ROW_NUMBER() OVER() AS row_num, 
		payment
FROM sales
GROUP BY payment;

-- 16. What is the most common customer type?
SELECT	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC LIMIT 1;

-- 17. Which customer type buys the most?
SELECT	customer_type,
	SUM(total) as total_spend
FROM sales
GROUP BY customer_type
ORDER BY total_spend DESC LIMIT 1;

-- 18. What is the gender of most of the customers?
SELECT	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- 19. What is the gender distribution per branch?
SELECT 	branch,
	gender,
        COUNT(*) as gender_cnt
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender;

-- 20. Which time of the day do customers give most ratings?
SELECT	time_of_day,
	COUNT(rating) AS rating_cnt
FROM sales
GROUP BY time_of_day
ORDER BY rating_cnt DESC LIMIT 1;

-- 21. Which time of the day do customers give most ratings per branch?
SELECT *
FROM (SELECT branch, time_of_day, COUNT(rating) AS rating_cnt
	FROM sales
	WHERE branch = "A"
	GROUP BY time_of_day
	ORDER BY rating_cnt DESC LIMIT 1) A
UNION
SELECT *
FROM (SELECT branch, time_of_day, COUNT(rating) AS rating_cnt
	FROM sales
	WHERE branch = "B"
	GROUP BY time_of_day
	ORDER BY rating_cnt DESC LIMIT 1) B
UNION
SELECT *
FROM (SELECT branch, time_of_day, COUNT(rating) AS rating_cnt
	FROM sales
	WHERE branch = "C"
	GROUP BY time_of_day
	ORDER BY rating_cnt DESC LIMIT 1) C
;

-- 22. Which day of the week has the best average ratings?
SELECT	day_name,
	ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC LIMIT 1;

-- 23. Which day of the week has the best average ratings per branch?
SELECT *
FROM (SELECT branch, day_name, ROUND(AVG(rating),2) AS avg_rating
	FROM sales
	WHERE branch = "A"
	GROUP BY day_name 
	ORDER BY avg_rating DESC LIMIT 1) A
UNION
SELECT *
FROM (SELECT branch, day_name, ROUND(AVG(rating),2) AS avg_rating
	FROM sales
	WHERE branch = "B"
	GROUP BY day_name 
	ORDER BY avg_rating DESC LIMIT 1) B
UNION
SELECT *
FROM (SELECT branch, day_name, ROUND(AVG(rating),2) AS avg_rating
	FROM sales
	WHERE branch = "C"
	GROUP BY day_name 
	ORDER BY avg_rating DESC LIMIT 1) C
;

---------------------------
-----------SALES-----------
---------------------------

-- 24. Which of the customer types brings the most revenue?
SELECT	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- 25. Which city has the largest tax/VAT percent?
SELECT	city,
	ROUND(AVG(tax_pct), 2) AS tax_percent
FROM sales
GROUP BY city 
ORDER BY tax_percent DESC LIMIT 1;

-- 26. Which customer type pays the most in VAT?
SELECT	customer_type,
	ROUND(AVG(tax_pct),2) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax DESC;
