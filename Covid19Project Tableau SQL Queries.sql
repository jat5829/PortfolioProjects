/*

Queries used for Covid-19 Mortality Rate Project and building Visualizations in Tableau

*/



-- 1. Looking at Total Cases, Total Deaths, and Death Percentage Worldwide

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS numeric)) AS total_deaths, SUM(CAST(new_deaths AS numeric)) / SUM(New_Cases) * 100 AS DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL 
ORDER BY 1,2;


-- 2. Looking at Total Deaths Per Continent

-- I take out the following locations ('World', 'European Union', 'International') as they are not inluded in the above queries and want to stay consistent.
-- European Union is already part of Europe.

SELECT locations, SUM(CAST(new_deaths AS int)) AS Total_Death_Count
FROM coviddeaths
WHERE continent is null 
AND locations NOT IN ('World', 'European Union', 'International')
GROUP BY locations
ORDER BY Total_Death_Count DESC;


-- 3. Percentage of Population Infected Per Country

SELECT locations, population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases::numeric/population::numeric)) * 100 AS Percent_Population_Infected
FROM coviddeaths
GROUP BY locations, population
ORDER BY Percent_Population_Infected DESC;


-- 4. Percentage of Population Infected Per Month


SELECT locations, population, dates, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases::numeric/population::numeric)) * 100 AS Percent_Population_Infected
FROM coviddeaths
GROUP BY locations, population, dates
ORDER BY Percent_Population_Infected DESC;


-- 5. Rolling Percentage of Population Vaccinated over time

SELECT dea.continent, dea.locations, dea.dates, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations::numeric) OVER (PARTITION BY dea.locations ORDER BY dea.locations, dea.dates) AS Rolling_People_Vaccinated
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.locations = vac.locations
	AND dea.dates = vac.dates
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;


-- Using a CTE (Common Table Expression)

WITH PopvsVac (Continent, Locations, Dates, Population, New_Vaccinations, Rolling_People_Vaccinated)
AS
(
SELECT dea.continent, dea.locations, dea.dates, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.locations ORDER BY dea.locations, dea.dates) AS Rolling_People_Vaccinated
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.locations = vac.locations
	AND dea.dates = vac.dates
WHERE dea.continent IS NOT NULL
)
SELECT *, (Rolling_People_Vaccinated/Population) * 100 AS New_Percentage_Vaccinated
FROM PopvsVac;











