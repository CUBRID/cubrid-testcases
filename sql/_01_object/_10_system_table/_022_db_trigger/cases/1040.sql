--+ holdcas on;
--Create trigger and retrieve the information about action_time from db_trigger

create class test_class(col1 integer, col2 varchar(20));

create trigger test_trigger
  deferred statement delete on test_class
  execute  print 'delete some records from test_class';
  
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');
delete from test_class where col1 = 999;
delete from test_class where col1 = 888;



call login('dba') on class db_user;
select owner, name,action_definition,decode(action_time,1,'BEFORE',
                                                          2,'AFTER',
                                                          3,'DEFRRED',
                                                          'Unkown action time') 
                                      as action_time
from   db_trigger
where  name = 'test_trigger';

drop trigger test_trigger;
drop class test_class;


--+ holdcas off;
