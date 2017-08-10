--+ holdcas on;
--Create trigger and retrieve the information about action_type from db_trigger

create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(999, 'nhn');
insert into test_class values(888, 'nhn');
create trigger test_trigger
  before insert on test_class
  IF new.col2 = 'nhn'
  execute reject;
  

call login('dba') on class db_user;
select owner, name,decode(action_type,  1,'INSERT or UPDATE or DELETE or CALL or EVALUATE',
                                          2,'REJECT',
                                          3,'INVALIDATE_TRANSCATION',
                                          4,'PRINT',
                                          'unknown Action_type')as action_type
from   db_trigger
where  name = 'test_trigger';

drop trigger test_trigger;
drop class test_class;

--+ holdcas off;
