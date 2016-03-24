autocommit off;
create vclass foo_v
(attr_name string default '10')
method fun(string) float;
alter vclass foo_v rename method fun as attr_name;
rollback work;
rollback;
