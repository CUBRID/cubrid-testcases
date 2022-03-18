autocommit off;
update joe.employees_v
   set dept_no = 4,
       location = 'alsace-lorraine'
 where salary > $25000;
update joe.employees_v
   set dept_no = 4,
       location = null
 where location = 'marseilles'
    or location = 'surrey';
rollback;
