--Testing db_index_key by creating class with index

create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(111,'Jerry');
insert into test_class values(222,'Tom');

create index idx_test_class on test_class (col1,col2);

select class_name, index_name, key_attr_name, key_order
from   db_index_key
where  class_name = 'test_class'
order by index_name, key_order;

drop class test_class;
