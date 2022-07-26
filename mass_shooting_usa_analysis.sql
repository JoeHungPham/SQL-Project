-- Hello, this is my code on Mass Shootings in USA Visualization, written on 2022/07/27 --
-- Link to the dataset: https://www.kaggle.com/datasets/rprkh15/history-of-mass-shootings-in-the-usa --
-- Alright, here we go. First of all, create the database named usa_shooting --
/* If you had already read my previous code I posted on github, you should already know that I always export
each code section into a csv file for visualization later, you can find my work on 
https://public.tableau.com/app/profile/ph.m.ti.n.h.ng#!/?newProfile=&activeTab=0 */
create database usa_shooting;
use usa_shooting;
-- Then, import the dataset you just downloaded into a new table, I named it mass_shooting_usa_data --
-- After finishing importing, glance through the dataset, to see if there is any null value, weird data,etc... --
SELECT 
    *
FROM
    mass_shooting_usa_data;
-- Okay, so we got date(ymd), city, state, dead , injured, total(dead+injured) and finally description(bloody long)
-- I wanna see the Total Dead, Injured, and Total, and also Average Cases per year --
-- Notice it took me some effort to pull out the Average cases per year, using subquery --
SELECT 
    SUM(Dead) AS total_dead,
    SUM(Injured) AS total_injured,
    SUM(Total) AS total_cases,
    (select round(avg(tc.total),0)
from (select sum(total) as total from mass_shooting_usa_data group by year(Date)) as tc) as avg_cases_per_year
FROM
    mass_shooting_usa_data;
-- Next, I want to categorize Cases by Year. to see how the cases rise/fall over the year --
SELECT 
    YEAR(Date) AS year,
    sum(Total) AS total_cases,
    sum(dead) as total_dead,
    sum(injured) as total_injured
FROM
    mass_shooting_usa_data
GROUP BY year
ORDER BY 1;
-- It rises, god bless the victims --
-- After that, I wanna group by city and states, slice it to take the top 20 --
SELECT 
    City,
    SUM(total) AS total_cases,
    SUM(dead) AS total_dead,
    SUM(injured) AS total_injured
FROM
    mass_shooting_usa_data
GROUP BY City
ORDER BY 2 DESC
LIMIT 20;
-- Do the same for State --
SELECT 
    State,
    SUM(total) AS total_cases,
    SUM(dead) AS total_dead,
    SUM(injured) AS total_injured
FROM
    mass_shooting_usa_data
GROUP BY state
ORDER BY 2 DESC
LIMIT 20;
/* Moreover, I wanna do the analysis whether shootings occur more often on weekend or not since
people often go out on weekends, let's see if I'm right */
SELECT 
    DAYNAME(Date) AS day_of_week, SUM(Total) AS total_cases
FROM
    mass_shooting_usa_data
GROUP BY day_of_week
ORDER BY 2 DESC;
-- OMG, it's true, you likely to get into a shooting case on Weekends, should be more careful on weekends !! --
-- Finally, I would like to make a State Map visualization by Cases --
SELECT 
    state, SUM(total) AS total_cases
FROM
    mass_shooting_usa_data
GROUP BY state;
-- So overall, the most States that shooting happen more often are in West and East --
-- The number of victims increase overtime and these shootings are getting dealier and more common --
/* The Government should regulate more gun ownership, usage in these two region ASAP, or things are gonna 
get worse and worse */