autocommit off;

update employees_v
   set ssn = set {};
rollback work;
rollback;
