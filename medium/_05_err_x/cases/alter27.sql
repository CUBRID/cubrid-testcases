autocommit off;

create vclass foo
class attribute (attr_name string default '10');
alter vclass foo modify class attribute attr_name string default 10;
rollback work;
rollback;
