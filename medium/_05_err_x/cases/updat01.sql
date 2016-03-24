autocommit off;
update all object
   set name = 'foo';
rollback work;
rollback;
