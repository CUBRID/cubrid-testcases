--Test db_attribute by retrieving the attributes of class 'test_subclass' and the super-classes from which they are inherited

create class test_superclass(name varchar(10), age integer);
insert into test_superclass values('Dennis', 28);
insert into test_superclass values('Nancy', 28);

create class test_subclass as subclass of test_superclass
(tel varchar(20), gender char(1));
insert into test_subclass values('Jerry', 28, '13588888888','F');


select attr_name, from_class_name
from db_attribute
where  class_name = 'test_subclass' order by 1;

drop class test_superclass;

select attr_name, from_class_name
from db_attribute
where  class_name = 'test_subclass' order by 1;

drop class test_subclass;