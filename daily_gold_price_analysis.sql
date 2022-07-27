-- Hello, this is the code for the Daily Gold Price Analysis on https://public.tableau.com/app/profile/ph.m.ti.n.h.ng/viz/DailyPriceOverview/OverviewPrices--
-- Link to the Dataset: https://www.kaggle.com/datasets/psycon/daily-coffee-price/code?datasetId=2187517&sortBy=voteCount --
-- Alright, let's jump into our analysis! --
-- AS always, create the databse name gold_price, and then import our dataset into gold_price_data table --
create database gold_price;
use gold_price;
-- Then, we glance thourgh the dataset --
select * from gold_price_data;
-- Notice the Date column consists of year, month and day, we can do an overview over year --
-- Moreover, As you can also see that there's a large amount of volumes at the end of each month ( from 25 ) --
-- So Let's see if i'm right, using subquery should do the job --
SELECT 
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    DAY(Date) AS Day,
    Volume AS max_volume_of_month
FROM
    gold_price_data
WHERE
    volume IN (SELECT 
            MAX(volume) AS max_volume
        FROM
            gold_price_data
        GROUP BY YEAR(Date) , MONTH(Date));
-- Suprisingly, there's also a lot of volume transactions on start of each month, let's group it and count --
SELECT 
    Day, COUNT(*) AS frequency,Sum(max_volume) as total_volume
FROM
    (SELECT 
        YEAR(Date) AS Year,
            MONTH(Date) AS Month,
            DAY(Date) AS Day,
            Volume AS max_volume
    FROM
        gold_price_data
    WHERE
        volume IN (SELECT 
                MAX(volume) AS max_volume
            FROM
                gold_price_data
            GROUP BY YEAR(Date) , MONTH(Date))) AS max_vol_in_month
GROUP BY Day
ORDER BY 2 DESC
LIMIT 10;
-- So I'm actually right on the fact that a lot of Volumes are in the start or end of each month ( maybe people getting their salary and jump into gold immediately ?)
-- Okay and then finally, let's, do some visualization around 5 years, starting from 2018, compute average open,close,... for each year--
SELECT 
    YEAR(Date) AS Year,
    ROUND(AVG(Open), 1) AS avg_open,
    ROUND(AVG(Close), 1) AS avg_close,
    ROUND(AVG(High), 1) AS avg_high,
    ROUND(AVG(Low), 1) AS avg_low,
    ROUND(AVG(volume), 0) AS avg_volume,
    sum(volume) as total_volume
FROM
    gold_price_data
where year(Date) >= 2018
GROUP BY Year;
-- Okay, this dataset isn't too hard for everyone, so i'm gonna export all these data for the visualization later, Thank you for reading my explaination ! --