--Create index on serial column and retrieve information from db_index
create serial seq_test
start with 1
increment by 1
nomaxvalue;

create table ddl_0001(id int primary key, name varchar(20));
insert into ddl_0001 values(seq_test.next_value,'Jerry');
insert into ddl_0001 values(seq_test.next_value,'Tom');
insert into ddl_0001 values(seq_test.next_value,'Hello');
insert into ddl_0001 values(seq_test.next_value,'Dennis');

select index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, comment, status from db_index
where class_name = 'ddl_0001';

drop class ddl_0001;
drop serial seq_test;
