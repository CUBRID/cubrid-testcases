autocommit off;

delete from joe.inventory_v
 where descr setneq {'a', 'b'};
rollback work;
rollback;
