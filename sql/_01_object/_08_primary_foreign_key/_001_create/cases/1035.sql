-- create primary key on subclass from superclass having primary key

create class a1 (c1 int primary key);

create class a2  under a1  (c2 int );

select attr_name, is_nullable from db_attribute where class_name = 'a1';

select index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, status, referential_index_class_owner_name, referential_index_class_name, referential_index_name, delete_rule, update_rule, referential_match_option, index_type, deduplicate_key_level, comment from db_index where class_name = 'a1';

select * from a1;


select attr_name, is_nullable from db_attribute where class_name = 'a2' order by 1;

select index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, status, referential_index_class_owner_name, referential_index_class_name, referential_index_name, delete_rule, update_rule, referential_match_option, index_type, deduplicate_key_level, comment from db_index where class_name = 'a2';

select * from a2;

drop a1,a2;
