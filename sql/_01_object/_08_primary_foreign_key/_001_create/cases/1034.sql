-- create subclass from superclass having primary key

create class a1 (c1 int primary key);

create class a2  under a1  (c2 int  primary key);

select attr_name, is_nullable from db_attribute where class_name = 'a1' order by 1,2;

SELECT index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, comment, status FROM db_index where class_name = 'a1' order by 1,2;

select * from a1 order by 1,2;


select attr_name, is_nullable from db_attribute where class_name = 'a2' order by 1,2;

SELECT index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, comment, status FROM db_index where class_name = 'a2'  order by 1,2;

select * from a2 order by 1,2;

drop a1,a2;
drop a2;
drop a1;

