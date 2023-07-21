use HR;


-- The analysis was carried out for all active employees

select * from employees
where termdate > GETDATE() -- employees whose contract has not expired yet
	or termdate is NULL; -- employees with a perpetual contract

--------------------------------------------------
-- Questions to Analyze

-- 1. What is the gender distribution of employees in the company?

select gender, count(gender)
from employees
where termdate > GETDATE() or termdate is NULL
group by gender
order by count(gender) desc;

-- 2. What is the ethnicity distribution of employees in the company?

select race, count(race)
from employees
where termdate > GETDATE() or termdate is NULL
group by race
order by count(race) desc;

-- 3. What is the age distribution of employees in the company?

select min(age) as youngest, max(age) as oldest
from employees
where termdate > GETDATE() or termdate is NULL;

select
	case
		when age < 25 then '<25'
		when age between 25 and 34 then '25 - 34'
		when age between 35 and 44 then '35 - 44'
		when age between 45 and 54 then '45 - 54'
		else '55+'
	end as age_group,
	--gender,
	count(*) as count
from employees
where termdate > GETDATE() or termdate is NULL
group by 
	case
		when age < 25 then '<25'
		when age between 25 and 34 then '25 - 34'
		when age between 35 and 44 then '35 - 44'
		when age between 45 and 54 then '45 - 54'
		else '55+'
		end
	--gender
order by 1 asc, 2 asc;

-- 4. How many employees work at headquarters vs remote locations?

select location, count(*)
from employees
where termdate > GETDATE() or termdate is NULL
group by location;

-- 5. What is the average length of employment for employees who have been terminated?

select round(avg(cast(DATEDIFF(YEAR, HIRE_date, termdate) as float)), 2) as avg_employment_length
from employees
where termdate is not NULL and termdate <= GETDATE();

-- 6. What is the gender distribution across departments and job titles?

select department, gender, count(*)
from employees
where termdate > GETDATE() or termdate is NULL
group by department, gender
order by department, gender;

select jobtitle, gender, count(*)
from employees
where termdate > GETDATE() or termdate is NULL
group by jobtitle, gender
order by jobtitle, gender;

-- 7. What is the distribution of job titles across the company?

select jobtitle, count(*)
from employees
where termdate > GETDATE() or termdate is NULL
group by jobtitle
order by jobtitle;

-- 8. Which department has the highest turnover rate?

select department, round(terminated_count/total_count, 4) as rate
from (
	select 
		department, 
		cast(count(*) as float) as total_count,
		cast(sum(case when (termdate is not null and termdate <= GETDATE()) then 1 else 0 end) as float) as terminated_count
	from employees
	group by department) a
order by 2 desc;


-- 9. What is the distribution of employees across locations by city and state?

select location_city, count(*)
from employees
where termdate > GETDATE() or termdate is NULL
group by location_city
order by 2 desc;

select location_state, count(*)
from employees
where termdate > GETDATE() or termdate is NULL
group by location_state
order by 2 desc;

-- 10. How has the company's employee count changed over time based on hire and term dates?

with employees_over_years as (
select
	year(hire_date) as year,
	count(*) as hired_empl,
	sum(case when (termdate is not null and termdate <= GETDATE()) then 1 else 0 end) as term_empl
from employees
group by YEAR(hire_date))

select
	year,
	hired_empl,
	term_empl,
	(hired_empl - term_empl) as change
from employees_over_years
order by year asc;

-- 11. What is the the average length of employment for each department?

select department, round(avg(cast(DATEDIFF(YEAR, hire_date, termdate) as float)), 1)
from employees
where termdate is not NULL and termdate <= GETDATE()
group by department
order by 2 desc;
