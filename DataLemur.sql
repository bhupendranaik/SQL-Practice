-- PostgreSQL 14 Based Answers
-- (BASIC: SELECT, WHERE,logical(>,<,=,!=,<>,>=,<=),AND,OR,NOT,BETWEEN..AND, IN, LIKE, NOT LIKE, ORDER BY(ASC,DESC)
--  INTERMEDIATE: SUM(),AVG(),COUNT(),GROUP BY,HAVING,DISTINCT,ARITHMETIC(+,-,*,/,%,^),MATH(ABS(),ROUND(__,n),CEIL(),FLOOR(),POWER(),MOD()),
--            CAST(__ AS DECIMAL or FLOAT), IS NULL, IS NOT NULL, COALESCE(column_name, 'expression'), IFNULL(), CASE(WHEN..THEN..ELSE..END), JOINS,
--            DATE FUNCTIONS(CURRENT_DATE or CURDATE, CURRENT_TIME or CURTIME and CURRENT TIMESTAMP or NOW(),EXTRACT(),
--            INTERVAL(SELECT DATE_ADD(CURRENT_DATE, INTERVAL 5 DAY); ,SELECT DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH);) ,
--            STR_TO_DATE(SELECT STR_TO_DATE('2025-03-18', '%Y-%m-%d');),  CAST('2025-03-18' AS DATE)
--  ADVANCED: CTE AND SUBQUERY, Window Function(ROW,RANK,DENSE RANK,
-- Q.1 Your given a products table, which contains data about different Microsoft Azure cloud products.
-- Soln
select * from products;

-- Q.2 Given the reviews table, write a query to retrieve the average star rating
-- for each product, grouped by month. The output should display the month as a
-- numerical value, product ID, and average star rating rounded to two decimal places.
-- Sort the output first by month and then by product ID.
-- Soln
SELECT EXTRACT(MONTH FROM submit_date) AS mth,
    product_id,
    ROUND(AVG(stars), 2) AS avg_stars
FROM reviews
GROUP BY mth , product_id
ORDER BY mth;

-- Q.3 filter Amazon reviews based on all 4 of these conditions:
-- 1.the review should have 4 or more stars
-- 2.the review ID is less than 6000
-- 3.the review ID is more than 2000
-- 4.the review can't come from user 142
-- Soln
SELECT *
FROM reviews
WHERE stars >= 4
     AND review_id < 6000
	 AND review_id > 2000
	 AND review_id = 142;

-- Q.4 filter Amazon reviews based on these two conditions:
-- the start count is greater than 2, and less than or equal to 4
-- the review must come from either user 123, 265, or 362
-- Soln
SELECT *
FROM reviews
WHERE stars > 2 AND stars <= 4
	  AND user_id IN (123 , 265, 362);
    
-- Q.5 Imagine you are a Data Analyst working at CVS Pharmacy,
--  and you had access to pharmacy sales data.
-- which sold between 100,000 units and 105,000 units
-- AND were manufactured by either Biogen, AbbVie, or Eli Lilly
-- Output the manufacturer name, drug name, and the # of units sold.
-- Soln
SELECT manufacturer, drug, units_sold
FROM pharmacy_sales
WHERE units_sold BETWEEN 100000 AND 105000
	  AND manufacturer IN ('Biogen' , 'AbbVie', 'Eli Lilly');
    
-- Q.6 Imagine you are a Data Analyst working at CVS Pharmacy, 
-- and you had access to pharmacy sales data. Use the IN SQL command to find data on medicines:
-- which were manufactured by either Roche, Bayer, or AstraZeneca
-- and did not sell between 55,000 and 550,000 units
-- Output the manufacturer name, drug name, and the # of units sold.
-- Soln
SELECT 
    manufacturer, drug, units_sold
FROM
    pharmacy_sales
WHERE
    manufacturer IN ('Roche' , 'Bayer', 'AstraZeneca')
        AND units_sold NOT BETWEEN 55000 AND 550000;
	
-- Q.7 CVS Health is trying to better understand its pharmacy sales, 
-- and how well different products are selling.Each drug can only be produced by one manufacturer.
-- Write a query to find the top 3 most profitable drugs sold, and how much profit they made.
-- Assume that there are no ties in the profits.
-- Display the result from the highest to the lowest total profit.
-- Definition:
-- cogs stands for Cost of Goods Sold which is the direct cost associated with producing the drug.
-- Total Profit = Total Sales - Cost of Goods Sold
SELECT drug, (total_sales - cogs) AS total_profit
FROM pharmacy_sales
ORDER BY total_profit DESC
LIMIT 3;

-- Q.8 CVS Health is analyzing its pharmacy sales data, and how well different products
-- are selling in the market. Each drug is exclusively manufactured by a single manufacturer.
-- Write a query to identify the manufacturers associated with the drugs that resulted in losses
-- for CVS Health and calculate the total amount of losses incurred.
-- Output the manufacturer's name, the number of drugs associated with losses, and the total losses 
-- in absolute value. Display the results sorted in descending order with the highest losses displayed at the top.
-- Soln
SELECT manufacturer,
    COUNT(drug) AS drug_count,
    ABS(SUM(total_sales - cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales - cogs <= 0
GROUP BY manufacturer
ORDER BY total_loss DESC;
-- or
SELECT manufacturer,
  COUNT(drug) AS drug_count, 
  SUM(cogs - total_sales) AS total_loss
FROM pharmacy_sales
WHERE cogs > total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC;

-- Q.9 Write a query to calculate the total drug sales for each manufacturer. Round the answer to the nearest million and report
-- your results in descending order of total sales. In case of any duplicates, sort them alphabetically by the manufacturer name.
-- Since this data will be displayed on a dashboard viewed by business stakeholders, please format your results as follows: "$36 million".
-- Soln
SELECT manufacturer,
    CONCAT('$',ROUND(SUM(total_sales) / 1000000),' million') AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC , manufacturer;
-- or
WITH drug_sales AS (
  SELECT manufacturer, SUM(total_sales) as sales 
  FROM pharmacy_sales 
  GROUP BY manufacturer
) 

SELECT 
  manufacturer, 
  ('$' || ROUND(sales / 1000000) || ' million') AS sales_mil 
FROM drug_sales 
ORDER BY sales DESC, manufacturer;

-- Q.10 You have a table of 1000 customer records from a small-business based in Australia.
-- Find all customers whose first name starts with "F" and the last letter in their last name is "ck".
-- Soln
SELECT *
FROM customers
WHERE customer_name LIKE 'F%ck';

-- Q.12 You have a table of 1000 customer records from a small-business based in Australia.
-- Find all customers where the 2nd and 3rd letter in their name is "e".
-- Soln
SELECT * FROM customers where customer_name like '_ee%';

-- Q.13 Find all customers who are between the ages of 18 and 22 (inclusive), live in either Victoria, Tasmania, Queensland, 
-- their gender isn't "n/a", and their name starts with either 'A' or 'B'.
-- Soln
SELECT *
FROM customers
WHERE age BETWEEN 18 AND 22
        AND state IN ('Victoria' , 'Tasmania', 'Queensland')
        AND gender != 'n/a'
        AND (customer_name LIKE 'A%'
        OR customer_name LIKE 'B%');
        
-- Q.14 Output the total number of drugs manufactured by Pfizer, and output the total sales for all the Pfizer drugs. 
-- Soln
SELECT COUNT(*), SUM(total_sales)
FROM pharmacy_sales
WHERE manufacturer = 'Pfizer';

-- Q.15 Write a SQL query using AVG to find the average open price for Google stock (which has a stock ticker symbol of 'GOOG').
-- Soln
SELECT AVG(open) AS AVG_open_price
FROM stock_prices
WHERE ticker = 'GOOG';
-- or
SELECT ticker, AVG(open) AS AVG_open_price
FROM stock_prices
GROUP BY ticker
HAVING ticker = 'GOOG';

-- Q.16 Use SQL's MIN command in this practice exercise, to find the lowest Microsoft stock (MSFT) ever opened at.
-- Soln
SELECT MIN(open)
FROM stock_prices
WHERE ticker = 'MSFT';

-- Q.17 Use SQL's MAX command in this practice exercise, to find the highest Netflix stock (NFLX) ever opened at.
-- SOln
SELECT MAX(open)
FROM stock_prices
WHERE ticker = 'NFLX';

-- Q.18 For every FAANG stock in the stock_prices dataset, write a SQL query to find the lowest price each stock ever opened at?
--      Be sure to also order your results by price, in descending order.
-- SOLN
SELECT ticker, MIN(open) AS min
FROM stock_prices
GROUP BY ticker
ORDER BY min DESC;

-- Q.19 Suppose you are given a table of candidates and their skills. How many candidates possess each of the different skills?
--      Sort your answers based on the count of candidates, from highest to lowest
-- Soln
SELECT skill, COUNT(candidate_id) AS cnt
FROM candidates
GROUP BY skill
ORDER BY cnt DESC;

-- Q.20 Use SQL's HAVING & MIN commands to find all FAANG stocks whose open share price was always greater than $100
-- Soln
SELECT ticker, MIN(open)
FROM stock_prices
GROUP BY ticker
HAVING MIN(open) > 100;

-- Q.21 Given a table of candidates and their technical skills, list the candidate IDs of candidates who have more than 2 technical skills.
-- Soln
SELECT candidate_id
FROM candidates
GROUP BY candidate_id
HAVING COUNT(skill) > 2;

-- Q.22 Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job.
--      You want to find candidates who are proficient in Python, Tableau, and PostgreSQL. Write a query to list the candidates who possess
--      all of the required skills for the job. Sort the output by candidate ID in ascending order.
-- Soln
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python' , 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id; 

-- Q.23 (Robinhood) Assume you're given the tables containing completed trade orders and user details in a Robinhood trading system.
-- Write a query to retrieve the top three cities that have the highest number of completed trade orders listed in descending order.
-- Output the city name and the corresponding number of completed trade orders.
-- Soln
SELECT s.city,COUNT(t.order_id) as total_orders
FROM trades t
JOIN users s
on t.user_id = s.user_id
WHERE status = 'Completed'
GROUP BY s.city
ORDER BY total_orders DESC
LIMIT 3;

-- Q.24 (CVS Health): Assume you're given a table containing data on Amazon customers and their spending on products in different category. 
--      Write a query using COUNT DISTINCT to identify the number of unique products within each product category.
-- Soln
SELECT category, COUNT(DISTINCT product)
FROM product_spend
GROUP BY category;

-- Q.25 (JPMorgan): Your team at JPMorgan Chase is preparing to launch a new credit card, and to gain some insights,
-- you're analyzing how many credit cards were issued each month.
-- Write a query that outputs the name of each credit card and the difference in the number of issued cards between the month 
-- with the highest issuance cards and the lowest issuance. Arrange the results based on the largest disparity.
-- Soln
SELECT card_name, (MAX(issued_amount) - MIN(issued_amount)) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

-- Q.26 Display the stocks which had "big-mover months", and how many of those months they had. 
-- Order your results from the stocks with the most, to least, "big-mover months".
-- What is a big-mover month? A "big-mover month" is when a stock closes up or down by greater than 10% compared to the price it opened at.
-- For example, when COVID hit and e-commerce became the new normal, Amazon stock in April 2020 had a big-mover month because the price shot
-- up from $96.65 per share at open to $123.70 at close – a 28% increase!
-- Soln
SELECT ticker, COUNT(ticker) AS count
FROM stock_prices s
WHERE ABS(((s.open - s.close) / s.open) * 100) > 10
GROUP BY ticker
ORDER BY count DESC;

-- OR

SELECT ticker, COUNT(ticker) AS count
FROM stock_prices s
WHERE (((s.open - s.close) / s.open) * 100) > 10
	   OR (((s.close - s.open) / s.open) * 100) > 10
GROUP BY ticker
ORDER BY count DESC;

-- OR

SELECT ticker, COUNT(ticker)
FROM stock_prices
WHERE (close - open)/open > 0.10 OR (close - open)/open < -0.10
GROUP BY ticker
ORDER BY count DESC;

-- Q.27 For all Merck drugs, output the drug name, and the unit cost for each drug, rounded up to the nearest dollar.
-- Order it from cheapest to most expensive drug.
-- Hint: Unit cost is defined as the total sales divided by the units sold.
-- Soln
SELECT drug, CEIL(total_sales / units_sold) AS unit_cost
FROM pharmacy_sales
WHERE manufacturer = 'Merck'
ORDER BY unit_cost;

-- Q.28 (TESLA): Tesla is investigating production bottlenecks and they need your help to extract the relevant data. 
-- Write a query to determine which parts have begun the assembly process but are not yet finished.
-- Assumptions: parts_assembly table contains all parts currently in production, each at varying stages of the assembly process.
-- An unfinished part is one that lacks a finish_date.
-- Soln
SELECT part, assembly_step
FROM parts_assembly
WHERE finish_date IS NULL;

-- Q.29 Explore the Marvel Avengers dataset and write a query to categorize superheroes based on their average likes as follows:
-- Super Likes: Superheroes with an average likes count greater than or equal to 15,000.
-- Good Likes: Superheroes with an average likes count between 5,000 and 14,999 (inclusive).
-- Low Likes: Superheroes with an average likes count less than 5,000.
-- Display the actor and character's name, platform, average likes, and the corresponding likes category. Sort the results by average likes.
-- Soln
SELECT actor, characters, platform, avg_likes, 
CASE
    WHEN avg_likes < 5000 THEN 'Low Likes'
    WHEN avg_likes BETWEEN 5000 AND 14999 THEN 'Good Likes'
    WHEN avg_likes >= 15000 THEN 'Super Likes'
END as likes_category
FROM marvel_avengers
ORDER BY avg_likes DESC;

-- Q.30 Suppose we want to filter the marvel_avengers dataset based on the social media platforms,
--  but we want to include an option to filter based on different criteria for each platform.
-- For Instagram, we're filtering actors with 500,000 or more followers.
-- For Twitter, we're filtering actors with 200,000 or more followers.
-- For other platforms, we're filtering actors with 100,000 or more followers.
-- Soln
SELECT actor, characters, platform
FROM marvel_avengers
WHERE 
  CASE 
    WHEN platform = 'Instagram' THEN followers >= 500000
    WHEN platform = 'Twitter' THEN followers >= 200000
    ELSE followers >= 100000
  END;
  
-- Q.31 The COUNT() aggregate function within a CASE statement is used to count occurrences based on various conditions within the dataset.
-- Assign to popular_actor_count if number of actors with followers greater than or equal to 500,000 followers.
-- Assign to less_popular_actor_count if number of actors with followers less than 500,000 followers.
-- Soln
SELECT platform,
  COUNT(CASE 
    WHEN followers >= 500000 THEN 1
    ELSE NULL
  END) AS popular_actor_count,
  COUNT(CASE 
    WHEN followers < 500000 THEN 1
    ELSE NULL
  END) AS less_popular_actor_count
FROM marvel_avengers
GROUP BY platform;

-- Q.32 Assume you're given the table on user viewership categorised by device type where the three types are laptop, tablet, and phone.
-- Write a query that calculates the total viewership for laptops and mobile devices where mobile is defined as the sum of tablet and phone viewership.
-- Output the total viewership for laptops as laptop_reviews and the total viewership for mobile devices as mobile_views
-- Soln
SELECT 
  SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views,
  SUM(CASE WHEN device_type IN ('phone','tablet') THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;
-- OR (below query wont work in MYSQL only for postgres)
SELECT 
  COUNT(*) FILTER (WHERE device_type = 'laptop') AS laptop_views,
  COUNT(*) FILTER (WHERE device_type IN ('tablet', 'phone'))  AS mobile_views 
FROM viewership;

-- Q.33 calculating the average number of followers of actors based on their engagement rates. If the engagement rate is 8.0 or higher,
--  assign to "high_engagement_followers", otherwise, assign to "low_engagement_followers" for each platform.
-- Soln
SELECT
  platform,
  AVG(CASE 
    WHEN engagement_rate >= 8.0 THEN followers
    ELSE NULL
  END) AS avg_high_engagement_followers,
  AVG(CASE 
    WHEN engagement_rate < 8.0 THEN followers
    ELSE NULL
  END) AS avg_low_engagement_followers
FROM marvel_avengers
GROUP BY platform;

-- Q.34 (Facebook,Meta) Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page").
-- Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.
-- Soln
SELECT p.page_id
FROM pages p
LEFT JOIN page_likes AS l
  ON p.page_id = l.page_id
WHERE l.page_id IS NULL;
-- OR 
SELECT page_id
FROM pages
WHERE page_id NOT IN (
  SELECT page_id
  FROM page_likes
  WHERE page_id IS NOT NULL
);

-- Q.35 (FACEBOOK) Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of days between each 
-- user’s first post of the year and last post of the year in the year 2021. Output the user and number of the days between each user's first and last post.
-- Soln
SELECT user_id, (MAX(DATE(post_date))-MIN(DATE(post_date))) AS date_diff
FROM posts
WHERE EXTRACT(YEAR FROM post_date) = 2021
GROUP BY user_id
HAVING COUNT(post_id) > 1;

-- Q.36 (TikTok) Assume you're given tables with information about TikTok user sign-ups and confirmations through email and text. 
-- New users on TikTok sign up using their email addresses, and upon sign-up, each user receives a text message confirmation to activate their account.
-- Write a query to display the user IDs of those who did not confirm their sign-up on the first day, but confirmed on the second day.
-- Definition: action_date refers to the date when users activated their accounts and confirmed their sign-up through text messages.
-- Soln
SELECT user_id 
FROM emails e 
join texts t on e.email_id=t.email_id 
WHERE action_date = signup_date + INTERVAL '1 days' AND signup_action = 'Confirmed';

-- ADVANCED : 

-- Q.37 Your mission is to unlock valuable insights by analyzing the concert revenue data and identifying the top revenue-generating artists within each music genre.
-- Write a query to rank the artists within each genre based on their revenue per member and extract the top revenue-generating artist from each genre.
-- Display the output of the artist name, genre, concert revenue, number of members, and revenue per band member,
-- sorted by the highest revenue per member within each genre.
-- Soln
WITH ranked_concerts_cte AS (
  SELECT artist_name, concert_revenue, genre, number_of_members,
    (concert_revenue / number_of_members) AS revenue_per_member,
    RANK() OVER (PARTITION BY genre ORDER BY (concert_revenue / number_of_members) DESC) AS ranked_concerts
  FROM concerts
 )SELECT
  artist_name, concert_revenue, genre, number_of_members, revenue_per_member
FROM ranked_concerts_cte
WHERE ranked_concerts = 1
ORDER BY revenue_per_member DESC;
-- or by SubQuery
SELECT
  artist_name,
  concert_revenue,
  genre,
  number_of_members,
  revenue_per_member
FROM ( SELECT
    artist_name,
    concert_revenue,
    genre,
    number_of_members,
    (concert_revenue / number_of_members) AS revenue_per_member,
    RANK() OVER (PARTITION BY genre ORDER BY (concert_revenue / number_of_members) DESC) AS ranked_concerts
  FROM concerts) AS subquery
WHERE ranked_concerts = 1
ORDER BY revenue_per_member DESC;

-- Q.38 (Microsoft) A Microsoft Azure Supercloud customer is defined as a customer who has purchased at least one product from every product category
--  listed in the products table. Write a query that identifies the customer IDs of these Supercloud customers.
-- Soln
WITH supercloud_cte AS(
SELECT customer_id ,COUNT(DISTINCT p.product_category) as product_count
from customer_contracts c
JOIN products p ON c.product_id=p.product_id
GROUP BY CUSTOMER_id
) SELECT customer_id
from supercloud_cte 
WHERE product_count = (SELECT COUNT(DISTINCT product_category) from products);

-- Q.39 (Zomato) Recently, Zomato encountered an issue with their delivery system. Due to an error in the delivery driver instructions, 
-- each item's order was swapped with the item in the subsequent row. As a data analyst, you're asked to correct this swapping error 
-- and return the proper pairing of order ID and item. If the last item has an odd order ID, it should remain as the last item in the corrected data.
-- For example, if the last item is Order ID 7 Tandoori Chicken, then it should remain as Order ID 7 in the corrected data.
-- In the results, return the correct pairs of order IDs and items.
-- Soln
WITH misplaced_cte AS(
    SELECT COUNT(order_id) AS total_orders 
    FROM orders
)SELECT CASE 
            WHEN order_id % 2 != 0 AND order_id = total_orders THEN order_id
            WHEN order_id % 2 != 0 AND order_id != total_orders THEN order_id + 1
            ELSE order_id - 1
        END as corrected_orderid, 
        item
  FROM orders
  CROSS JOIN misplaced_cte
  ORDER BY corrected_orderid;
  
-- Q.40 (AMAZON) Assume you're given a table containing data on Amazon customers and their spending on products in different category, write a query to 
-- identify the top two highest-grossing products within each category in the year 2022. The output should include the category, product, and total spend.
-- Soln
WITH rank_spend_cte AS(
  SELECT category, product, SUM(spend) AS total_spend,
  RANK() OVER(PARTITION BY category ORDER BY SUM(spend)DESC) AS rnk
  FROM product_spend
  WHERE EXTRACT(YEAR FROM transaction_date) = 2022
  GROUP BY category,product
)SELECT category, product, total_spend 
 FROM rank_spend_cte 
 WHERE rnk <= 2
 ORDER BY category, rnk;
 -- OR
 SELECT category, product, total_spend 
FROM (SELECT category, product, SUM(spend) as total_spend,
      RANK() OVER(PARTITION BY category ORDER BY SUM(spend)DESC)as rnk
      FROM product_spend
      WHERE EXTRACT(YEAR FROM transaction_date) = 2022
      GROUP BY category, product) AS rank_spend
WHERE rnk <= 2
ORDER BY category, rnk;

-- Q.41 