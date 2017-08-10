--Test db_attribute by creating class with default value
create class test_class (col1 integer, col2 date default '2001-05-05');

insert into test_class(col1) values(999);
insert into test_class(col1) values(888);

select * from test_class  order by 1,2;

select attr_name, class_name, default_value
from   db_attribute
where  class_name = 'test_class'  order by 1,2;

drop class test_class;