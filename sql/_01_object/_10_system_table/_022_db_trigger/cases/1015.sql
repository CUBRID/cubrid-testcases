--+ holdcas on;
--Create trigger with 'commit' event and retrieve the priority from virtual class db_trigger

create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');
create trigger test_trigger
  before commit
  execute print 'The user commit all transcations';



call login('dba') on class db_user;
select owner, name, priority,decode(event,0,'update',
                                          1,'update statement',
                                          2,'delete',
                                          3,'delete statement',
                                          4,'insert',
                                          5,'insert statement',
                                          8,'commit',
                                          9,'rollback','unknown event')as event
from   db_trigger
where  name = 'test_trigger';

drop trigger test_trigger;
drop class test_class;


--+ holdcas off;
