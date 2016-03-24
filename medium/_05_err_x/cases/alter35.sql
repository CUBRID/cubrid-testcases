autocommit off;
(attr_name string default '10')
method fun(string) float;
alter class foo_c rename method fun as attr_name;
rollback work;
rollback;
