--+ holdcas on;
--Create trigger and retrieve the information about condition_type from db_trigger
create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(999, 'nhn');
insert into test_class values(888, 'nhn');
create trigger test_trigger
  before delete on test_class
  IF obj.col2 = 'nhn'
  execute reject;
  

call login('dba') on class db_user;
select owner, name, priority,decode(condition_type,
                                      1,'INSERT or UPDATE or DELETE or CALL or EVALUATE',
                                      2,'REJECT',
                                      3,'INVALIDATE_TRANSACTION',
                                      4,'PRINT','Unknown condition_type')
                              as condition_type
from   db_trigger
where  name = 'test_trigger';

drop trigger test_trigger;
drop class test_class;

--+ holdcas off;
