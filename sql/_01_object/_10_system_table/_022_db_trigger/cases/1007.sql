--+ holdcas on;
--Create triggers with different priority and retrieve the priority from virtual class db_trigger

create class test_class(col1 integer, col2 varchar(20));
create class insert_record(col1 varchar(50), insert_time date);
create trigger low_priority_trigger
  priority 1.0
  before insert on test_class
  execute insert into insert_record values('insert a row with priority 1.0', '08/08/2008');

create trigger high_priority_trigger
  priority 2.0
  before insert on test_class
  execute insert into insert_record values('insert a row with priority 2.0', '08/08/2008');

create trigger default_priority_trigger
  before insert on test_class
  execute insert into insert_record values('insert a row with default priority', '08/08/2008');  
insert into test_class values(999,'nhn');
select * from insert_record
order by insert_time, col1 asc;
  
call login('dba') on class db_user;
select owner, name, priority
from   db_trigger
where  name in ('low_priority_trigger','high_priority_trigger') 
order by 1,2;

drop trigger high_priority_trigger;
insert into test_class values(999,'nhn');

drop trigger low_priority_trigger;
drop trigger default_priority_trigger;
drop class test_class;
drop class insert_record;
--+ holdcas off;
