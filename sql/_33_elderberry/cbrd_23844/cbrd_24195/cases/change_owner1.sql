/*
 *      10. CHANGE OWNER WITH AUTO_INCREMENT, ERROR.
 */

create user u1;
create table t1 (c1 int auto_increment);
call login ('u1') on class db_user;
create serial t1_ai_c1;
call login ('dba') on class db_user;
select class_of, unique_name, class_name, owner.name from _db_class where is_system_class % 8 = 0;
select unique_name, name, owner.name from db_serial order by 1;
alter table t1 owner to u1;
select class_of, unique_name, class_name, owner.name from _db_class where is_system_class % 8 = 0;
select unique_name, name, owner.name from db_serial order by 1;

drop serial u1.t1_ai_c1;
drop table t1;
drop user u1;
