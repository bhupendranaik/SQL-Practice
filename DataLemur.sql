-- Q.1 Given the reviews table, write a query to retrieve the average star rating
-- for each product, grouped by month. The output should display the month as a
-- numerical value, product ID, and average star rating rounded to two decimal places.
-- Sort the output first by month and then by product ID.
-- Soln
SELECT 
    EXTRACT(MONTH FROM submit_date) AS mth,
    product_id,
    ROUND(AVG(stars), 2) AS avg_stars
FROM
    reviews
GROUP BY mth , product_id
ORDER BY mth;