autocommit off;

create class foo
(attr_name string default '10');
alter class foo modify attr_name string default 10;
rollback work;
rollback;
