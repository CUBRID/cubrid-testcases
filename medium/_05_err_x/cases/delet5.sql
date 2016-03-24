autocommit off;

delete from inventory_v
 where descr setneq {'a', 'b'};
rollback work;
rollback;
