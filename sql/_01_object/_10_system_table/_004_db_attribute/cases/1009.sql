--Test db_attribute using test class with "not null" attribute

create class test_class (col1 integer not null, col2 varchar(20));

insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');
insert into test_class values(777,'nhn');
insert into test_class values(666,'nhn');

select attr_name, class_name, is_nullable
from   db_attribute
where  class_name = 'test_class' order by 1;

drop class test_class;
