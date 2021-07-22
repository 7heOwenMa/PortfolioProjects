select *
from PortfolioProject..CovidDeaths
--where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

-- select data that we are going to be usuing 

select location, date, total_cases, new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- looking at the total cases vs total deaths
-- shows likelihood of dying if you contract covid in ur country
select location, date, total_cases, total_deaths,(total_deaths / total_cases )* 100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%' and continent is not null
order by 1,2

-- looking at total cases vs population
-- shows what percentage of population got covid

select location, date, total_cases, population,(total_cases / population )* 100 as CovidPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where  continent is not null
order by 1,2


-- what country has the highest rate of infection covid compared to population

select location, population, max(total_cases) as highestInfectionCount, max(total_cases / population )* 100 as percentagePopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by location, population
order by 4 desc

-- showing countries with the highest death count per population

select location, max(cast(total_deaths as int)) as totalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by location 
order by totalDeathCount desc


-- Breaking down by continent

select location, max(cast(total_deaths as int)) as totalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is null
group by location
order by totalDeathCount desc


-- showing the continent with the highest death count per population

select continent, max(cast(total_deaths as int)) as totalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order by totalDeathCount desc


-- global numbers

select date, sum(new_cases) as totalCase, sum(cast(new_deaths as int)) as totalDeaths, sum( cast(new_deaths as int))/ sum(new_cases) * 100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2



-- looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over ( partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	-- convert(int, vac.new_vaccinations)
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- USE CTE

with PopvsVac ( continent, location, date, population,new_vaccinations, RollingPeopleVaccinated) 
as
( select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over ( partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	-- convert(int, vac.new_vaccinations)
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from PopvsVac



-- Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255), 
Date datetime, 
Population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over ( partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	-- convert(int, vac.new_vaccinations)
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated



-- crrate view for a later visualization

Create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over ( partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	-- convert(int, vac.new_vaccinations)
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated






































