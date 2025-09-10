-- create a table with a primay key,create reverse index on this primary key


create table p7 (a int primary key, b int);

create reverse  index  ri_p7_a on p7 ( a);

select attr_name, is_nullable from db_attribute where class_name = 'p7' order by 1,2;

SELECT index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, comment, status FROM db_index where class_name = 'p7' order by 1,2;

select * from p7 order by 1,2;



drop table p7;
