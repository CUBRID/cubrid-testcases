autocommit off;
call login('dba', '') on class db_user;
savepoint 1;
create class foo08;
savepoint '2';
alter class foo08 add attribute fa int;
alter class foo08 add method m_fa(int) int;
savepoint aaa;
create index i_foo08_a on foo08(fa);
rollback to savepoint aaa;
select * 
from db_index 
where class_name = 'foo08' 
order by index_name;
rollback to savepoint '2';
select * 
from db_attribute 
where class_name = 'foo08' 
order by attr_name, attr_type;
select * 
from db_method 
where class_name = 'foo08' 
order by meth_name, meth_type;
rollback to savepoint 1;
select * 
from db_class 
where class_name = 'foo08' 
order by class_name;
call login('dba', '') on class db_user;
rollback;
