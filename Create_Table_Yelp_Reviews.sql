USE DATABASE PROJECTS;
USE SCHEMA PUBLIC;  

CREATE OR REPLACE TABLE yelp_reviews (
  review_text VARIANT
);

COPY INTO yelp_reviews
FROM 's3://yelp-reviews-analytics-aws/yelp_data/'
CREDENTIALS = (
  AWS_KEY_ID = ''
  AWS_SECRET_KEY = ''
)
FILE_FORMAT = (TYPE = JSON);

SELECT * FROM yelp_reviews LIMIT 10

CREATE or REPLACE TABLE tbl_yelp_reviews AS 
SELECT review_text:business_id::string AS business_id 
,review_text:date::date AS review_date 
,review_text:user_id::string AS user_id
,review_text:stars::number AS review_stars
,review_text:text::string AS review_text
,analyze_sentiment(review_text) AS sentiments
FROM yelp_reviews 

SELECT * FROM tbl_yelp_reviews LIMIT 10