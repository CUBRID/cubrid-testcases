autocommit off;

update joe.employees_v
   set ssn = 123123123
 where name = 321321312;
rollback work;
rollback;
