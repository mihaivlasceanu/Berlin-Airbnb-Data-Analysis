/*=========================
 IMPORTING THE DATASETS
=========================*/

CREATE TABLE listings (
id TEXT,
host_id TEXT,
host_name TEXT,
host_since DATE,
host_location TEXT,
host_response_time TEXT,
host_response_rate TEXT,
host_acceptance_rate TEXT,
host_is_superhost BOOL,
host_neighbourhood TEXT,
host_listings_count INTEGER,
host_total_listings_count INTEGER,
neighbourhood_cleansed TEXT,
neighbourhood_group_cleansed TEXT,
latitude NUMERIC,
longitude NUMERIC,
property_type TEXT,
room_type TEXT,
accommodates INTEGER,	
bathrooms_text TEXT,
bedrooms INTEGER,
beds INTEGER,
amenities TEXT,
price TEXT,
minimum_nights INTEGER,
maximum_nights INTEGER,
has_availability BOOLEAN,
availability_30 INTEGER,
availability_60 INTEGER,
availability_90	INTEGER,
availability_365 INTEGER,
number_of_reviews INTEGER,
number_of_reviews_ltm INTEGER,
number_of_reviews_l30d INTEGER,
first_review DATE,
last_review DATE,
review_scores_rating NUMERIC,
review_scores_accuracy NUMERIC,
review_scores_cleanliness NUMERIC,	
review_scores_checkin NUMERIC,
review_scores_communication NUMERIC,
review_scores_location NUMERIC,
review_scores_value NUMERIC,
instant_bookable BOOLEAN,
calculated_host_listings_count INTEGER,
calculated_host_listings_count_entire_homes INTEGER,
calculated_host_listings_count_private_rooms INTEGER,
calculated_host_listings_count_shared_rooms INTEGER,
reviews_per_month NUMERIC
)

-- \COPY listings FROM 'C:\Users\User\Desktop\Airbnb\16.09.2023\listings.csv' WITH CSV HEADER DELIMITER ',' ENCODING 'UTF8'

SELECT * FROM listings
LIMIT 5

CREATE TABLE reviews (
listing_id TEXT,
id TEXT,
date DATE,	
reviewer_id	TEXT,
reviewer_name TEXT,
comments TEXT
)

-- \COPY reviews FROM 'C:\Users\User\Desktop\Airbnb\16.09.2023\reviews.csv' WITH CSV HEADER DELIMITER ',' ENCODING 'UTF8'

SELECT * FROM reviews
LIMIT 5


/*=========================
 CLEANING THE TABLES
=========================*/

-- 1. The "listings" table:

WITH cleanup_cte AS (
SELECT
id,
host_id, 
host_name,
host_since,
SPLIT_PART(host_location, ',', 1) AS host_location_city,
SPLIT_PART(host_location, ',', 2) AS host_location_country,
NULLIF(host_response_time,'N/A') AS host_response_time,
NULLIF(REPLACE(host_response_rate,'%',''),'N/A') AS host_response_rate,
NULLIF(REPLACE(host_acceptance_rate,'%',''),'N/A') AS host_acceptance_rate,
host_is_superhost,
host_neighbourhood,	
host_listings_count,	
host_total_listings_count,
neighbourhood_cleansed,	
neighbourhood_group_cleansed,	
latitude,	
longitude,	
property_type,	
room_type,	
accommodates,
SPLIT_PART(bathrooms_text, ' ', 1) AS bathrooms,
bedrooms,
beds,
REGEXP_REPLACE(amenities,'[\[\]\"]', '', 'g') AS amenities,
SPLIT_PART(REPLACE(price, '$', ''), '.', 1) AS price_dollars, 
minimum_nights,	
maximum_nights,	
has_availability, 
availability_30,	
availability_60,	
availability_90,	
availability_365,	
number_of_reviews,	
number_of_reviews_ltm,	
number_of_reviews_l30d,	
first_review,	
last_review,	
review_scores_rating,	
review_scores_accuracy,	
review_scores_cleanliness, 	
review_scores_checkin,	
review_scores_communication,	
review_scores_location,	
review_scores_value,	
instant_bookable,	
calculated_host_listings_count, 
calculated_host_listings_count_entire_homes, 
calculated_host_listings_count_private_rooms, 
calculated_host_listings_count_shared_rooms,	
reviews_per_month 
FROM listings
)

, cleanup_cte_2 AS (
SELECT
id,
host_id, 
host_name,
host_since,
CASE WHEN host_location_country = '' AND host_location_city IS NOT NULL 
THEN host_location_city ELSE host_location_country END AS host_location_country,
host_location_city,
host_response_time,
host_response_rate,
host_acceptance_rate,
host_is_superhost,
host_neighbourhood,	
host_listings_count,	
host_total_listings_count,
neighbourhood_cleansed,	
neighbourhood_group_cleansed,	
latitude,	
longitude,	
property_type,	
room_type,	
accommodates,
bathrooms,
bedrooms,
beds,
REPLACE(REPLACE(REPLACE(amenities, '\u2019', ''''), '\u2013', '-'), '\','"') AS amenities,
REPLACE(price_dollars, ',', '')::NUMERIC AS price_dollars,
minimum_nights,	
maximum_nights,	
has_availability, 
availability_30,	
availability_60,	
availability_90,	
availability_365,	
number_of_reviews,	
number_of_reviews_ltm,	
number_of_reviews_l30d,	
first_review,	
last_review,	
review_scores_rating,	
review_scores_accuracy,	
review_scores_cleanliness, 	
review_scores_checkin,	
review_scores_communication,	
review_scores_location,	
review_scores_value,	
instant_bookable,	
calculated_host_listings_count, 
calculated_host_listings_count_entire_homes, 
calculated_host_listings_count_private_rooms, 
calculated_host_listings_count_shared_rooms,	
reviews_per_month 
FROM cleanup_cte
)

SELECT
id,
host_id, 
host_name,
host_since,
TRIM(host_location_country) AS host_location_country,
TRIM(CASE WHEN host_location_city = host_location_country THEN 'Undeclared' ELSE host_location_city END) AS host_location_city,
host_response_time,
host_response_rate,
host_acceptance_rate,
host_is_superhost,
host_neighbourhood,	
host_listings_count,	
host_total_listings_count,
neighbourhood_cleansed,	
neighbourhood_group_cleansed,	
latitude,	
longitude,	
property_type,	
room_type,	
accommodates,
bathrooms,
bedrooms,
beds,
amenities,
price_dollars,
minimum_nights,	
maximum_nights,	
has_availability, 
availability_30,	
availability_60,	
availability_90,	
availability_365,	
number_of_reviews,	
number_of_reviews_ltm,	
number_of_reviews_l30d,	
first_review,	
last_review,	
review_scores_rating,	
review_scores_accuracy,	
review_scores_cleanliness, 	
review_scores_checkin,	
review_scores_communication,	
review_scores_location,	
review_scores_value,	
instant_bookable,	
calculated_host_listings_count, 
calculated_host_listings_count_entire_homes, 
calculated_host_listings_count_private_rooms, 
calculated_host_listings_count_shared_rooms,	
reviews_per_month 
INTO listings_cleaned
FROM cleanup_cte_2

SELECT * FROM listings_cleaned
LIMIT 5

-- 1.1 Exporting the cleaned listings table for further use in Tableau:

-- \COPY listings_cleaned TO 'C:\Users\User\Desktop\Airbnb\Modified datasets\16 Sep 2023\listings_cleaned.csv' WITH CSV HEADER DELIMITER ',' ENCODING 'UTF8'

-- 2. The "reviews" table:

SELECT
listing_id,
id,
date,
reviewer_id,
reviewer_name,
REPLACE(comments,'<br/>','') AS comments
INTO reviews_cleaned
FROM reviews

SELECT * FROM reviews_cleaned
LIMIT 5

/*=========================
 EDA - Property metrics
=========================*/

-- 1. Total number of listings

SELECT
COUNT(DISTINCT id)
FROM listings_cleaned


-- 2. Distribution of property types (absolute and percent of total)

SELECT
property_type,
COUNT(*),
ROUND(100.0 * COUNT(*)/SUM(COUNT(*)) OVER (),2) as pct
FROM listings_cleaned
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 3. Distribution of room types (aggregated, absolute and percent of total)

SELECT
room_type,
COUNT(*),
ROUND(100.0 * COUNT(*)/SUM(COUNT(*)) OVER (),2) as pct
FROM listings_cleaned
GROUP BY 1
ORDER BY 2 DESC

-- 4. Average number of bedrooms and beds

SELECT
ROUND(AVG(bedrooms)) AS avg_nr_bedrooms,
ROUND(AVG(beds)) AS avg_nr_beds
FROM listings_cleaned

-- 5. Average, min, max price per night
-- (NOTE: there are a handful of outliers at the upper limit of the overall prince range that could potentially affect our results further down the line)

SELECT
ROUND(AVG(price_dollars)) AS avg_price,
ROUND(MIN(price_dollars)) AS min_price,
ROUND(MAX(price_dollars)) AS max_price
FROM listings_cleaned

-- 6. Price range distribution

WITH price_range_cte AS (
SELECT
CASE WHEN price_dollars < 100 THEN '0-99'
WHEN price_dollars >=100 AND price_dollars < 200 THEN '100-199'
WHEN price_dollars >=200 AND price_dollars < 300 THEN '200-299'
WHEN price_dollars >=300 AND price_dollars < 400 THEN '300-399'
WHEN price_dollars >=400 AND price_dollars < 500 THEN '400-499'
WHEN price_dollars >=500 AND price_dollars < 600 THEN '500-599'
WHEN price_dollars >=600 AND price_dollars < 700 THEN '600-699'
WHEN price_dollars >=700 AND price_dollars < 800 THEN '700-799'
WHEN price_dollars >=800 AND price_dollars < 900 THEN '800-899'
WHEN price_dollars >=900 AND price_dollars < 1000 THEN '900-999'
ELSE '>1000' END AS price_range,
COUNT(*)
FROM listings_cleaned
GROUP BY 1
)

SELECT
price_range,
count,
ROUND(100.0 * count/SUM(count) OVER (), 2) as pct
FROM price_range_cte
ORDER BY ARRAY_POSITION(ARRAY['0-99','100-199','200-299','300-399','400-499','500-599','600-699','700-799','800-899','900-999','>1000'], price_range)

-- 6.1 Price range distribution by neighbourhood

WITH price_range_cte AS (
SELECT
neighbourhood_cleansed,
CASE WHEN price_dollars < 100 THEN '0-99'
WHEN price_dollars >=100 AND price_dollars < 200 THEN '100-199'
WHEN price_dollars >=200 AND price_dollars < 300 THEN '200-299'
WHEN price_dollars >=300 AND price_dollars < 400 THEN '300-399'
WHEN price_dollars >=400 AND price_dollars < 500 THEN '400-499'
WHEN price_dollars >=500 AND price_dollars < 600 THEN '500-599'
WHEN price_dollars >=600 AND price_dollars < 700 THEN '600-699'
WHEN price_dollars >=700 AND price_dollars < 800 THEN '700-799'
WHEN price_dollars >=800 AND price_dollars < 900 THEN '800-899'
WHEN price_dollars >=900 AND price_dollars < 1000 THEN '900-999'
ELSE '>1000' END AS price_range,
COUNT(*)
FROM listings_cleaned
GROUP BY 1,2
)

SELECT
neighbourhood_cleansed,
price_range,
count,
ROUND(100.0 * count/SUM(count) OVER (PARTITION BY neighbourhood_cleansed), 2) as pct
FROM price_range_cte
ORDER BY ARRAY_POSITION(ARRAY['0-99','100-199','200-299','300-399','400-499','500-599','600-699','700-799','800-899','900-999','>1000'], price_range)
LIMIT 10

-- 6.2 Price range distribution by neighbourhood_group

WITH price_range_cte AS (
SELECT
neighbourhood_group_cleansed,
CASE WHEN price_dollars < 100 THEN '0-99'
WHEN price_dollars >=100 AND price_dollars < 200 THEN '100-199'
WHEN price_dollars >=200 AND price_dollars < 300 THEN '200-299'
WHEN price_dollars >=300 AND price_dollars < 400 THEN '300-399'
WHEN price_dollars >=400 AND price_dollars < 500 THEN '400-499'
WHEN price_dollars >=500 AND price_dollars < 600 THEN '500-599'
WHEN price_dollars >=600 AND price_dollars < 700 THEN '600-699'
WHEN price_dollars >=700 AND price_dollars < 800 THEN '700-799'
WHEN price_dollars >=800 AND price_dollars < 900 THEN '800-899'
WHEN price_dollars >=900 AND price_dollars < 1000 THEN '900-999'
ELSE '>1000' END AS price_range,
COUNT(*)
FROM listings_cleaned
GROUP BY 1,2
)

SELECT
neighbourhood_group_cleansed,
price_range,
count,
ROUND(100.0 * count/SUM(count) OVER (PARTITION BY neighbourhood_group_cleansed), 2) as pct
FROM price_range_cte
ORDER BY ARRAY_POSITION(ARRAY['0-99','100-199','200-299','300-399','400-499','500-599','600-699','700-799','800-899','900-999','>1000'], price_range)
LIMIT 10

-- 7. Average number of amenities per rentable property

WITH amenities_cte AS (
SELECT
id,
UNNEST(STRING_TO_ARRAY(amenities, ',')) AS amenities
FROM listings_cleaned
)

, amenities_count AS (
SELECT
id,
COUNT(amenities)
FROM amenities_cte
GROUP BY 1
ORDER BY 2 DESC
)

SELECT
ROUND(AVG(count))
FROM amenities_count

-- 8. Most common amenities

WITH amenities_cte AS (
SELECT
id,
TRIM(UNNEST(STRING_TO_ARRAY(amenities, ','))) AS amenities
FROM listings_cleaned
)

SELECT
amenities,
COUNT(*)
FROM amenities_cte
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 8.1 Exporting the above CTE (property ids and their corresponding amenities) for later use in Tableau

SELECT
id,
TRIM(UNNEST(STRING_TO_ARRAY(amenities, ','))) AS amenities
INTO amenities_split
FROM listings_cleaned

SELECT * FROM amenities_split

-- EXPORTING: \COPY amenities_split TO 'C:\Users\User\Desktop\Airbnb\Modified datasets\16 Sep 2023\amenities_split.csv' WITH CSV HEADER DELIMITER ','

-- 8.2 Most common amenities by neighbourhood

WITH amenities_neighbourhood_cte AS (
SELECT
id,
neighbourhood_cleansed,
TRIM(UNNEST(STRING_TO_ARRAY(amenities, ','))) AS amenities
FROM listings_cleaned
)

SELECT
neighbourhood_cleansed,
amenities,
COUNT(*)
FROM amenities_neighbourhood_cte
GROUP BY 1,2
ORDER BY 1, 3 DESC
LIMIT 10

-- 8.3 Most common amenities by neighbourhood_group

WITH amenities_neighbourhood_cte AS (
SELECT
id,
neighbourhood_group_cleansed,
TRIM(UNNEST(STRING_TO_ARRAY(amenities, ','))) AS amenities
FROM listings_cleaned
)

SELECT
neighbourhood_group_cleansed,
amenities,
COUNT(*)
FROM amenities_neighbourhood_cte
GROUP BY 1,2
ORDER BY 1, 3 DESC
LIMIT 10


/*=========================
 EDA - Host metrics
=========================*/

-- 1. Number of hosts and superhosts

WITH hosts_cte AS (
SELECT
DISTINCT host_id,
host_is_superhost
FROM listings_cleaned
)

SELECT
COUNT(host_id) AS nr_hosts,
COUNT(host_is_superhost) FILTER (WHERE host_is_superhost = 'true') AS nr_superhosts,
ROUND(100.0 * COUNT(host_is_superhost) FILTER (WHERE host_is_superhost = 'true') / COUNT(host_id),2) AS pct_superhosts
FROM hosts_cte

-- 2. Distribution of number of listings per host

WITH listings_per_host_cte AS (
SELECT
DISTINCT host_id,
COUNT(id) AS nr_listings_per_host
FROM listings_cleaned
GROUP BY 1
ORDER BY 2 DESC
)

SELECT
nr_listings_per_host,
COUNT(*),
ROUND(100.0 * COUNT(*)/SUM(COUNT(*)) OVER (), 2) AS pct
FROM listings_per_host_cte
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 3. Average number of listings per host

WITH listings_per_host_cte AS (
SELECT
DISTINCT host_id,
COUNT(id)
FROM listings_cleaned
GROUP BY 1
)

SELECT
ROUND(AVG(count),1)
FROM listings_per_host_cte

-- 4. Host tenures (at time of data collection)

SELECT
DISTINCT host_id,
AGE(MAKE_DATE(2023, 09, 16), host_since) AS tenure
FROM listings_cleaned
LIMIT 10

-- 5. Average host tenure (at time of data collection)

SELECT
ROUND(AVG(MAKE_DATE(2023, 09, 16) - host_since)) AS avg_tenure_days,
ROUND(AVG(MAKE_DATE(2023, 09, 16) - host_since)/365) AS avg_tenure_years
FROM listings_cleaned

-- 6. Distribution of years when host started renting out (absolute + percentage)

WITH host_tenures_cte AS (
SELECT
DISTINCT host_id,
host_since
FROM listings_cleaned
)

SELECT
DATE_PART('year', host_since) AS year_host_started_renting,
COUNT(*),
ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM host_tenures_cte
WHERE DATE_PART('year', host_since) IS NOT NULL
GROUP BY 1
ORDER BY 1

-- 7. Distribution of host response times (absolute + percentage)

WITH host_response_times_cte AS (
SELECT
DISTINCT host_id,
host_response_time
FROM listings_cleaned
)

SELECT
host_response_time,
COUNT(*),
ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM host_response_times_cte
WHERE host_response_time IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC

-- 8. Distribution of host acceptance rates (absolute + percentage)

WITH host_acceptance_rate_cte AS (
SELECT
DISTINCT host_id,
host_acceptance_rate::INTEGER
FROM listings_cleaned
)

SELECT
host_acceptance_rate,
COUNT(*),
ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM host_acceptance_rate_cte
WHERE host_acceptance_rate IS NOT NULL
GROUP BY 1
ORDER BY 1 DESC
LIMIT 10

-- 9. Distribution of host locations (absolute + percentage)

WITH host_locations_cte AS (
SELECT 
DISTINCT host_id,
host_location_country,
host_location_city
FROM listings_cleaned
WHERE host_location_country IS NOT NULL
)

SELECT
host_location_country,
COUNT(*),
ROUND(100.0 * COUNT(*)/SUM(COUNT(*)) OVER (),2) AS pct
FROM host_locations_cte
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
	
-- 10. Distribution of host locations, for hosts based in Germany only (absolute + percentage)

WITH host_locations_cte AS (
SELECT 
DISTINCT host_id,
host_location_country,
host_location_city
FROM listings_cleaned
WHERE host_location_country IS NOT NULL
)

SELECT
host_location_city,
COUNT(*),
ROUND(100.0 * COUNT(*)/SUM(COUNT(*)) OVER (),2) AS pct
FROM host_locations_cte
WHERE host_location_country ILIKE '%germany%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 11. Average ratings per host

WITH host_ratings_cte AS (
SELECT
DISTINCT host_id,
ROUND(AVG(review_scores_rating), 2) AS avg_review_scores_rating,
ROUND(AVG(review_scores_accuracy), 2) AS avg_review_scores_accuracy,
ROUND(AVG(review_scores_cleanliness), 2) AS avg_review_scores_cleanliness,
ROUND(AVG(review_scores_checkin), 2) AS avg_review_scores_checkin,
ROUND(AVG(review_scores_communication), 2) AS avg_review_scores_communication,
ROUND(AVG(review_scores_location), 2) AS avg_review_scores_location,
ROUND(AVG(review_scores_value), 2) AS avg_review_scores_value
FROM listings_cleaned
WHERE review_scores_rating IS NOT NULL
AND review_scores_accuracy IS NOT NULL
AND review_scores_cleanliness IS NOT NULL
AND review_scores_checkin IS NOT NULL
AND review_scores_communication IS NOT NULL
AND review_scores_location IS NOT NULL
AND review_scores_value IS NOT NULL
GROUP BY 1

)

SELECT
host_id,
ROUND((avg_review_scores_rating + avg_review_scores_accuracy + avg_review_scores_cleanliness + avg_review_scores_checkin + avg_review_scores_communication + avg_review_scores_location + avg_review_scores_value) / 7, 2) AS overall_rating
FROM host_ratings_cte
LIMIT 10

-- 12. Number of reviews per host

SELECT
DISTINCT host_id,
COUNT(number_of_reviews)
FROM listings_cleaned
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


/*=========================
 EDA - Neighbourhood metrics
=========================*/

-- 1. Distribution of properties by neighbourhood (absolute + percentage)

SELECT
neighbourhood_cleansed,
COUNT(*),
ROUND(100.0 * COUNT(*)/SUM(COUNT(*)) OVER (),2) AS pct
FROM listings_cleaned
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 2. Distribution of properties by neighbourhood_group (absolute + percentage)

SELECT
neighbourhood_group_cleansed,
COUNT(*),
ROUND(100.0 * COUNT(*)/SUM(COUNT(*)) OVER (),2) AS pct
FROM listings_cleaned
GROUP BY 1
ORDER BY 2 DESC

-- 3.1 Average prices per neighbourhood (NOTE: results affected by outliers)

SELECT
neighbourhood_cleansed,
ROUND(AVG(price_dollars),2) AS avg_price
FROM listings_cleaned
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 3.2 Average prices per neighbourhood (with outliers removed)

WITH price_outliers_removed_cte AS (
SELECT
neighbourhood_cleansed,
neighbourhood_group_cleansed,
price_dollars
FROM listings_cleaned
WHERE price_dollars < 10000
)

SELECT
neighbourhood_cleansed,
ROUND(AVG(price_dollars),2) AS avg_price
FROM price_outliers_removed_cte
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 4.1 Average prices per neighbourhood_group (NOTE: results affected by outliers)

SELECT
neighbourhood_group_cleansed,
ROUND(AVG(price_dollars),2) AS avg_price
FROM listings_cleaned
GROUP BY 1
ORDER BY 2 DESC

-- 4.2 Average prices per neighbourhood_group (with outliers removed)

WITH price_outliers_removed_cte AS (
SELECT
neighbourhood_cleansed,
neighbourhood_group_cleansed,
price_dollars
FROM listings_cleaned
WHERE price_dollars < 10000
)

SELECT
neighbourhood_group_cleansed,
ROUND(AVG(price_dollars),2) AS avg_price
FROM price_outliers_removed_cte
GROUP BY 1
ORDER BY 2 DESC

-- 5. Distribution of room types per neighbourhood

SELECT
neighbourhood_cleansed,
room_type,
COUNT(*),
ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY neighbourhood_cleansed),2) AS pct_of_neighbourhood
FROM listings_cleaned
GROUP BY 1,2
ORDER BY 1,2
LIMIT 10

-- 6. Distribution of room types per neighbourhood_group

SELECT
neighbourhood_group_cleansed,
room_type,
COUNT(*),
ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY neighbourhood_group_cleansed),2) AS pct_of_neighbourhood
FROM listings_cleaned
GROUP BY 1,2
ORDER BY 1,2
LIMIT 10

-- 7. Number of reviews per neighbourhood (all time, last 12 months, last 30 days)

SELECT
neighbourhood_cleansed,
SUM(number_of_reviews) AS total_number_of_reviews,
SUM(number_of_reviews_ltm) AS total_number_of_reviews_ltm,
SUM(number_of_reviews_l30d) AS total_number_of_reviews_l30d
FROM listings_cleaned
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 8. Number of reviews per neighbourhood_group (all time, last 12 months, last 30 days)

SELECT
neighbourhood_group_cleansed,
SUM(number_of_reviews) AS total_number_of_reviews,
SUM(number_of_reviews_ltm) AS total_number_of_reviews_ltm,
SUM(number_of_reviews_l30d) AS total_number_of_reviews_l30d
FROM listings_cleaned
GROUP BY 1
ORDER BY 2 DESC

-- 9. Neighbourhoods with best ratings (average ratings per neighbourhood)

WITH neighbourhood_ratings_cte AS (
SELECT
neighbourhood_cleansed,
ROUND(AVG(review_scores_rating), 2) AS avg_review_scores_rating,
ROUND(AVG(review_scores_accuracy), 2) AS avg_review_scores_accuracy,
ROUND(AVG(review_scores_cleanliness), 2) AS avg_review_scores_cleanliness,
ROUND(AVG(review_scores_checkin), 2) AS avg_review_scores_checkin,
ROUND(AVG(review_scores_communication), 2) AS avg_review_scores_communication,
ROUND(AVG(review_scores_location), 2) AS avg_review_scores_location,
ROUND(AVG(review_scores_value), 2) AS avg_review_scores_value
FROM listings_cleaned
WHERE review_scores_rating IS NOT NULL
AND review_scores_accuracy IS NOT NULL
AND review_scores_cleanliness IS NOT NULL
AND review_scores_checkin IS NOT NULL
AND review_scores_communication IS NOT NULL
AND review_scores_location IS NOT NULL
AND review_scores_value IS NOT NULL
GROUP BY 1
)

SELECT
neighbourhood_cleansed,
ROUND((avg_review_scores_rating + avg_review_scores_accuracy + avg_review_scores_cleanliness + avg_review_scores_checkin + avg_review_scores_communication + avg_review_scores_location + avg_review_scores_value) / 7, 2) AS overall_rating
FROM neighbourhood_ratings_cte
ORDER BY 2 DESC
LIMIT 10

-- 10. Neighbourhood groups with best ratings (average ratings per neighbourhood_group)

WITH neighbourhood_group_ratings_cte AS (
SELECT
neighbourhood_group_cleansed,
ROUND(AVG(review_scores_rating), 2) AS avg_review_scores_rating,
ROUND(AVG(review_scores_accuracy), 2) AS avg_review_scores_accuracy,
ROUND(AVG(review_scores_cleanliness), 2) AS avg_review_scores_cleanliness,
ROUND(AVG(review_scores_checkin), 2) AS avg_review_scores_checkin,
ROUND(AVG(review_scores_communication), 2) AS avg_review_scores_communication,
ROUND(AVG(review_scores_location), 2) AS avg_review_scores_location,
ROUND(AVG(review_scores_value), 2) AS avg_review_scores_value
FROM listings_cleaned
WHERE review_scores_rating IS NOT NULL
AND review_scores_accuracy IS NOT NULL
AND review_scores_cleanliness IS NOT NULL
AND review_scores_checkin IS NOT NULL
AND review_scores_communication IS NOT NULL
AND review_scores_location IS NOT NULL
AND review_scores_value IS NOT NULL
GROUP BY 1
)

SELECT
neighbourhood_group_cleansed,
ROUND((avg_review_scores_rating + avg_review_scores_accuracy + avg_review_scores_cleanliness + avg_review_scores_checkin + avg_review_scores_communication + avg_review_scores_location + avg_review_scores_value) / 7, 2) AS overall_rating
FROM neighbourhood_group_ratings_cte
ORDER BY 2 DESC

-- 11. Neighbourhoods with best location ratings (average location ratings per neighbourhood)

SELECT
neighbourhood_cleansed,
ROUND(AVG(review_scores_location), 2) AS avg_review_scores_location
FROM listings_cleaned
WHERE review_scores_location IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 12. Neighbourhood groups with best location ratings (average location ratings per neighbourhood_group)

SELECT
neighbourhood_group_cleansed,
ROUND(AVG(review_scores_location), 2) AS avg_review_scores_location
FROM listings_cleaned
WHERE review_scores_location IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC



/*=================================
 EDA - Booking/availability metrics
===================================*/

-- 1. Number of instant bookable vs. non-instant bookable properties

SELECT
instant_bookable,
COUNT(*)
FROM listings_cleaned
GROUP BY 1
ORDER BY 1

-- 2. Average minimum and maximum nights booked

SELECT
ROUND(AVG(minimum_nights)) AS avg_min_nights,
ROUND(AVG(maximum_nights)) AS avg_max_nights
FROM listings_cleaned

-- 3.1 Average availability out of 30 days by neighbourhood

SELECT
neighbourhood_cleansed,
ROUND(AVG(availability_30), 1)
FROM listings_cleaned
GROUP BY 1
ORDER BY 2
LIMIT 10

-- 3.2 Average availability out of 60 days by neighbourhood

SELECT
neighbourhood_cleansed,
ROUND(AVG(availability_60), 1)
FROM listings_cleaned
GROUP BY 1
ORDER BY 2
LIMIT 10

-- 3.3 Average availability out of 90 days by neighbourhood

SELECT
neighbourhood_cleansed,
ROUND(AVG(availability_90), 1)
FROM listings_cleaned
GROUP BY 1
ORDER BY 2
LIMIT 10

-- 3.4 Average availability out of 365 days by neighbourhood

SELECT
neighbourhood_cleansed,
ROUND(AVG(availability_365), 1)
FROM listings_cleaned
GROUP BY 1
ORDER BY 2
LIMIT 10

-- 4.1 Average availability out of 30 days by neighbourhood_group

SELECT
neighbourhood_group_cleansed,
ROUND(AVG(availability_30), 1)
FROM listings_cleaned
GROUP BY 1
ORDER BY 2

-- 4.2 Average availability out of 60 days by neighbourhood_group

SELECT
neighbourhood_group_cleansed,
ROUND(AVG(availability_60), 1)
FROM listings_cleaned
GROUP BY 1
ORDER BY 2

-- 4.3 Average availability out of 90 days by neighbourhood_group

SELECT
neighbourhood_group_cleansed,
ROUND(AVG(availability_90), 1)
FROM listings_cleaned
GROUP BY 1
ORDER BY 2

-- 4.4 Average availability out of 365 days by neighbourhood_group

SELECT
neighbourhood_group_cleansed,
ROUND(AVG(availability_365), 1)
FROM listings_cleaned
GROUP BY 1
ORDER BY 2
