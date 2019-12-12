--+ holdcas on;
--Create trigger and retrieve the status from virtual class db_trigger

create class test_class(col1 integer, col2 varchar(20));
create trigger test_trigger
  status inactive
  before insert on test_class
  execute print 'Insert a new record to test_class';
  
call login('dba') on class db_user;
select owner, name, decode(status,1,'INACTIVE',2,'ACTIVE','Error') as status
from   db_trigger
where  name = 'test_trigger';

drop trigger test_trigger;
drop class test_class;

--+ holdcas off;
