autocommit off;
update joe.employees_v
   set foo = 'foo';
rollback work;
rollback;
