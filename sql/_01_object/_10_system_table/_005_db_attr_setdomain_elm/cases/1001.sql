--Test db_attr_setdomain_elm using create class with "class attribute" and "set attribute"

create class test_class 
  class attribute (create_date date, author varchar(10))
  (col1 set varchar(10));

insert into test_class values({'Jerry', 'Tom', 'Disney'});
update class test_class set (create_date, author) = (to_date('20080405','yyyymmdd'), 'NHN');

select attr_name, attr_type, data_type, domain_class_name
from   db_attr_setdomain_elm
where  class_name = 'test_class';

drop class test_class;


