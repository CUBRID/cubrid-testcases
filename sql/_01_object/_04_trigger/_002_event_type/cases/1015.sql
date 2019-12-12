--Create trigger with commit tigger event type
create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');

create trigger test_trigger
  before rollback 
  execute print 'User rollback the uncommited transcation';


select * from test_class order by 1,2;


drop class test_class;
drop trigger test_trigger;
