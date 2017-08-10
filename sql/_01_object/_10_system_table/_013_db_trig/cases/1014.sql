--Create trigger with 'BEFORE' action_time and retrieve the information from virtual class db_trig


create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(999,'nhn');


create trigger test_trigger
  before insert on test_class
 if new.col1 = 999  execute  invalidate transaction;
  
select trigger_name, 
       target_class_name,
       target_attr_name,
       target_attr_type,
       action_type,
       action_time
from   db_trig
where  trigger_name = 'test_trigger';



drop trigger test_trigger;
drop class test_class;