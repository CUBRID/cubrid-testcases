autocommit off;
select * from employee_c
where ( ssn > 1 and name like '%u' ) or salary > $125000;
	
rollback;
