-- create table with self reference foreign key

create table p2 (b int primary key, a int,FOREIGN KEY (a) REFERENCES p2(a));

select attr_name, is_nullable from db_attribute where class_name = 'p2' order by 1,2;

SELECT index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, comment, status FROM db_index where class_name = 'p2' order by 1,2;

select * from p2 order by 1,2;

drop p2;
