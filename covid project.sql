select *
from [portfolioproject]..deaths
order by 1,2

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..deaths
Where continent is not null 
order by 1,2

--total deaths vs total cases
Select Location, date, total_cases,total_deaths, (cast(total_deaths as int)/total_cases)*100 as DeathPercentage
From PortfolioProject..deaths
Where location like '%states%'
and continent is not null 
order by 1,2

--Total Cases vs Population
select location, date, population, total_cases, (cast(total_cases as int)/population)*100 as ratio
from Portfolioproject..deaths
where location= 'United States'
order by 1,2


select  location, population, MAX(total_cases) as highestinfected, MAX((total_cases/population))*100 as ratio1
from [Portfolioproject]..deaths
Group by location, population
order by ratio1 desc

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..deaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

select continent, MAX(cast(total_deaths as int)) as td
from [Portfolioproject]..deaths
where continent is not null
Group by continent
order by td desc

select date, SUM(cast(new_cases as int)) as totalnewcase, SUM(cast(new_deaths as int))
from [Portfolioproject]..deaths
where continent is not null
Group by date
order by 1,2

--total population vs vaccinations

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, va.new_vaccinations
, SUM(cast(va.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..deaths dea
Join PortfolioProject..vaccine va
	On dea.location = va.location
	and dea.date = va.date
where dea.continent is not null 
--order by 2,3
)
Select *
From PopvsVac



--select *
--from portfolioproject..vaccine

-- Creating View to store data for later visualizations

Create View populationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..deaths dea
Join PortfolioProject..vaccine vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

select *
from populationvaccinated
