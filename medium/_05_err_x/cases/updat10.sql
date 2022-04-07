autocommit off;

update joe.employees_v
   set ssn = count (dept_no);
select * from joe.employees_v;
rollback work;
rollback;
