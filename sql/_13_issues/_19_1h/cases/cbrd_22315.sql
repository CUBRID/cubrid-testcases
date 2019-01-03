drop if exists test_class;
create class test_class (
col1 integer,
col2 date default '2001-05-05',
col3 timestamp  default '2001-05-05 08:00:00' on update current_timestamp
);

insert into test_class(col1) values(999);

insert into test_class(col1) values(888);

select * from test_class  order by 1,2;

select attr_name, class_name, default_value
from   db_attribute
where  class_name = 'test_class'  order by 1,2;

alter class test_class modify column col2 date default '2001-05-05' on update current_timestamp;

select attr_name, class_name, default_value
from   db_attribute
where  class_name = 'test_class'  order by 1,2;

drop class test_class;
