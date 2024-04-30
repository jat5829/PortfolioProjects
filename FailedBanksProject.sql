/*

Queries used for Failed Banks Project and exploring the data

*/

SELECT *
FROM failedbanks;

-- Looking at all banks in the order they closed since the year 2000

SELECT *
FROM failedbanks
ORDER BY closing_date ASC;

-- Looking at the amount of banks that failed per state since the year 2000

SELECT COUNT(bank_name) AS number_of_failed_banks, states
FROM failedbanks
GROUP BY states
ORDER BY number_of_failed_banks DESC;

-- Looking at the failed banks who had 'no acquirer' who took over afterward

SELECT bank_name, city, states, acquiring_institution
FROM failedbanks
WHERE acquiring_institution = 'No Acquirer';

-- Let's group them by state to see which state had the most banks who weren't recovered by another institution

SELECT COUNT(acquiring_institution) AS number_of_no_acquirers, states
FROM failedbanks
WHERE acquiring_institution = 'No Acquirer'
GROUP BY states
ORDER BY number_of_no_acquirers DESC;

-- From the results, it's evident Georgia (GA) has a history of the most failed banks since 2000.
-- Using this data, let's see if there are any specific cities in Georgia (GA) that have a higher closure rate than others.

SELECT COUNT(bank_name) AS number_of_failed_banks, city AS city_in_georgia
FROM failedbanks
WHERE states = 'GA'
GROUP BY city
ORDER BY number_of_failed_banks DESC;

-- Looking at the top 10 cities with the highest rate of bank failures since 2000.
-- Although the Georgia has more bank failures across the entire state, Illinois has a higher concentration of banks failing in one city since 2000.
-- And that city is Chicago, IL.

SELECT city, states, COUNT(bank_name) AS number_of_failed_banks
FROM failedbanks
GROUP BY city, states
ORDER BY number_of_failed_banks DESC
LIMIT 10;
