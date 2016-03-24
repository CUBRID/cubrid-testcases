--Create trigger with delete action 
create class test_class(col1 integer, col2 varchar(20));
create class test_class1(col1 integer, col2 varchar(20));
create trigger test_trigger
  before statement delete on test_class
  execute delete from test_class1 where col2='nhn';
  
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');
insert into test_class1 values(999,'nhn');
insert into test_class1 values(888,'nhn');
delete from test_class where col1 = 999;
delete from test_class where col1 = 888;
select * from test_class1;

drop trigger test_trigger;
drop class test_class;
drop class test_class1;