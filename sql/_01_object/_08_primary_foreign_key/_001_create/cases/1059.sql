-- [er] create table with self reference foreign key but no pk

create table p2 (b int , a int,FOREIGN KEY (a) REFERENCES p2(a));

select attr_name, is_nullable from db_attribute where class_name = 'p2';

select index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, status, referential_index_class_owner_name, referential_index_class_name, referential_index_name, delete_rule, update_rule, referential_match_option, index_type, deduplicate_key_level, comment from db_index where class_name = 'p2';

select * from p2;

drop p2;
