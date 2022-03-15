/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

--View imported Data from both tables

SELECT * FROM Covid19Project..Covid_deaths
WHERE continent is not null 
ORDER BY 3,4

SELECT * FROM Covid19Project..Covid_vaccinations
WHERE continent is not null 
ORDER BY 3,4

--SELECT DATA THE WILL BE USED

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Covid19Project..Covid_deaths
WHERE continent is not null 
ORDER BY 1,2 --ordered by location and date

--SELECT Total CASES VS TOTAL DEATHS PER COUNTRY

SELECT Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage--to get percentage
FROM Covid19Project..Covid_deaths
WHERE continent is not null 
ORDER BY 1,2 --ordered by location and date

--SELECT Total CASES VS TOTAL DEATHS IN THE UNITED STATES
--Projects liklihood of death from countracting covid in designated country
SELECT Location, date, total_cases,total_deaths,ROUND((total_deaths/total_cases)*100,2) as death_percentage--to get percentage rounded 2 decimal places
FROM Covid19Project..Covid_deaths
WHERE location = 'United States'
ORDER BY 1,2 --ordered by location and date

--SELECT TOTAL CASES VS POPULATION IN THE UNITED STATES
SELECT Location, date, population,total_cases,ROUND((total_cases/population)*100,3) as case_percentage--to get percentage rounded 3 decimal places
FROM Covid19Project..Covid_deaths
WHERE location like '%states%'
ORDER BY 1,2 

--SELECT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT Location, population,MAX(total_cases) AS highest_case_count,MAX(ROUND((total_cases/population)*100,3)) as case_percentage--to get percentage rounded 3 decimal places
FROM Covid19Project..Covid_deaths
Group BY Location, Population
ORDER BY case_percentage desc


--DISPLAY COUNTRIES W/HIGHEST DEATH COUNT PER POPULATION
SELECT Location, MAX(CAST(total_deaths as bigint)) AS highest_death_count
FROM Covid19Project..Covid_deaths
WHERE continent IS NOT NULL
Group BY Location
ORDER BY highest_death_count desc


--DISPLAY CONTINENT W/HIGHEST DEATH COUNT PER POPULATION
SELECT continent, MAX(CAST(total_deaths as bigint)) AS highest_death_count
FROM Covid19Project..Covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY  highest_death_count desc

--DISPLAYS WORLDWIDE STATS
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS INT)) AS total_deaths, SUM(cast(new_deaths AS INT))/SUM(new_cases)*100 AS death_percentage
FROM Covid19Project..Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- DISPLAYS TOTAL POPULATION vs VACCINATION
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY death.Location ORDER BY death.location, death.date ROWS UNBOUNDED PRECEDING) as number_people_vaccinated
FROM Covid19Project..Covid_deaths death
JOIN Covid19Project..Covid_vaccinations vac
	On death.location = vac.location
	AND death.date = vac.date
WHERE death.continent IS NOT NULL
ORDER BY  2,3

--USING CTE
--to perform Calculation on PARTITION BY in previous query

WITH pop_vsvac (continent, location, date, population, new_vaccinations, number_people_vaccinated)
AS
(
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY death.Location ORDER BY death.location, death.date ROWS UNBOUNDED PRECEDING) AS number_people_vaccinated
FROM Covid19Project..Covid_deaths death
JOIN Covid19Project..Covid_vaccinations vac
	On death.location = vac.location
	AND death.date = vac.date
WHERE death.continent IS NOT NULL
)
SELECT *, ROUND((number_people_vaccinated/population)*100,3) AS percentage_people_vaccinated
FROM pop_vsvac


-- USING TEMP TABLE 
--to perform calculation on PARTITION BY in previous query

DROP TABLE if exists #percentage_people_vaccinated
CREATE TABLE #percentage_people_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
number_people_vaccinated numeric
)

INSERT INTO #percentage_people_vaccinated
SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY death.Location ORDER BY death.location, death.date ROWS UNBOUNDED PRECEDING) AS number_people_vaccinated
FROM Covid19Project..Covid_deaths death
JOIN Covid19Project..Covid_vaccinations vac
	On death.location = vac.location
	AND death.date = vac.date

SELECT *, ROUND((number_people_vaccinated/population)*100,3) AS percentage_people_vaccinated
From #percentage_people_vaccinated

