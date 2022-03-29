/*
 *      13. RENAME AND CHNAGE OWNER SERIAL, AUTO_INCREMENT, TRIGGER.
 */

create user u1;
create user u2;
create table t1 (c1 int auto_increment);
create table t2 (c1 int);
create trigger trig1 after insert on t1 execute insert into t2 values (obj.c1);
call login ('u2') on class db_user;
select user;
create table t1 (c1 int);
create table t2 (c1 int);
create trigger trig2 after insert on t1 execute insert into t2 values (obj.c1);
call login ('dba') on class db_user;
select class_of, unique_name, class_name, owner.name from _db_class where is_system_class % 8 = 0 order by 1,2;
select unique_name, name, owner.name from db_serial;
call change_serial_owner ('dba.t1_ai_c1', 'u1') on class db_serial;
select unique_name, name, owner.name, target_class, action_definition from db_trigger order by 1;
rename trigger trig1 to trig2;
select unique_name, name, owner.name, target_class, action_definition from db_trigger order by 1;
insert into t1 values (1);
select * from t2;
call change_trigger_owner ('trig2', 'u1') on class db_root;
select unique_name, name, owner.name, target_class, action_definition from db_trigger order by 1;
insert into t1 values (2);
select * from t2;
call change_trigger_owner ('u1.trig2', 'u2') on class db_root;
select unique_name, name, owner.name, target_class, action_definition from db_trigger order by 1;
insert into t1 values (3);
select * from t2;

drop trigger u2.trig2;
drop table u2.t2;
drop table u2.t1;
drop trigger u1.trig2;
drop table t2;
drop table t1;
drop user u2;
drop user u1;
