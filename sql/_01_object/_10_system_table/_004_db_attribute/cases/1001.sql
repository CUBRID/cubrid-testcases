--Create class and retrieve attribute type from db_attribue

create class test_class(col1 integer,col2 varchar(10));
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');

select attr_name, class_name, attr_type
from db_attribute
where class_name = 'test_class' order by 1;

drop class test_class;
