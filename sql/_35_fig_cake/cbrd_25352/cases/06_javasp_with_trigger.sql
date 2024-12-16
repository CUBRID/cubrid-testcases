-- Verified for CBRD-25352
-- Create trigger with javasp

evaluate 'create test table';
create table name_list (name varchar(50));
create table name_list2 (name varchar(50));

evaluate 'create test_trigger1: execute call add_user([user_name]) on class db_user';
create trigger test_trigger1
  before insert on name_list
  execute call add_user('test_user') on class db_user;

select unique_name, owner.name, name, action_definition  from db_trigger order by unique_name;

evaluate 'insert data & check result';
insert into name_list(name) values('test_user');
select name from db_user order by name;


evaluate 'create test_trigger2: execute call add_user(class db_user, [user_name])';
create trigger test_trigger2
  before insert on name_list2
  execute call add_user(class db_user, 'test_user2');

evaluate 'insert data & check result';
insert into name_list2(name) values('test_user2');
select name from db_user order by name;

evaluate 'trigger list';
select unique_name, owner.name, name, action_definition  from db_trigger order by unique_name;


evaluate 'create test_trigger3: execute call dba.hello()';
create trigger test_trigger3
  before insert on name_list
  execute call dba.hello();

select unique_name, owner.name, name, action_definition  from db_trigger order by unique_name;


evaluate 'create test_trigger4: execute call public.hello()';
create trigger test_trigger4
  before insert on name_list
  execute call public.HeLlo();

select unique_name, owner.name, name, action_definition  from db_trigger order by unique_name;


evaluate 'create tbl with method m1()';
create table tbl (c1 int)
  method class m1(varchar(255)) int function f1
  file '$home/method';

evaluate 'create test_trigger5: execute call m1(class tbl)';
create trigger test_trigger5
  before insert on name_list
  execute call m1(class Tbl);

select unique_name, owner.name, name, action_definition  from db_trigger order by unique_name;


evaluate 'create test_trigger6: execute call m1()';
create trigger test_trigger6
  before insert on name_list
  execute call m1() on class tbl;

select unique_name, owner.name, name, action_definition  from db_trigger order by unique_name;


evaluate 'Test done';
drop trigger test_trigger1;
drop trigger test_trigger2;
drop trigger test_trigger3;
drop trigger test_trigger4;
drop trigger test_trigger5;
drop trigger test_trigger6;
drop table name_list;
drop table name_list2;
call drop_user('test_user') on class db_user;
call drop_user('test_user2') on class db_user;
