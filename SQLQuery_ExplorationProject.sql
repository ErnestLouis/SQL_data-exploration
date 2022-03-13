--View imported Data from both tables

SELECT * FROM Covid19Project..Covid_deaths
ORDER BY 3,4

SELECT * FROM Covid19Project..Covid_vaccinations
ORDER BY 3,4

--SELECT DATA THE WILL BE USED

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Covid19Project..Covid_deaths
ORDER BY 1,2 --ordered by location and date

--SELECT Total CASES VS TOTAL DEATHS PER COUNTRY

SELECT Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage--to get percentage
FROM Covid19Project..Covid_deaths
ORDER BY 1,2 --ordered by location and date
