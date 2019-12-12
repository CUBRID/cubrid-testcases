--Testing db_index by creating class with foreign key constraint

create class test_class(col1 integer primary key, col2 varchar(20));
insert into test_class values(111,'Jerry');
insert into test_class values(222,'Tom');


create class ref_test_class(col1 integer, col2 varchar(10),
                           foreign key(col1) references test_class(col1));
select class_name, index_name, is_unique, 
       key_count,is_primary_key, is_foreign_key
from   db_index
where  class_name in ('test_class','ref_test_class')
order  by 1;


drop class ref_test_class;
drop class test_class;