USE DATABASE PROJECTS;
USE SCHEMA PUBLIC;  

-- Number of Businesses in each category
WITH cte AS (
    SELECT business_id,
           trim(A.value) AS category
    FROM tbl_yelp_businesses
    , LATERAL split_to_table(categories, ',') A
)
SELECT category,
       COUNT(*) AS no_of_business
FROM cte
GROUP BY 1
ORDER BY 2 DESC;

-- Top 10 Users who reviewed the most businessses in the "Restaurants" category
SELECT r.user_id, COUNT(DISTINCT r.business_id)
FROM tbl_yelp_reviews r
INNER JOIN tbl_yelp_businesses b ON r.business_id = b.business_id
WHERE b.categories ILIKE '%restaurant%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- Most popular categories of businesses (based on the number of reviews)
WITH cte AS (
    SELECT business_id, trim(A.value) AS category
    FROM tbl_yelp_businesses
    , LATERAL split_to_table(categories, ',') A
)
SELECT category, count(*) AS no_of_reviews
FROM cte
INNER JOIN tbl_yelp_reviews r ON cte.business_id = r.business_id
GROUP BY 1
ORDER BY 2 DESC;

-- Top 3 Most recent reviews for each business
WITH cte AS (
    SELECT r.*, b.name
    , row_number() OVER(PARTITION BY r.business_id ORDER BY review_date DESC) AS rn
    FROM tbl_yelp_reviews r
    INNER JOIN tbl_yelp_businesses b ON r.business_id = b.business_id
)
SELECT *
FROM cte
WHERE rn <= 3;

-- Month with the highest number of reviews
SELECT month(review_date) AS review_month, count(*) AS no_of_reviews
FROM tbl_yelp_reviews
GROUP BY 1
ORDER BY 2 DESC;

-- Percentage of 5-star reviews for each business
SELECT b.business_id, b.name, count(*) AS total_reviews
, sum(CASE WHEN r.review_stars = 5 THEN 1 ELSE 0 END) AS star5_reviews
, star5_reviews*100/total_reviews AS percent_5_star
FROM tbl_yelp_reviews r
INNER JOIN tbl_yelp_businesses b ON r.business_id = b.business_id
GROUP BY 1,2;

-- Top 5 most reviewed businesses in each city
WITH cte AS (
    SELECT b.city, b.business_id, b.name, count(*) AS total_reviews
    FROM tbl_yelp_reviews r
    INNER JOIN tbl_yelp_businesses b ON r.business_id = b.business_id
    GROUP BY 1,2,3
)
SELECT *
FROM cte
QUALIFY row_number() OVER (PARTITION BY city ORDER BY total_reviews DESC) <= 5;

-- Average rating of businesses that have at least 100 reviews
SELECT b.business_id, b.name, count(*) AS total_reviews
     , avg(review_stars) AS avg_rating
FROM tbl_yelp_reviews r
INNER JOIN tbl_yelp_businesses b ON r.business_id = b.business_id
GROUP BY 1, 2
HAVING count(*) >= 100;

-- Top 10 users who have written the most reviews, along with the businesses they reviewed
WITH cte AS (
    SELECT r.user_id, count(*) AS total_reviews
    FROM tbl_yelp_reviews r
    INNER JOIN tbl_yelp_businesses b ON r.business_id = b.business_id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10
)
SELECT user_id, business_id
FROM tbl_yelp_reviews
WHERE user_id IN (SELECT user_id FROM cte)
GROUP BY 1,2
ORDER BY user_id;

-- Top 10 businesses with highest positive sentiment reviews
SELECT r.business_id, b.name, count(*) AS total_reviews
FROM tbl_yelp_reviews r
INNER JOIN tbl_yelp_businesses b ON r.business_id = b.business_id
WHERE sentiments = 'Positive'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;


