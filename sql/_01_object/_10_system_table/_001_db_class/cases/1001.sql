--Test db_class using create class and retrieve relative information
create class test_class(col1 integer);
insert into test_class values(999);
insert into test_class values(888);

select class_name, owner_name, 
       class_type,is_system_class, 
       partitioned 
from   db_class
where  class_name = 'test_class';

drop class test_class;