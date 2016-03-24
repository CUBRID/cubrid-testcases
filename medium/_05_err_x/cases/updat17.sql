autocommit off;
update all inventory_v (except employees_v)
   set descr = 'foo';
rollback work;
rollback;
