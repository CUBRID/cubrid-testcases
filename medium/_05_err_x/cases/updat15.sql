autocommit off;
update joe.employees_v
   set ssn = set {123123123};
rollback work;
rollback;
