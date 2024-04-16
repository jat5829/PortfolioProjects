SELECT locations, dates, total_cases, new_cases, total_deaths, population
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Looking at Total Cases vs Total Deaths
-- Explores the chances of you dying if you contract the Covid-19 virus in the United States
SELECT locations, dates, total_cases, total_deaths, ((total_deaths::numeric / total_cases::numeric) * 100) AS DeathPercentage
FROM coviddeaths
WHERE locations = 'United States'
AND continent IS NOT NULL
ORDER BY 1,2;

-- Looking at Total Cases vs Population
-- Explores the percentage of population who contracted the Covid-19 virus in the United States
SELECT locations, dates, total_cases, population, ((total_cases::numeric / population::numeric) * 100) AS Pecentage_Population_Infected
FROM coviddeaths
WHERE locations = 'United States'
AND continent IS NOT NULL
ORDER BY 1,2;

-- Looking at Countries with Highest Infection Rate compared to Population

SELECT locations, population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases::numeric / population::numeric) * 100) AS Pecentage_Population_Infected
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY locations, population
ORDER BY Pecentage_Population_Infected DESC;

-- Looking at Countries with Highest Death Count per Population

SELECT locations, MAX(total_deaths::int) AS Total_Death_Count
FROM coviddeaths
WHERE continent IS NOT NULL
AND total_deaths IS NOT NULL
GROUP BY locations
ORDER BY Total_Death_Count DESC;

-- Looking at Continents with Highest Death Count per Population

SELECT continent, MAX(total_deaths::int) AS Total_Death_Count
FROM coviddeaths
WHERE continent IS NOT NULL
AND total_deaths IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC;

-- Looking at Covid-19 virus deadliness across the entire world

SELECT SUM(new_cases::numeric) AS total_cases, SUM(new_deaths::numeric) AS total_deaths, SUM(new_deaths::numeric) / SUM(new_cases) * 100 as DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.locations, dea.dates, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.locations ORDER BY dea.locations, dea.dates) AS Rolling_People_Vaccinated
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
SELECT dea.continent, dea.locations, dea.dates, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.locations ORDER BY dea.locations, dea.dates) AS Rolling_People_Vaccinated
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.locations = vac.locations
	AND dea.dates = vac.dates
WHERE dea.continent IS NOT NULL
)
SELECT *, (Rolling_People_Vaccinated/Population) * 100 AS New_Percentage_Vaccinated
FROM PopvsVac;


-- Creating View to Store Data for later Visualizations

DROP VIEW IF EXISTS Percent_Population_Vaccinated;
CREATE VIEW Percent_Population_Vaccinated AS
SELECT dea.continent, dea.locations, dea.dates, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.locations ORDER BY dea.locations, dea.dates) AS Rolling_People_Vaccinated
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
	ON dea.locations = vac.locations
	AND dea.dates = vac.dates
WHERE dea.continent IS NOT NULL;

SELECT *
FROM Percent_Population_Vaccinated;

