autocommit off;
alter vclass inventory_v add method foo(integer) float;
call foo(100) on class inventory_v;
rollback work;
rollback;
