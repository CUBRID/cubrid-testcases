autocommit off;
  from joe.employees_v e;
update rdb.employees_v
   set dept_no = 4,
       location = 'oxbridge'
 where location = 'marseilles'
    or location = 'surrey';
select ssn, name, dept_no, salary, location
  from joe.employees_v e;
rollback work;
rollback;
