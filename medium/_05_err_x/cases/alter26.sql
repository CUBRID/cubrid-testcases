autocommit off;

create vclass foo
(attr_name string default '10');
alter vclass foo modify attr_name string default 10;
rollback work;
rollback;
