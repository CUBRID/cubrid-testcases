autocommit off;

update employees_v
   set ssn = count (dept_no);
select * from employees_v;
rollback work;
rollback;
