--Testing db_index by creating class with unique index

create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(111,'Jerry');
insert into test_class values(222,'Tom');

create unique index idx_test_class on test_class (col1);

select class_name, index_name, is_unique
from   db_index
where  class_name = 'test_class'
order  by 1;

drop unique index idx_test_class on test_class;
select class_name, index_name, is_unique
from   db_index
where  class_name = 'test_class'
order  by 1;

drop class test_class;
