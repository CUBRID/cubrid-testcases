--Testing db_index by creating class with composing index
create class test_class(col1 integer, col2 varchar(20), col3 date default '2001-05-05');
insert into test_class(col1,col2) values(111,'Jerry');
insert into test_class(col1,col2) values(222,'Tom');

create index idx_test_class on test_class (col1, col2);

select class_name, index_name, is_unique, key_count
from   db_index
where  class_name = 'test_class'
order  by 1;

drop index idx_test_class on test_class;
select class_name, index_name, is_unique, key_count
from   db_index
where  class_name = 'test_class'
order  by 1;

drop class test_class;
