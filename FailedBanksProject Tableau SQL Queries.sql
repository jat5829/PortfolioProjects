/*

Queries used for Failed Banks Project and building Visualizations in Tableau

*/

SELECT *
FROM failedbanks;

-- 1. Looking at the number of banks that failed per state since the year 2000

SELECT COUNT(bank_name) AS number_of_failed_banks, states
FROM failedbanks
GROUP BY states
ORDER BY number_of_failed_banks DESC;

-- 2. Looking at the top 10 cities with the highest rate of bank failures since 2000

SELECT city, states, COUNT(bank_name) AS number_of_failed_banks
FROM failedbanks
GROUP BY city, states
ORDER BY number_of_failed_banks DESC
LIMIT 10;

-- 3. Looking at the number of banks that failed per season (Spring, Summer, Fall, Winter)

SELECT 
    CASE WHEN EXTRACT(MONTH FROM closing_date) IN (12, 1, 2) THEN 'Winter'
         WHEN EXTRACT(MONTH FROM closing_date) IN (3, 4, 5) THEN 'Spring'
         WHEN EXTRACT(MONTH FROM closing_date) IN (6, 7, 8) THEN 'Summer'
         WHEN EXTRACT(MONTH FROM closing_date) IN (9, 10, 11) THEN 'Fall'
    END AS season,
    COUNT(*) AS number_of_failed_banks
FROM failedbanks
GROUP BY season;

-- 4. Looking at the states with the highest percentage of bank failures in respect to the entire United States' number of bank failures

SELECT states, 
    ROUND(((COUNT(bank_name)::numeric / (SELECT SUM(count) FROM (SELECT COUNT(bank_name) FROM failedbanks GROUP BY states) AS subquery)) * 100), 1) AS percentage_of_bank_failures
FROM failedbanks
GROUP BY states
ORDER BY percentage_of_bank_failures DESC;

-- 5. Looking at the number of banks that failed per month and per year

SELECT 
	CASE WHEN EXTRACT(MONTH FROM closing_date) IN (1) THEN 'January'
		 WHEN EXTRACT(MONTH FROM closing_date) IN (2) THEN 'February'
		 WHEN EXTRACT(MONTH FROM closing_date) IN (3) THEN 'March'
		 WHEN EXTRACT(MONTH FROM closing_date) IN (4) THEN 'April'
		 WHEN EXTRACT(MONTH FROM closing_date) IN (5) THEN 'May'
		 WHEN EXTRACT(MONTH FROM closing_date) IN (6) THEN 'June'
		 WHEN EXTRACT(MONTH FROM closing_date) IN (7) THEN 'July'
		 WHEN EXTRACT(MONTH FROM closing_date) IN (8) THEN 'August'
		 WHEN EXTRACT(MONTH FROM closing_date) IN (9) THEN 'September'
		 WHEN EXTRACT(MONTH FROM closing_date) IN (10) THEN 'October'
		 WHEN EXTRACT(MONTH FROM closing_date) IN (11) THEN 'November'
		 WHEN EXTRACT(MONTH FROM closing_date) IN (12) THEN 'December'
	END AS months,
	EXTRACT(YEAR FROM closing_date) AS years,
	COUNT(bank_name) AS number_of_failed_banks
FROM failedbanks
GROUP BY EXTRACT(MONTH FROM closing_date), EXTRACT(YEAR FROM closing_date)
ORDER BY years ASC;
