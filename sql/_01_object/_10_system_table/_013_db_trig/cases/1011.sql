--+ holdcas on;
--Create trigger with 'CALL' action and retrieve the information from virtual class db_trig

call login('dba') on class db_user;
create user test_user;
create class drop_list(col2 varchar(100));



create trigger test_trigger
  before insert on drop_list
  execute call drop_user('test_user') on class db_user;
  
select trigger_name, 
       target_class_name,
       target_attr_name,
       target_attr_type,
       action_type
from   db_trig
where  trigger_name = 'test_trigger';


insert into drop_list values('test_user');

drop trigger test_trigger;
drop class drop_list;
--+ holdcas off;
