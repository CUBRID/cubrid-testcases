--Create trigger with statement update tigger event type
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
          values(user, 'update record of test_class', '2008-05-27 15:50:58');

update test_class set col2 = 'nhnchina' where col1=999;
update test_class set col2 = 'nhnchina' where col1=888;

select * from op_record;


drop trigger test_trigger;
drop class test_class;
drop class op_record;
