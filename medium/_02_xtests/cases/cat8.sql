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
select index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, status, index_type, deduplicate_key_level, comment 
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
select class_name, owner_name, class_type, is_system_class, tde_algorithm, statistics_strategy, partitioned, is_reuse_oid_class, collation, comment 
from db_class 
where class_name = 'foo08' 
order by class_name;
call login('dba', '') on class db_user;
rollback;
