--Create trigger with 'DELETE' action and retrieve the information from virtual class db_trig

create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(999,'nhn');
create class test_insert(act_class varchar(100));
insert into test_insert values('test');
create trigger test_trigger
  before insert on test_class
  execute delete from  test_insert where act_class='test';
  
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
