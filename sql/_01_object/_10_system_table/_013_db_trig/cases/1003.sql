--Create trigger and retrieve the target_attr_name from virtual class db_trig

create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(999,'nhn');
create trigger test_trigger
  before update on test_class(col1)
  execute print 'update new record on col1';
  
select trigger_name, 
       target_class_name,
       target_attr_name
from   db_trig
where  trigger_name = 'test_trigger';

drop trigger test_trigger;
drop class test_class;
