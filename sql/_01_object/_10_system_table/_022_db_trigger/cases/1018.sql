--+ holdcas on;
--Create trigger without target class attribute and retrieve the information from db_trigger

create class test_class(col1 integer, col2 varchar(20));
create trigger test_trigger
  before update on test_class
  execute print 'Insert a new record to test_class';
  
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');


  
call login('dba') on class db_user;
select owner, name, priority, event, target_class, target_attribute
from   db_trigger
where  name = 'test_trigger';

drop trigger test_trigger;
drop class test_class;

--+ holdcas off;
