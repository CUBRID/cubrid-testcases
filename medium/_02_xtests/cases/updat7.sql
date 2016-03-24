autocommit off;
select ssn, name, dept_no, salary, location
  from employees_v e;
update employees_v
   set dept_no = 4,
       location = 'alsace-lorraine'
 where salary > $25000;
select ssn, name, dept_no, salary, location
  from employees_v e order by 1,2,3,4;
rollback work;
rollback;
