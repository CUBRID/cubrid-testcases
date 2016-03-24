autocommit off;
update employees_v
   set ssn = {123123123};
rollback work;
rollback;
