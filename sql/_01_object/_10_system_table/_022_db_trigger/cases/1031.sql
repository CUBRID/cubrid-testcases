--+ holdcas on;
--Create trigger and retrieve the information about action_type from db_trigger

create class test_class(col1 integer, col2 varchar(20));
create class test_class1(col1 integer, col2 varchar(20));
create trigger test_trigger
  before statement delete on test_class
  execute update test_class1 set col2='nhnchina';
  
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');
insert into test_class1 values(999,'nhn');
insert into test_class1 values(888,'nhn');
delete from test_class where col1 = 999;
delete from test_class where col1 = 888;
select * from test_class1 order by 1,2;



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
drop class test_class1;

--+ holdcas off;
