/*

Queries used for COVID-19 Tableau visualizations.

*/

--Dashboard 1

-- 1.
--Covid-19 case-fatality percentage globally.
SELECT
SUM(new_cases) AS global_case_count,
SUM(new_deaths) As global_fatality_count,
ROUND((SUM(new_deaths) / CAST(SUM(new_cases) AS NUMERIC(10,0))) * 100, 2) AS global_fatality_percentage
FROM public.covid19_mortality
WHERE location_country = 'World';

-- 2. 
--Fatality count per continent.
SELECT
location_country AS continent,
SUM(new_deaths) AS fatality_count
FROM public.covid19_mortality
WHERE location_country IN('Europe', 'Asia', 'North America', 'South America', 'Africa', 'Oceania')
GROUP BY location_country
ORDER BY fatality_count DESC;

-- 3.
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

-- 4.
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

-- 5.
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

--Dashboard 2

-- 1.
--Fatality count per social class.
SELECT
location_country AS social_class,
SUM(new_deaths) AS fatality_count
FROM public.covid19_mortality
WHERE continent IS NULL AND location_country LIKE '%income'
GROUP BY location_country
ORDER BY fatality_count DESC;

-- 2.
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

-- 3.
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

-- 4.
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

-- 5.
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

-- 6.
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

-- 7.
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
