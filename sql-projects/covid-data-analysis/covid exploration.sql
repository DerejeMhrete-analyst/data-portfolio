

select * 
from coviddeaths_1
where continent is not null
order by 3,4 ;

# select data that we are going to be using 

select location, date,
total_cases,new_cases, total_deaths, 
population
from coviddeaths_1
where continent is not null
order by 1,2 ;

-- Looking at total cases vs Total Deaths
-- shows likelihood of dying if you contract covid in your country
select location, date,
total_cases, total_deaths, 
(total_deaths/ total_cases)* 100 as DeathPercentage
from coviddeaths_1
where location like '%Ethio%'
and continent is not null
order by 1,2 ;



-- Looking at Total cases vs Population

select location, date, population,
total_cases, 
(total_cases/ population)* 100 as DeathPercentage
from coviddeaths_1
where location like '%states%'
and continent is not null
order by 1,2 ;

-- Looking at countries with Highest Infection rate compared to Population

select location,  population,
max(total_cases) as HighestInfactionCount,  
max((total_cases/ population))* 100 as PercentagePopulationInfacted
from coviddeaths_1
-- where location like '%Ethio%'
where continent is not null
group by location, population
order by PercentagePopulationInfacted desc ;

-- showing contries with Highest Death Count per population

 select location,  MAX(cast(total_deaths as unsigned)) as TotalDeathCount
 from coviddeaths_1
-- where location like '%Ethio%'
-- SELECT location, MAX(total_deaths) AS TotalDeathCount
-- FROM coviddeaths_1
where continent is not null
group by location
order by TotalDeathCount desc ;



-- let's break things down by continent

select location,  MAX(cast(total_deaths as unsigned)) as TotalDeathCount
 from coviddeaths_1
-- where location like '%Ethio%'
-- SELECT location, MAX(total_deaths) AS TotalDeathCount
-- FROM coviddeaths_1
where continent is null or continent = ''
group by location
order by TotalDeathCount desc ;

-- select * 
-- from coviddeaths_1 
-- where continent is null or continent = ''
-- order by 3,4; 

-- showing continent with the highest death count per population

-- combining two tables looking at total population vs vacination

select dea.continent, dea.location,
dea.date, dea.population, vac.new_vaccinations,
sum(cast( vac.new_vaccinations as unsigned)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from coviddeaths_1 dea
join coviddeaths_vacination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null and dea.continent != ''
order by 2,3;



-- use CTE
with PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as 
(
select dea.continent, dea.location,
dea.date, dea.population, vac.new_vaccinations,
sum(cast( vac.new_vaccinations as unsigned)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from coviddeaths_1 dea
join coviddeaths_vacination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.continent != ''
)