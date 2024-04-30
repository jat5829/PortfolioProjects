SELECT *
FROM failedbanks;

-- Looking at all banks in the order they closed since the year 2000

SELECT *
FROM failedbanks
ORDER BY closing_date ASC;

-- Looking at the amount of banks that failed per city since the year 2000

SELECT COUNT(city) AS number_of_failed_banks, states
FROM failedbanks
GROUP BY states;

-- Looking