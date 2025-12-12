-- [er] create a table with a FOREIGN key,create unique index on this FOREIGN key


create table p7 (a int primary key, b int);

create table p1 (b int , a int ,FOREIGN KEY (a) REFERENCES p7(a));

create unique index u_idx on p1 ( a);


select attr_name, is_nullable from db_attribute where class_name = 'p1' order by 1;

select index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, status, referential_index_class_owner_name, referential_index_class_name, referential_index_name, delete_rule, update_rule, referential_match_option, index_type, deduplicate_key_level, comment from db_index where class_name = 'p1';

select * from p1;


drop table p1;
drop table p7;
