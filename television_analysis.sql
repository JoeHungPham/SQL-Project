/* This SQL code is for the Television Sale in India.
Link to the dataset https://www.kaggle.com/datasets/mdwaquarazam/television-dataset-2022?datasetId=2320250&sortBy=voteCount. 
First of all, create database, name it television. */
create database television;
use television;
-- After that, import our data into the database, name it television_data --
-- Glance throught the dataset --
select * from television_data;
/* As you can see, the current_price and mrp are in unreadable form, but compare to the original dataset, we can just remove 
first 3 character than add in rupee after the column for currency info, that would be like this */
SELECT 
    Product_name,
    Stars,
    Ratings,
    Reviews,
    SUBSTR(current_price,
        4,
        LENGTH(current_price) - 3) AS current_price_rupee,
    SUBSTR(MRP, 4, LENGTH(MRP) - 3) AS MRP_rupee,
    channel,
    Operating_system,
    Picture_qualtiy,
    Speaker,
    Frequency,
    Image_url
FROM
    television_data;
-- Alright, now we need a new table to insert all these data, I'll add 'clean' after the previous dataset's name --
CREATE TABLE television_data_clean (
  `Product_Name` text,
  `Stars` double DEFAULT NULL,
  `Ratings` int DEFAULT NULL,
  `Reviews` int DEFAULT NULL,
  `current_price` text,
  `MRP` text,
  `channel` text,
  `Operating_system` text,
  `Picture_qualtiy` text,
  `Speaker` text,
  `Frequency` text,
  `Image_url` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- Insert the data into new table, no problem --
insert into television_data_clean 
SELECT 
    Product_name,
    Stars,
    Ratings,
    Reviews,
    SUBSTR(current_price,
        4,
        LENGTH(current_price) - 3) AS current_price_rupee,
    SUBSTR(MRP, 4, LENGTH(MRP) - 3) AS MRP_rupee,
    channel,
    Operating_system,
    Picture_qualtiy,
    Speaker,
    Frequency,
    Image_url
FROM
    television_data;
-- Revise it again--
select * from television_data_clean;
-- Select top 5 product price, notice that we have 2 same LG product, but let's just take it for visualization --
SELECT 
    *
FROM
    television_data_clean
ORDER BY current_price DESC
LIMIT 5;
-- Count each product, take not much effort --
SELECT 
    Product_name, COUNT(*) AS `count`
FROM
    television_data_clean
GROUP BY Product_Name
ORDER BY 2 DESC
LIMIT 5;
-- Next, I want to analyze on picture quality whether it is HD ( 720p) or full HD ( 1080p) and Ultra HD --
-- I also notice that 60hz TV only support HD ready only, which is 720p, let's just put it in HD TV category --
SELECT 
    CASE
        WHEN Picture_quality LIKE 'HD Ready%' THEN 'HD TV'
        WHEN Picture_quality LIKE 'Full HD%' THEN 'Full HD TV'
        WHEN Picture_quality LIKE 'Ultra HD%' THEN '4K UHD TV'
        ELSE 'HD TV'
    END AS tv_quality,
    COUNT(*) AS quantity,
    ROUND(AVG(current_price),0) AS avg_current_price,
    ROUND(AVG(MRP), 0) AS avg_mrp
FROM
    television_data_clean
GROUP BY tv_quality;
-- Then, I want to see how much TV use Android OS, by glance you could see it as well that many TV nowadays use Android OS --
SELECT 
    CASE
        WHEN operating_system LIKE '%Android%' THEN 'Android OS'
        ELSE 'Other OS'
    END AS op_sys,
    COUNT(*) AS total_products,
    ROUND((COUNT(*) * 100 / (SELECT 
                    COUNT(*)
                FROM
                    television_data_clean)),
            2) AS percentage
FROM
    television_data_clean
GROUP BY op_sys;
-- There are upto 55.59% of Total Products use Android OS, amazing --
-- After that, let's jump on to the rating section, sort the data by ratings and select top 5 product --
SELECT 
    *
FROM
    television_data_clean
ORDER BY 3 DESC
LIMIT 5;
-- We have 3 dupplicate realme but that's alright, we can still select only top 3 product for visualization, find 2 more would take more time --
SELECT 
    Stars, COUNT(*) AS total
FROM
    television_data_clean
GROUP BY stars
ORDER BY 2 DESC;
/* Lastly, I want to see how the Stars Rating spread from 0 to 5, we can see that a lot of customers don't really leave the rating to the 
product after buying, and the stars are also centered around 4 stars, seems like the TV in India is very good */


