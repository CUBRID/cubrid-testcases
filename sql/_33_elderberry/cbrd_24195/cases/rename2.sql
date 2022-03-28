/*
 *      7. RENAME TABLE WITH TRIGGER. 
 */

create table t1 (c1 int);
create table t2 (c1 int);
create trigger trig1 after insert on t1 execute insert into t2 values (obj.c1);
select class_of, unique_name, class_name, owner.name from _db_class where is_system_class % 8 = 0 order by 1,2;
select unique_name, name, owner.name, target_class, action_definition from db_trigger;
rename table t1 to t3;
rename table t2 to t4;
select class_of, unique_name, class_name, owner.name from _db_class where is_system_class % 8 = 0 order by 1,2;
select unique_name, name, owner.name, target_class, action_definition from db_trigger;
insert into t3 values (2);
select * from t4;

drop table if exists t4;
drop table if exists t3;
drop table if exists t2;
drop table if exists t1;
