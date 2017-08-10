--Create class with unique of constraint and retrieve information from db_class
create class test_class(
a integer,
UNIQUE(a));

insert into test_class values(1);
insert into test_class values(2);
select class_name, owner_name, class_type, is_system_class, partitioned
from   db_class
where class_name = 'test_class';

select * from test_class;

drop class test_class;