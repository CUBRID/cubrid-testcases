--[er]Create trigger with commit on target class
create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');

create trigger test_trigger
  before commit on test_class
  execute print 'User rollback the uncommited transcation';

drop class test_class;
drop trigger test_trigger;
