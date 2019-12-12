--+ holdcas on;
--Create trigger with 'update' event and retrieve the priority from virtual class db_trigger

create class test_class(col1 integer, col2 varchar(20));
create class op_record(operator varchar(20), 
                       op_action varchar(50), 
                       op_time timestamp default '2008-05-27 15:50:58');
create trigger test_trigger
  before update on test_class
  execute insert into op_record
          values(user, 'Update a new record to test_class', '2008-05-27 15:50:58');
  
insert into test_class values(999,'nhn');
insert into test_class values(999,'nhn');
update test_class set col2='nhnchina';
select * from op_record;
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
drop class op_record;

--+ holdcas off;
