--Create index on serial column and retrieve information from db_index_key
create serial seq_test
start with 1
increment by 1
nomaxvalue;

create table ddl_0001(id int primary key, name varchar(20));
insert into ddl_0001 values(seq_test.next_value,'Jerry');
insert into ddl_0001 values(seq_test.next_value,'Tom');
insert into ddl_0001 values(seq_test.next_value,'Hello');
insert into ddl_0001 values(seq_test.next_value,'Dennis');

select index_name, class_name, key_attr_name, key_order
from   db_index_key
where  class_name = 'ddl_0001'
order by index_name, key_order;

drop class ddl_0001;
drop serial seq_test;
