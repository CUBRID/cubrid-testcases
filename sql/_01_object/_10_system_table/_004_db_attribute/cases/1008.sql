--Test db_attribute by creating class with default set attribute 

create class test_class(col1 integer, 
                        col2 set varchar(10) default{'golf','football'});

insert into test_class(col1) values(999);

select * from test_class;

select attr_name, class_name, default_value
from   db_attribute
where  class_name = 'test_class' order by 1;

drop class test_class;
