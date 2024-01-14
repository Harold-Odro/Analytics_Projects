SELECT *
FROM Portfolio_Project..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

SELECT *
FROM Portfolio_Project..CovidVaccinations
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..CovidDeaths
WHERE continent is not null
ORDER BY 1,2


--SHOWS PERCENTAGE OF DEATHS TO TOTAL COVID CASES

SELECT location, date, total_cases, total_deaths, 
CONVERT(float,total_deaths)/NULLIF(CONVERT(float,total_cases),0)*100 AS DeathPercentage
FROM Portfolio_Project..CovidDeaths
WHERE location = 'Ghana'
ORDER BY 1,2

--SHOWS WHAT PERCENTAGE OF THE POPULATION GOT COVID

SELECT location, date, total_cases, population, 
(NULLIF(CONVERT(float,total_cases),0)/population)*100 AS PopulationPercentage
FROM Portfolio_Project..CovidDeaths
WHERE location = 'Ghana'
ORDER BY 1,2

--SHOWS COUNTRIES WITH HIGHEST INFECTION RATE PER POPULATION

SELECT location, population, MAX(total_cases) AS HighestInfectionCount,
MAX(NULLIF(CONVERT(float,total_cases),0)/population)*100 AS PopulationInfectedPercentage
FROM Portfolio_Project..CovidDeaths
GROUP BY Location, Population
ORDER BY PopulationInfectedPercentage desc

--SHOWS COUNTRIES WITH HIGHEST DEATHS PER POPULATION

SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc


--SHOWS CONTINETNS WITH HIGHEST DEATH COUNT

SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc



--GLOBAL NUMBERS

SELECT date, SUM(new_cases) AS Total_Cases, SUM(cast(new_deaths as int)) AS Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage--total_cases, total_deaths, 
FROM Portfolio_Project..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

SELECT SUM(new_cases) AS Total_Cases, SUM(cast(new_deaths as int)) AS Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage 
FROM Portfolio_Project..CovidDeaths
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2



--SHOWS TOTAL POPULATION VS TOTAL VACCINATIONS

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.location = 'Ghana'
ORDER BY 2,3


--SHOWS PERCENTAGE OF PEOPLE VACCINATED GLOBALLY

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT*, (RollingPeopleVaccinated/Population)*100 AS PercentageVaccinated
FROM PopvsVac



--SHOWS PERCENTAGE OF PEOPLE VACCINATED IN GHANA

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.location = 'Ghana'
--ORDER BY 2,3

SELECT*, (RollingPeopleVaccinated/Population)*100 AS PercentageVaccinated
FROM #PercentPopulationVaccinated


--CREATING VIEWS

CREATE VIEW TotalPopulationVaccinatedGlobal as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null

SELECT*
FROM TotalPopulationVaccinatedGhana


CREATE VIEW TotalPopulationVaccinatedGhana as
SELECT dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.location = 'Ghana'


CREATE VIEW PercentPopulationVaccinatedGlobal as
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT*, (RollingPeopleVaccinated/Population)*100 AS PercentageVaccinated
FROM PopvsVac

SELECT *
FROM PercentPopulationVaccinatedGlobal

CREATE VIEW PercentPopulationVaccinatedGhana as
WITH PopvsVacGH (Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.location = 'Ghana'
)
SELECT*, (RollingPeopleVaccinated/Population)*100 AS PercentageVaccinated
FROM PopvsVacGH
