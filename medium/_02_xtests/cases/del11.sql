autocommit off;
select ssn, name, dept_no, salary, location
  from employees_v e;
delete from employees_v
 where location = 'marseilles'
    or location = 'surrey';
select ssn, name, dept_no, salary, location
  from employees_v e;
rollback work;
rollback;
