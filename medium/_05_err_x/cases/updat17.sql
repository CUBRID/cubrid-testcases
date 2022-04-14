autocommit off;
update all joe.inventory_v (except joe.employees_v)
   set descr = 'foo';
rollback work;
rollback;
