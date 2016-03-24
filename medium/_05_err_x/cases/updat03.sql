autocommit off;
update employees_v
   set foo = 'foo';
rollback work;
rollback;
