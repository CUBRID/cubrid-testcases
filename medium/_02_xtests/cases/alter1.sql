autocommit off;
create class foo_c
(attr_name string default '10')
method fun(string) float;
create vclass foo_v
(attr_name string default '10')
method fun(string) float
as select attr_name from foo_c;
alter class foo_c rename method fun as funbar;
rollback work;
rollback;
