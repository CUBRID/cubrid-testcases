--Create trigger with 'EVALUATE' action and retrieve the information from virtual class db_trig


create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(999,'nhn');


--about evaluate action
  
select trigger_name, 
       target_class_name,
       target_attr_name,
       target_attr_type,
       action_type
from   db_trig
where  trigger_name = 'test_trigger';



drop trigger test_trigger;
drop class test_class;