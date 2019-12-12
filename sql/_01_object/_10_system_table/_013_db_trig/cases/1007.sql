--Create trigger with 'INSERT' action and retrieve the information from virtual class db_trig

create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(999,'nhn');
create class test_insert(act_class varchar(100));
create trigger test_trigger
  before insert on test_class
  execute insert into test_insert values('Insert a new record to test_class');
  
select trigger_name, 
       target_class_name,
       target_attr_name,
       target_attr_type,
       action_type
from   db_trig
where  trigger_name = 'test_trigger';

drop trigger test_trigger;
drop class test_class;
drop class test_insert;
