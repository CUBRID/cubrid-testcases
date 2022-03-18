autocommit off;
select ssn, name, dept_no, salary, location
  from joe.employees_v e;
delete from joe.employees_v
 where location = 'marseilles'
    or location = 'surrey';
select ssn, name, dept_no, salary, location
  from joe.employees_v e;
rollback work;
rollback;
