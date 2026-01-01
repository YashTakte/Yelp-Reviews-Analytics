USE DATABASE PROJECTS;
USE SCHEMA PUBLIC;  

CREATE OR REPLACE TABLE yelp_businesses (
  business_text VARIANT
);

COPY INTO yelp_businesses
FROM 's3://yelp-reviews-analytics-aws/yelp_data/yelp_academic_dataset_business.json'
CREDENTIALS = (
  AWS_KEY_ID = ''
  AWS_SECRET_KEY = ''
)
FILE_FORMAT = (TYPE = JSON);

SELECT * FROM yelp_businesses LIMIT 10

CREATE or REPLACE TABLE tbl_yelp_businesses AS 
SELECT business_text:business_id::string AS business_id
,business_text:name::string AS name
,business_text:city::string AS city
,business_text:state::string AS state
,business_text:review_count::string AS review_count
,business_text:stars::number AS stars
,business_text:categories::string AS categories
FROM yelp_businesses 

SELECT * FROM tbl_yelp_businesses LIMIT 10