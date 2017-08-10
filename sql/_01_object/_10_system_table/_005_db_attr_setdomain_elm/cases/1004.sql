--Test db_attr_setdomain_elm using create class with 'SHARED' attribute and 'set' attribute

create class test_class 
  (col1 set varchar(10) shared NULL, col2 date default '2001-05-05');

insert into test_class(col1) values({'Jerry', 'Tom', 'Disney'});


select attr_name, attr_type, data_type, domain_class_name
from   db_attr_setdomain_elm
where  class_name = 'test_class';

drop class test_class;
