/* Test 2: drop or rename table */
call login ('dba') on class db_user;
create user u1;

call login ('u1') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 varchar, c2 int);
insert into t1 values ('t1 of u1', 1);
create synonym s1 for t1;
select * from s1;

rename table t1 to t2;
--err case
select * from s1;

select * from db_synonym;
alter synonym s1 for t2;
select * from s1;

drop table t2;
--err case
select * from s1;

call login ('dba') on class db_user;
drop synonym if exists u1.s1;
drop table if exists u1.t1;
drop table if exists u1.t2;
drop user u1;

select * from db_synonym;
select * from db_class where is_system_class = upper ('NO');

