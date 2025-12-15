-- create a table with a primay key,create reverse unique index on this primary key


create table p7 (a int primary key, b int);

create reverse unique index  ru_p7_a on p7 ( a);

select attr_name, is_nullable from db_attribute where class_name = 'p7' order by 1,2;

select index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, status, referential_index_class_owner_name, referential_index_class_name, referential_index_name, delete_rule, update_rule, referential_match_option, index_type, deduplicate_key_level, comment from db_index where class_name = 'p7' order by 1,2;

select * from p7 order by 1,2;



drop table p7;
