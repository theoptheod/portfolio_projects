/*
Covid19 Data Exploration 

Skills used: 

Converting Data Types
Aggregate Functions
Windows Functions
Joins
CTEs 
Temp Tables
Views 

*/

--Create two tables in PostgreSQL and then import the according CSV files.
CREATE TABLE covid19_mortality(
iso_code VARCHAR(10),
continent VARCHAR(15),
location_country VARCHAR(35),
date DATE,
population BIGINT,
total_cases INT,
new_cases INT,
new_cases_smoothed NUMERIC(12,3),
total_deaths INT,
new_deaths INT,
new_deaths_smoothed NUMERIC(12,3),
total_cases_per_million NUMERIC(12,3),
new_cases_per_million NUMERIC(12,3),
new_cases_smoothed_per_million NUMERIC(12,3),
total_deaths_per_million NUMERIC(12,3),
new_deaths_per_million NUMERIC(12,3),
new_deaths_smoothed_per_million NUMERIC(12,3),
reproduction_rate NUMERIC(5,2),
icu_patients INT,
icu_patients_per_million NUMERIC(12,3),
hosp_patients INT,
hosp_patients_per_million NUMERIC(12,3),
weekly_icu_admissions INT,
weekly_icu_admissions_per_million NUMERIC(12,3),
weekly_hosp_admissions INT,
weekly_hosp_admissions_per_million NUMERIC(12,3)
);

CREATE TABLE covid19_vaccinations(
iso_code VARCHAR(10),
continent VARCHAR(15),
location_country VARCHAR(35),
date DATE,
total_tests BIGINT,
new_tests INT,
total_tests_per_thousand NUMERIC(12,3),
new_tests_per_thousand NUMERIC(12,3),
new_tests_smoothed INT,
new_tests_smoothed_per_thousand NUMERIC(12,3),
positive_rate NUMERIC(5,4),
tests_per_case NUMERIC(11,1),
tests_units VARCHAR(20),
total_vaccinations BIGINT,
people_vaccinated BIGINT,
people_fully_vaccinated BIGINT,
total_boosters BIGINT,
new_vaccinations INT,
new_vaccinations_smoothed INT,
total_vaccinations_per_hundred NUMERIC(5,2),
people_vaccinated_per_hundred NUMERIC(5,2),
people_fully_vaccinated_per_hundred NUMERIC(5,2),
total_boosters_per_hundred NUMERIC(5,2),
new_vaccinations_smoothed_per_million INT,
new_people_vaccinated_smoothed INT,
new_people_vaccinated_smoothed_per_hundred NUMERIC(12,3),
stringency_index NUMERIC(5,2),
population_density NUMERIC(12,3),
median_age NUMERIC(4,1),
aged_65_older NUMERIC(5,3),
aged_70_older NUMERIC(5,3),
gdp_per_capita NUMERIC(12,3),
extreme_poverty NUMERIC(4,1),
cardiovasc_death_rate NUMERIC(12,3),
diabetes_prevalence NUMERIC(5,2),
female_smokers NUMERIC(4,1),
male_smokers NUMERIC(4,1),
handwashing_facilities NUMERIC(6,3),
hospital_beds_per_thousand NUMERIC(5,2),
life_expectancy NUMERIC(5,2),
human_development_index NUMERIC(4,3),
excess_mortality_cumulative_absolute NUMERIC(12,3),
excess_mortality_cumulative NUMERIC(5,2),
excess_mortality NUMERIC(5,2),
excess_mortality_cumulative_per_million NUMERIC(12,3)
);

--Covid-19 case-fatality percentage over time.
SELECT
location_country AS country,
date,
total_cases,
total_deaths,
ROUND((total_deaths / CAST(total_cases AS NUMERIC(10,0))) * 100, 2) AS fatality_percentage
FROM public.covid19_mortality
WHERE continent IS NOT NULL
ORDER BY country ASC, date ASC;

--Covid-19 case-fatality percentage over time for a specified country.
SELECT
location_country AS country,
date,
total_cases,
total_deaths,
ROUND((total_deaths / CAST(total_cases AS NUMERIC(10,0))) * 100, 2) AS fatality_percentage
FROM public.covid19_mortality
--Add any country name in the following line.
WHERE location_country = 'Canada'
ORDER BY date ASC;

--Covid-19 case-fatality percentage per country.
SELECT
location_country AS country,
SUM(new_cases) AS case_count,
SUM(new_deaths) AS fatality_count,
ROUND((SUM(new_deaths) / CAST(SUM(new_cases) AS NUMERIC(10,0))) * 100, 2) AS fatality_percentage
FROM public.covid19_mortality
WHERE continent IS NOT NULL
GROUP BY country
ORDER BY fatality_percentage ASC;

--Covid-19 case-fatality percentage for a specified country.
SELECT
location_country AS country,
SUM(new_cases) AS case_count,
SUM(new_deaths) AS fatality_count,
ROUND((SUM(new_deaths) / CAST(SUM(new_cases) AS NUMERIC(10,0))) * 100, 2) AS fatality_percentage
FROM public.covid19_mortality
--Add any country name in the following line.
WHERE location_country = 'Canada'
GROUP BY country;

--Covid-19 case-population percentage over time.
SELECT
location_country AS country,
date,
population,
total_cases,
ROUND((total_cases / CAST(population AS NUMERIC(10,0))) * 100, 2) AS infection_percentage
FROM public.covid19_mortality
WHERE continent IS NOT NULL
ORDER BY location_country ASC, date ASC;

--Country infection percentage ranking.
SELECT
location_country AS country,
population,
SUM(new_cases) AS infection_count,
ROUND((SUM(new_cases) / CAST(population AS NUMERIC(10,0))) * 100, 2) AS infection_percentage
FROM public.covid19_mortality
WHERE continent IS NOT NULL
GROUP BY location_country, population
HAVING SUM(new_cases) IS NOT NULL
ORDER BY infection_percentage DESC;

--Fatality count per country.
SELECT
location_country AS country,
SUM(new_deaths) AS fatality_count
FROM public.covid19_mortality
WHERE continent IS NOT NULL
GROUP BY location_country
HAVING SUM(new_deaths) IS NOT NULL
ORDER BY fatality_count DESC;

--Fatality count per social class.
SELECT
location_country AS social_class,
SUM(new_deaths) AS fatality_count
FROM public.covid19_mortality
WHERE continent IS NULL AND location_country LIKE '%income'
GROUP BY location_country
ORDER BY fatality_count DESC;

--Fatality count per continent.
SELECT
location_country AS continent,
SUM(new_deaths) AS fatality_count
FROM public.covid19_mortality
WHERE location_country IN('Europe', 'Asia', 'North America',
						  'South America', 'Africa', 'Oceania')
GROUP BY location_country
ORDER BY fatality_count DESC;

--Covid-19 case-fatality percentage over time globally.
SELECT
date,
total_cases AS global_case_count,
total_deaths As global_fatality_count,
ROUND((total_deaths / CAST(total_cases AS NUMERIC(10,0))) * 100, 2) AS fatality_percentage
FROM public.covid19_mortality
WHERE location_country = 'World' AND total_cases IS NOT NULL
GROUP BY date, total_cases, total_deaths
ORDER BY date ASC;

--Covid-19 case-fatality percentage globally.
SELECT
SUM(new_cases) AS global_case_count,
SUM(new_deaths) As global_fatality_count,
ROUND((SUM(new_deaths) / CAST(SUM(new_cases) AS NUMERIC(10,0))) * 100, 2) AS global_fatality_percentage
FROM public.covid19_mortality
WHERE location_country = 'World';

--Running total of vaccinations per country (using a window function).
SELECT
mort.location_country AS country,
mort.date,
new_vaccinations AS vaccinations,
SUM(new_vaccinations) 
	OVER(PARTITION BY mort.location_country ORDER BY mort.date) AS vaccinations_running_total
FROM public.covid19_mortality AS mort
LEFT OUTER JOIN public.covid19_vaccinations AS vac
ON mort.location_country = vac.location_country AND
	mort.date = vac.date
WHERE mort.continent IS NOT NULL --AND new_vaccinations IS NOT NULL
ORDER BY mort.location_country ASC, mort.date ASC;

--Running total of vaccinations per country (using a subquery).
SELECT
mort.location_country AS country,
mort.date,
new_vaccinations AS vaccinations,
(SELECT 
 SUM(new_vaccinations) AS vaccinations_running_total
 FROM public.covid19_vaccinations AS vac
 WHERE mort.date >= vac.date AND mort.location_country = vac.location_country)
FROM public.covid19_mortality AS mort
LEFT OUTER JOIN public.covid19_vaccinations AS vac
ON mort.location_country = vac.location_country AND
	mort.date = vac.date
WHERE mort.continent IS NOT NULL --AND new_vaccinations IS NOT NULL
GROUP BY mort.location_country, mort.date, new_vaccinations
ORDER BY mort.location_country ASC, mort.date ASC
--Used LIMIT to reduce execution time (still takes around a minute).
LIMIT 1429;

--Running total of vaccinations per country (using a CTE)
WITH cte_run_tot_vac
AS(
SELECT
mort.location_country AS country,
mort.date,
new_vaccinations AS vaccinations
FROM public.covid19_mortality AS mort
LEFT OUTER JOIN public.covid19_vaccinations AS vac
ON mort.location_country = vac.location_country AND
	mort.date = vac.date
WHERE mort.continent IS NOT NULL AND new_vaccinations IS NOT NULL
)
SELECT
*,
SUM(vaccinations) 
	OVER(PARTITION BY country ORDER BY date) AS vaccinations_running_total
FROM cte_run_tot_vac;

--Fully vaccinated percentage per country.
SELECT
mort.location_country AS country,
mort.population,
MAX(people_fully_vaccinated) AS fully_vaccinated_count,
ROUND(MAX(people_fully_vaccinated) / CAST(mort.population AS NUMERIC(10,0)) * 100, 2) AS percent_fully_vaccinated
FROM public.covid19_mortality AS mort
LEFT OUTER JOIN public.covid19_vaccinations AS vac
ON mort.location_country = vac.location_country AND
	mort.date = vac.date
WHERE mort.continent IS NOT NULL
GROUP BY mort.location_country, mort.population
ORDER BY percent_fully_vaccinated ASC;

--Fully vaccinated percentage per social class.
SELECT
mort.location_country AS social_class,
mort.population,
MAX(people_fully_vaccinated) AS fully_vaccinated_count,
ROUND(MAX(people_fully_vaccinated) / CAST(mort.population AS NUMERIC(10,0)) * 100, 2) AS percent_fully_vaccinated
FROM public.covid19_mortality AS mort
LEFT OUTER JOIN public.covid19_vaccinations AS vac
ON mort.location_country = vac.location_country AND
	mort.date = vac.date
WHERE mort.continent IS NULL AND mort.location_country LIKE '%income%'
GROUP BY mort.location_country, mort.population
ORDER BY percent_fully_vaccinated ASC;

--Fully vaccinated percentage per continent.
SELECT
mort.location_country AS continent,
mort.population,
MAX(people_fully_vaccinated) AS fully_vaccinated_count,
ROUND(MAX(people_fully_vaccinated) / CAST(mort.population AS NUMERIC(10,0)) * 100, 2) AS percent_fully_vaccinated
FROM public.covid19_mortality AS mort
LEFT OUTER JOIN public.covid19_vaccinations AS vac
ON mort.location_country = vac.location_country AND
	mort.date = vac.date
WHERE mort.continent IS NULL 
	AND mort.location_country IN('Europe', 'Africa', 'Asia', 'Oceania', 'North America', 'South America')
GROUP BY mort.location_country, mort.population
ORDER BY percent_fully_vaccinated ASC;

--Fully vaccinated global percentage.
SELECT
mort.population AS world_population,
MAX(people_fully_vaccinated) AS fully_vaccinated_count,
ROUND(MAX(people_fully_vaccinated) / CAST(mort.population AS NUMERIC(10,0)) * 100, 2) AS percent_fully_vaccinated
FROM public.covid19_mortality AS mort
LEFT OUTER JOIN public.covid19_vaccinations AS vac
ON mort.location_country = vac.location_country AND
	mort.date = vac.date
WHERE mort.location_country LIKE 'World'
GROUP BY mort.population;

--Create a Temporary Table and find the global percent 
--of fully vaccinated citizens that got a booster shot.
DROP TABLE IF EXISTS temp_booster;
CREATE TEMPORARY TABLE temp_booster(
location_country VARCHAR(35),
date DATE,
people_fully_vaccinated BIGINT,
total_boosters BIGINT
);

--Insert data into the temp table.
INSERT INTO temp_booster
SELECT
mort.location_country,
mort.date,
vac.people_fully_vaccinated,
vac.total_boosters
FROM public.covid19_mortality AS mort
LEFT OUTER JOIN public.covid19_vaccinations AS vac
ON mort.location_country = vac.location_country
	AND mort.date = vac.date;
	
--Booster shot global percentage.
SELECT 
MAX(people_fully_vaccinated) AS full_vaccinations_count,
MAX(total_boosters) AS booster_shots_count,
ROUND(MAX(total_boosters) / CAST(MAX(people_fully_vaccinated) 
				AS NUMERIC(10,0)) *100, 2) AS global_booster_percent
FROM temp_booster
WHERE location_country = 'World';

--Create a View and find the global percent 
--of fully vaccinated citizens that got a booster shot.
CREATE OR REPLACE VIEW v_booster
AS
SELECT
mort.location_country,
mort.date,
vac.people_fully_vaccinated,
vac.total_boosters
FROM public.covid19_mortality AS mort
LEFT OUTER JOIN public.covid19_vaccinations AS vac
ON mort.location_country = vac.location_country
	AND mort.date = vac.date;
	
--Booster shot global percentage.
SELECT 
MAX(people_fully_vaccinated) AS full_vaccinations_count,
MAX(total_boosters) AS booster_shots_count,
ROUND(MAX(total_boosters) / CAST(MAX(people_fully_vaccinated) 
				AS NUMERIC(10,0)) *100, 2) AS global_booster_percent
FROM v_booster
WHERE location_country = 'World';
