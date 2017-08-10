--+ holdcas on;
--Create trigger with call action 
create class name_list (name varchar(50));
call login('dba') on class db_user;
create trigger test_trigger
  before insert on name_list
  execute call add_user('test_user') on class db_user;
  
insert into name_list(name) values('test_user');


drop trigger test_trigger;
drop class name_list;
call drop_user('test_user') on class db_user;
--+ holdcas off;
