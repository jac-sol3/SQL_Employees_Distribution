use HR;

select * from employees;


-- Date format unification

update employees
set birthdate = convert(date, birthdate),
	hire_date = convert(date, hire_date),
	termdate = case when (termdate is not null and termdate <> '') then convert(date, left(termdate, 19)) else NULL end;


-- Add age column

alter table employees
add age int;

update employees
set age = datediff(year, birthdate, GETDATE());