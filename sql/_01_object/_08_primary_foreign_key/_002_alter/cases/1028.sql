-- [er]create class and add primary key on MULTISET data type

create class aoo ( a MULTISET primary key, b int, c int );
alter class aoo add primary key(a);

select attr_name, is_nullable from db_attribute where class_name = 'aoo' order by 1,2;

SELECT index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, comment, status FROM db_index where class_name = 'aoo';

select * from aoo;

drop aoo;