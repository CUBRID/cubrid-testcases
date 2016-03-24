autocommit off;

create class foo
class attribute (attr_name string default '10');
alter class foo modify class attribute attr_name string default 10;
rollback work;
rollback;
