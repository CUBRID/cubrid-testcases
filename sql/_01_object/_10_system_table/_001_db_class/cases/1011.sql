--Create class with unique of constraint and retrieve information from db_class

create class test_class(
a integer,
b integer,
UNIQUE(a,b));

insert into test_class values(1, 2);
insert into test_class values(1, 3);

select * from test_class;
select class_name, owner_name, class_type, is_system_class, partitioned
from   db_class
where class_name = 'test_class';

drop class test_class;