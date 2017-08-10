--+ holdcas on;
--Create trigger and retrieve the information about action_type from db_trigger

create class name_list (name varchar(50));
call login('dba') on class db_user;
create trigger test_trigger
  before insert on name_list
  execute call add_user('test_user') on class db_user;
  
insert into name_list(name) values('test_user');


select owner, name,decode(action_type,  1,'INSERT or UPDATE or DELETE or CALL or EVALUATE',
                                          2,'REJECT',
                                          3,'INVALIDATE_TRANSCATION',
                                          4,'PRINT',
                                          'unknown Action_type')as action_type
from   db_trigger
where  name = 'test_trigger';

drop trigger test_trigger;
drop class name_list;
call drop_user('test_user') on class db_user;

--+ holdcas off;
