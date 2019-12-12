--+ holdcas on;
--Create trigger and retrieve the owner from virtual class db_trigger

call login('dba') on class db_user;
call add_user('test_user') on class db_user;
call login('test_user') on class db_user;

create class test_class(col1 integer, col2 varchar(20));
create trigger test_trigger
  before insert on test_class
  execute print 'Insert a new record to test_class';
  
call login('dba') on class db_user;
select owner, name
from   db_trigger
where  name = 'test_trigger';

drop trigger test_trigger;
drop class test_class;


call drop_user('test_user') on class db_user;
--+ holdcas off;
