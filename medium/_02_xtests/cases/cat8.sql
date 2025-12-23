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
select index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, comment, status 
from db_index
where class_name = 'foo08'
order by index_name;
rollback to savepoint '2';
select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment 
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
