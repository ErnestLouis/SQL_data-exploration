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
WHERE continent  IS NOT NULL
GROUP BY continent
ORDER BY  highest_death_count desc
