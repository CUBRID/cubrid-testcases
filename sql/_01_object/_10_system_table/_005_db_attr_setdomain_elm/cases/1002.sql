--Test db_attr_setdomain_elm using create class with "multiset" attribute

create class test_class(col1 integer, col2 multiset varchar(10));

insert into test_class values(999, {'Jerry', 'Tom', 'Disney','Tom'});
select * from test_class;

select attr_name, attr_type, data_type, domain_class_name
from   db_attr_setdomain_elm
where  class_name = 'test_class';

drop class test_class;