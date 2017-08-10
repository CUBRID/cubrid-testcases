--Create trigger and retrieve the trigger_name from virtual class db_trig

create class test_class(col1 integer, col2 varchar(20));
create trigger test_trigger
  before insert on test_class
  execute print 'Insert a new record to test_class';
  
select trigger_name, target_class_name 
from   db_trig;

drop trigger test_trigger;
drop class test_class;
