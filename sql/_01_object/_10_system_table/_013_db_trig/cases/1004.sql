--Create trigger without instance attribute and retrieve the information from virtual class db_trig

create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(999,'nhn');
create trigger test_trigger
  before insert on test_class
  execute print 'Insert a new column(col1) to test_class';
  
select trigger_name, 
       target_class_name,
       target_attr_name
       target_attr_type
from   db_trig
where  trigger_name = 'test_trigger';

drop trigger test_trigger;
drop class test_class;
