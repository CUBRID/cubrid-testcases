/* Test5: create synonyms for non-privileged objects */
call login ('dba') on class db_user;
drop table if exists t1;
create table t1 (c1 varchar, c2 int);
insert into t1 values ('t1 of dba', 1);
create user u1;
select name from db_user;

call login ('u1') on class db_user;
create synonym s1 for dba.t1;
select * from db_synonym;
--err case
select * from s1;

call login ('dba') on class db_user;
grant select on t1 to u1;

call login ('u1') on class db_user;
select * from s1;

call login ('dba') on class db_user;
--err case
drop user u1;

drop synonym if exists u1.s1;
drop table if exists t1;
drop user u1;

select name from db_user;
select * from db_synonym;
select * from db_class where is_system_class = upper ('NO');

