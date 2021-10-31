--january 28 2020 to october 15 2021

--select * from [covid data]..coviddeaths
--where continent is not null
--order by 3,4

--Total Cases vs Total Deaths

select location , date, total_cases,total_deaths ,(total_deaths/total_cases)*100 as death_percentage
from [covid data]..coviddeaths
Where continent is not null
order by 1,2

--Total Cases vs Population 

select location , date, total_cases,population ,(total_cases/population)*100 as PercentPopulationInfected
from [covid data]..coviddeaths
where continent is not null
order by 1,2


--Countries with the highest infection rate per population

select location , MAX(total_cases) as HighestInfectionCount ,population ,MAX((total_cases/population)*100) as PercentPopulationInfected
from [covid data]..coviddeaths
where continent is not null
group by location ,population
order by PercentPopulationInfected desc

--Death Count in each continent

select continent, MAX(cast(total_deaths as int)) as DeathCount
from [covid data]..coviddeaths
where continent is not null
group by continent
order by DeathCount desc


--GLOBAL NUMBERS

select sum(new_cases) as TotalCases ,sum(cast(new_deaths as int)) as TotalDeathCount,
(sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathRate
from [covid data]..coviddeaths
where continent is not null




--Total Population vs Total Dose per country

select dea.location,max(dea.population) as TotalPopulation,sum(convert(bigint,vac.new_vaccinations)) as TotalDosesAdministered
from [covid data]..coviddeaths as dea
join [covid data]..covidvaccination as vac
   on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
group by dea.location
order by TotalDosesAdministered desc


--Fully vaccinated people in each country

--TEMP TABLE

drop table if exists #vaccinationrate
Create table #vaccinationrate(location nvarchar(255),TotalPopulation numeric,PopulationFullyVaccinated numeric)
insert into #vaccinationrate 
select dea.location,max(dea.population) as TotalPopulation,
   max(convert(bigint,vac.people_fully_vaccinated)) as PopulationFullyVaccinated
from [covid data]..coviddeaths as dea
join [covid data]..covidvaccination as vac
   on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
group by dea.location
Select *,floor((PopulationFullyVaccinated/TotalPopulation)*100) as VaccinationRate from #vaccinationrate


--Views for visualisation

use [covid data]
go
create view TotalDoses 
as
select dea.location,max(dea.population) as TotalPopulation,sum(convert(bigint,vac.new_vaccinations)) as TotalDosesAdministered
from [covid data]..coviddeaths as dea
join [covid data]..covidvaccination as vac
   on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
group by dea.location
go

select * from TotalDoses




