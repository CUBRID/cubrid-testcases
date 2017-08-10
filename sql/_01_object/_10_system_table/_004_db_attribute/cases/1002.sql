--Create class with CLASS attribute and retrieve attribute type from db_attribue

create class test_class 
  class attribute (create_date date, author varchar(10))
  (col1 integer, col2 varchar(10));
  
  
  
update class test_class set (create_date, author) = (to_date('20080405','yyyymmdd'), 'NHN');
insert into test_class values( 999, 'nhncorp');

select attr_name, class_name, attr_type
from db_attribute
where class_name = 'test_class' order by 1,2;

drop class test_class;

