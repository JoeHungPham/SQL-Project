-- First of all, we need to create the database, name it bigbaseket_products --
create database bigbasket_products;
use bigbasket_products;
-- Activate the database, all things set, now we move on to have an overview about the data --
SELECT 
    *
FROM
    big_basket_products;
-- Glance over the table, the product and brand are very different from each other, I would like to see how many brand and product,... --
SELECT 
    COUNT(DISTINCT brand) AS num_of_brands,
    COUNT(DISTINCT type) AS num_of_type,
    COUNT(DISTINCT product) AS num_of_products,
    COUNT(DISTINCT sub_category) AS num_of_sub_category,
    COUNT(DISTINCT category) AS num_of_category
FROM
    big_basket_products;
/* Interestingly, the number of brands, types and producst are over 100, meaning that we have a lot of distinct 
value here, the sub category count is 60 meaning that we shouldn't use this variable to do the visualization.
The last key is number of category, only 10, we could use this to visualize on how much the product is in that category,
rating, price,... */ 
SELECT 
    category, COUNT(*) AS quantity
FROM
    big_basket_products
GROUP BY category;
-- After finish this, I export the result to a csv file for later visualization, move on to our analysis --
-- Then, I want to do some category rating analysis, this could help me check the rating measure, scale 0 to 5 --
SELECT 
    category,
    MAX(rating) AS max_rating,
    MIN(rating) AS min_rating,
    ROUND(AVG(rating), 2) AS avg_rating
FROM
    big_basket_products
GROUP BY category;
-- Export this into another csv file, category analysis done --
-- Continue our analysis, we would like to see top 5 most expensive price --
SELECT 
    product,
    category,
    sub_category,
    brand,
    sale_price,
    market_price,
    rating
FROM
    big_basket_products
ORDER BY sale_price DESC, market_price desc
LIMIT 5;
-- Export this into another csv file -- 
/* Next, I would like to set the product range for the dataset, I don't have much understanding in India's currency
so this is just my opinion on how to label 'Low Price','Medium Price' and 'High Price' */
SELECT 
    CASE
        WHEN sale_price BETWEEN 10 AND 500 THEN 'Low Price'
        WHEN sale_price BETWEEN 501 AND 1000 THEN 'Medium Price'
        ELSE 'High Price'
    END AS price_range,
    COUNT(*) AS quantity
FROM
    big_basket_products
GROUP BY price_range
ORDER BY 2 DESC;
/* We could see that most of the product's price are in Low Price range, 10 to 500, this supermarket's target 
csutomer might be low-income to medium-income family */ 
/* After scrolling through the dataset multiple times, I noticed that there are some differences in sale_price and
market_price, I would like to add another column to see whether the price is different or not, and how many products
were sold lower than market_price  */
SELECT 
    CASE
        WHEN sale_price > market_price THEN 'Higher Price'
        WHEN sale_price < market_price THEN 'Lower Price'
        ELSE 'Equal Price'
    END AS sale_market_price,
    COUNT(*) AS counting
FROM
    big_basket_products
GROUP BY sale_market_price;
-- Export this result to a csv file, finish our price analysis -- 
-- Finally, I personally would like to see some product in Food category, who doesn't love food, right ? -- 
SELECT 
    *
FROM
    big_basket_products
WHERE
    category LIKE '%food%'
ORDER BY rating DESC
LIMIT 3;
/* Order by rating, funnily two of them are my favorite dishes, salted pumpkin and green peas ( I prefer wasabi
green peas), their rating are over 4.5, which is amazing, export them now for visualization , can't wait to eat */ 

