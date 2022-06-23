/* Test6: change owner of target in alter synonym */
call login ('dba') on class db_user;
drop table if exists t1;
create table t1 (c1 varchar, c2 int);
insert into t1 values ('t1 of dba', 1);
create user u1;
grant select on t1 to u1;

call login ('u1') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 varchar, c2 int);
insert into t1 values ('t1 of u1', 1);
create synonym s1 for t1;
select * from s1;

alter synonym s1 for dba.t1;
select * from s1;

/* u2 does not exist */
--err case
alter synonym s1 for u2.t1;
select * from s1;


call login ('dba') on class db_user;
drop synonym if exists u1.s1;
drop table if exists u1.t1;
drop table if exists t1;
drop user u1;

select * from db_synonym;
select * from db_class where is_system_class = upper ('NO');

