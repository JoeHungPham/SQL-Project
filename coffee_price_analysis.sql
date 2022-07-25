-- Link to the dataset: https://www.kaggle.com/datasets/psycon/daily-coffee-price --
-- First of all, create the coffee database --
create database coffee;
use coffee;
-- Then, import the dataset into the database, name the table coffee_price_data --
-- Have a overall view of the dataset --
select * from coffee_price_data;
-- Since there is no null value ( on kaggle's dataset description)
-- We can do an open price histogram to see how's the price distributed, export to a csv file --
select case
when Open < 50 then 'Smaller than 50$'
when Open between 50 and 100 then '50$ and 100$'
when Open between 100 and 150 then '100$ and 150$'
when Open between 150 and 200 then '150$ and 200$'
else 'Higher than 200$' end as open_hist,
count(*) as `Count`
from coffee_price_data
group by open_hist;
-- Next, I wanna summarise about open/close/volume over the past 10 years, export this to another csv file --
select year(Date) as `year`,
max(Open) as max_open, min(Open) as min_open,round(avg(Open),1) as avg_open,
max(Close) as max_close, min(Close) as min_close,round(avg(Close),1) as avg_close,
max(volume) as max_colume, round(avg(Volume),0) as avg_volume
from coffee_price_data
group by year
having year between 2013 and 2022;
/* Then, we would like to see the price change between open and close for 5 years, from 2018 to 2022,
export to a csv file */
select Year(Date) as `year`,month(Date) as `month`,
round(avg(Open) - avg(Close),1) as `change`
from coffee_price_data
where year(Date) between 2018 and 2022
group by year, month
order by 1, 2;
-- Finally, I would like to see 2021's volume as it was affected very much by Covid 19 --
select month(Date) as `Month`,
sum(Volume) as total_volume
from coffee_price_data
where year(Date) = 2021
group by `Month`;
/* This is end. By plotting over Tableu, We clearly see that the price's distribution is around 50$ to 200$,
price change in 2021 fluctuated the most. And average Open and Close Prices rise from 2020 to 2022 thanks to 
Covid recoverty */


