autocommit off;
update class joe.employees_v
   set ssn = 123123123;
rollback work;
rollback;
