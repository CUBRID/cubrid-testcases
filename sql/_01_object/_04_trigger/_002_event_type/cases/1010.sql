--Create trigger with statement delete tigger event type
create class test_class(col1 integer, col2 varchar(20));
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');
insert into test_class values(999,'nhn');
insert into test_class values(888,'nhn');

create class op_record(operator varchar(20), 
                       op_action varchar(50), 
                       op_time timestamp default '2008-05-27 15:50:58');
create trigger test_trigger
  before statement delete on test_class
  execute insert into op_record
          values(user, 'delete a record from test_class', '2008-05-27 15:50:58');
  
delete from test_class where col1=999;
delete from test_class where col1=888;
select * from op_record;


drop trigger test_trigger;
drop class test_class;
drop class op_record;
