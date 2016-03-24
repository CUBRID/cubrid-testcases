autocommit off;
create vclass foo_c
(attr_name string default '10')
method fun(string) float;
alter vclass foo_c rename method attr_name as fun;
rollback work;
rollback;
