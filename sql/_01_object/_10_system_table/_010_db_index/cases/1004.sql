--Testing db_index by creating class with primary key constraint
create class test_class(col1 integer primary key, col2 varchar(20), col3 date default '2001-05-05');
insert into test_class(col1,col2) values(111,'Jerry');
insert into test_class(col1,col2) values(222,'Tom');


select class_name, index_name, is_unique, key_count,is_primary_key
from   db_index
where  class_name = 'test_class'
order  by 1;

drop class test_class;