autocommit off;
alter vclass joe.inventory_v add method foo(integer) float;
call foo(100) on class [joe.inventory_v];
rollback work;
rollback;
